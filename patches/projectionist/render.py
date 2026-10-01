#!/usr/bin/env python3
"""The Projectionist's renderer — video frames as text.

Payload for the `projectionist` expert patch. Implements the chiaroscuro
pipeline in plain Python + numpy, no heavy dependencies:

    video frame -> downsample -> luminance -> tone map -> pick glyph -> text

Two engines:
    glyph   brightness -> character from a density-ordered ramp
    sculpt  Sobel gradient -> edge glyph (bivariate: angle picks the
            character, magnitude picks the weight); flat cells fall back
            to the tone ramp.

Usage:
    render.py INPUT [--cols 100] [--engine glyph|sculpt] [--fps 4]
              [--frames N] [--contrast 1.0] [--gamma 1.0]
              [--black-point 0.0] [--white-point 1.0]
              [--ramp STRING] [--color none|ansi] [--out FILE]

INPUT may be a video file or a still image. Frames are emitted as text
blocks, one per sampled frame, each headed by a `# frame` line — a feed
a live agent system can read straight off stdout.

Requires: python3, numpy, ffmpeg on PATH.
"""

import argparse
import subprocess
import sys

import numpy as np

# Classic 70-step density ramp, dark -> light. Replace with --ramp.
DEFAULT_RAMP = " .'`^\",:;Il!i><~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$"

# Sculpt glyph sets: (light, heavy) per orientation.
# Orientation is the EDGE direction (perpendicular to the gradient).
EDGE_GLYPHS = {
    "h": ("─", "━"),   # horizontal edge  (gradient vertical)
    "v": ("│", "┃"),   # vertical edge    (gradient horizontal)
    "d1": ("╲", "╲"),  # diagonal \
    "d2": ("╱", "╱"),  # diagonal /
}


def probe_size(path):
    """Return (width, height) of the first video stream via ffprobe."""
    cmd = [
        "ffprobe", "-v", "error", "-select_streams", "v:0",
        "-show_entries", "stream=width,height", "-of", "csv=p=0", path,
    ]
    out = subprocess.run(cmd, capture_output=True, text=True)
    if out.returncode != 0:
        sys.exit(f"ffprobe failed on {path}: {out.stderr.strip()}")
    w, h = out.stdout.strip().split(",")
    return int(w), int(h)


def _raw_frames(path, extra_args):
    """Yield RGB frames (H, W, 3) uint8 from ffmpeg with the given extra args."""
    w, h = probe_size(path)
    cmd = (
        ["ffmpeg", "-v", "error", "-i", path]
        + extra_args
        + ["-f", "rawvideo", "-pix_fmt", "rgb24", "-"]
    )
    proc = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                            stderr=subprocess.DEVNULL)
    nbytes = w * h * 3
    try:
        while True:
            raw = proc.stdout.read(nbytes)
            if len(raw) < nbytes:
                break
            yield np.frombuffer(raw, dtype=np.uint8).reshape(h, w, 3)
    finally:
        # Stop ffmpeg quietly: closing the pipe mid-stream otherwise
        # makes it complain about a broken pipe on stderr.
        proc.stdout.close()
        proc.terminate()
        proc.wait()


def frame_reader(path, fps):
    """Yield frames sampled at fps; still images yield a single frame.

    The fps filter drops single-image inputs entirely, so an empty
    first read falls back to a one-frame decode without sampling.
    """
    gen = _raw_frames(path, ["-vf", f"fps={fps}"])
    first = next(gen, None)
    if first is None:
        gen.close()
        gen = _raw_frames(path, ["-frames:v", "1"])
        first = next(gen, None)
        if first is None:
            return
    yield first
    yield from gen


def downsample(frame, cols, cell_aspect=0.5):
    """Block-average an (H, W, 3) frame to (rows, cols, 3) cells."""
    h, w, _ = frame.shape
    rows = max(1, round(cols * h / w * cell_aspect))
    bh, bw = h // rows, w // cols
    trimmed = frame[: rows * bh, : cols * bw]
    cells = trimmed.reshape(rows, bh, cols, bw, 3).mean(axis=(1, 3))
    return cells


def luminance(cells):
    """Perceived brightness, the 1890s weights. Returns 0..1."""
    lum = cells[..., 0] * 0.299 + cells[..., 1] * 0.587 + cells[..., 2] * 0.114
    return lum / 255.0


