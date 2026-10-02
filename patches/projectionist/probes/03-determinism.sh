#!/usr/bin/env bash
# Probe 03 — determinism.
# Claim: the same input rendered twice produces byte-identical output.
# The patch teaches "deterministic input beats clever input" — render the
# same still repeatedly while tuning. If the renderer isn't deterministic,
# that whole discipline is a lie.
# Failure looks like: two runs differing (timestamps in output, randomness,
# unordered dict iteration leaking into the feed).
set -u
NAME="03-determinism"

PATCH_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RENDER="$PATCH_DIR/render.py"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

ffmpeg -v error -f lavfi -i "gradients=size=64x32:rate=1:duration=1" -frames:v 1 "$TMP/grad.png" \
    || { echo "FAIL $NAME: could not generate fixture"; exit 1; }

python3 "$RENDER" "$TMP/grad.png" --cols 40 --engine glyph --frames 1 >"$TMP/a.txt" 2>"$TMP/err" \
    || { echo "FAIL $NAME: first run failed: $(cat "$TMP/err")"; exit 1; }
python3 "$RENDER" "$TMP/grad.png" --cols 40 --engine glyph --frames 1 >"$TMP/b.txt" 2>/dev/null \
    || { echo "FAIL $NAME: second run failed"; exit 1; }

cmp -s "$TMP/a.txt" "$TMP/b.txt" \
    || { echo "FAIL $NAME: identical input gave different output"; exit 1; }

echo "PASS $NAME"
