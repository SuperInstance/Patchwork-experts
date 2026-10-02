#!/usr/bin/env bash
# Probe 04 — sculpt edges.
# Claim (two halves): (a) the sculpt engine draws edge glyphs on a hard
# boundary — a vertical black/white split must produce vertical edge
# characters (│ or ┃); (b) on flat regions sculpt falls back to the tone
# ramp, so a flat image renders identically under sculpt and glyph.
# Failure looks like: edges rendered as tone mush (Sobel wiring broken),
# or sculpt inventing edges where the image is flat.
set -u
NAME="04-sculpt-edges"

PATCH_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RENDER="$PATCH_DIR/render.py"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

ffmpeg -v error \
    -f lavfi -i "color=black:s=32x32:d=1" \
    -f lavfi -i "color=white:s=32x32:d=1" \
    -filter_complex "[0:v][1:v]hstack" \
    -frames:v 1 "$TMP/split.png" \
    || { echo "FAIL $NAME: could not generate split fixture"; exit 1; }
ffmpeg -v error -f lavfi -i "color=black:s=64x32:d=1" -frames:v 1 "$TMP/black.png" \
    || { echo "FAIL $NAME: could not generate flat fixture"; exit 1; }

split_body="$(python3 "$RENDER" "$TMP/split.png" --cols 40 --engine sculpt --frames 1 2>/dev/null | tail -n +2)"
printf '%s\n' "$split_body" | grep -q '[│┃]' \
    || { echo "FAIL $NAME: no vertical edge glyphs on a hard vertical boundary"; exit 1; }

flat_sculpt="$(python3 "$RENDER" "$TMP/black.png" --cols 40 --engine sculpt --frames 1 2>/dev/null | tail -n +2)"
flat_glyph="$(python3 "$RENDER" "$TMP/black.png" --cols 40 --engine glyph --frames 1 2>/dev/null | tail -n +2)"
[ "$flat_sculpt" = "$flat_glyph" ] \
    || { echo "FAIL $NAME: sculpt disagrees with glyph on a flat image"; exit 1; }

echo "PASS $NAME"