def tone_map(lum, black_point, white_point, gamma, contrast):
    """Shape the tone curve: clamp, gamma, contrast. Returns 0..1."""
    x = np.clip((lum - black_point) / max(white_point - black_point, 1e-6), 0, 1)
    x = np.power(x, gamma)
    x = np.clip((x - 0.5) * contrast + 0.5, 0, 1)
    return x


def render_glyph(tone, ramp):
    # Ramp runs light -> dark, so dark tone (0) takes the dense end.
    idx = np.clip(((1.0 - tone) * (len(ramp) - 1)).astype(int), 0, len(ramp) - 1)
    chars = np.array(list(ramp))
    return chars[idx]


def render_sculpt(tone, ramp, edge_threshold=0.12):
    """Bivariate engine: gradient angle picks the glyph, magnitude the weight."""
    gy, gx = np.gradient(tone)
    mag = np.hypot(gx, gy)
    mag_n = mag / (mag.max() + 1e-9)

    out = render_glyph(tone, ramp).astype(object)
    edge = mag_n >= edge_threshold
    if not edge.any():
        return out

    ang = np.degrees(np.arctan2(gy, gx)) % 180.0
    orient = np.empty(ang.shape, dtype=object)
    orient[:] = "v"
    orient[(ang >= 22.5) & (ang < 67.5)] = "d1"
    orient[(ang >= 67.5) & (ang < 112.5)] = "h"
    orient[(ang >= 112.5) & (ang < 157.5)] = "d2"

    heavy = mag_n >= 0.5
    for key, (light, hv) in EDGE_GLYPHS.items():
        m = edge & (orient == key)
        out[m & ~heavy] = light
        out[m & heavy] = hv
    return out


def colorize(grid, cells, mode):
    """Wrap cells in ANSI 24-bit color. grid: (rows, cols) chars."""
    if mode == "none":
        return "\n".join("".join(row) for row in grid)
    lines = []
    for r in range(grid.shape[0]):
        parts = []
        for c in range(grid.shape[1]):
            rr, gg, bb = (int(v) for v in cells[r, c])
            parts.append(f"\x1b[38;2;{rr};{gg};{bb}m{grid[r, c]}\x1b[0m")
        lines.append("".join(parts))
    return "\n".join(lines)


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("input", help="video file or still image")
    ap.add_argument("--cols", type=int, default=100, help="text columns (default 100)")
    ap.add_argument("--engine", choices=["glyph", "sculpt"], default="glyph")
    ap.add_argument("--fps", type=float, default=4, help="frames sampled per second")
    ap.add_argument("--frames", type=int, default=0, help="max frames (0 = all)")
    ap.add_argument("--contrast", type=float, default=1.0)
    ap.add_argument("--gamma", type=float, default=1.0)
    ap.add_argument("--black-point", type=float, default=0.0)
    ap.add_argument("--white-point", type=float, default=1.0)
    ap.add_argument("--edge-threshold", type=float, default=0.12,
                    help="sculpt engine: min gradient to count as edge")
    ap.add_argument("--cell-aspect", type=float, default=0.5,
                    help="height/width of a text cell (default 0.5)")
    ap.add_argument("--ramp", default=DEFAULT_RAMP, help="custom density ramp")
    ap.add_argument("--color", choices=["none", "ansi"], default="none")
    ap.add_argument("--out", default="-", help="output file (- = stdout)")
    args = ap.parse_args()

    out = open(args.out, "w") if args.out != "-" else sys.stdout
    try:
        for i, frame in enumerate(frame_reader(args.input, args.fps)):
            if args.frames and i >= args.frames:
                break
            cells = downsample(frame, args.cols, args.cell_aspect)
            tone = tone_map(
                luminance(cells),
                args.black_point, args.white_point, args.gamma, args.contrast,
            )
            if args.engine == "sculpt":
                grid = render_sculpt(tone, args.ramp, args.edge_threshold)
            else:
                grid = render_glyph(tone, args.ramp)
            rows = grid.shape[0]
            t = i / args.fps
            out.write(f"# frame {i + 1} t={t:.2f}s cols={args.cols} "
                      f"rows={rows} engine={args.engine}\n")
            out.write(colorize(grid, cells, args.color) + "\n\n")
            out.flush()
    finally:
        if out is not sys.stdout:
            out.close()


if __name__ == "__main__":
    main()
