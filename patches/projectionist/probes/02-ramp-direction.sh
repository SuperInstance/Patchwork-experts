#!/usr/bin/env bash
# Probe 02 — ramp direction.
# Claim: the glyph ramp runs dark -> dense, light -> sparse. A pure-black
# frame renders with no empty cells; a pure-white frame renders all empty.
# Failure looks like: an inverted ramp (this exact bug shipped once during
# development) — black renders as blank, white as solid.
set -u
NAME="02-ramp-direction"

PATCH_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RENDER="$PATCH_DIR/render.py"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

for color in black white; do
    ffmpeg -v error -f lavfi -i "color=$color:s=64x32:d=1" -frames:v 1 "$TMP/$color.png" \
        || { echo "FAIL $NAME: could not generate $color fixture"; exit 1; }
done

body_of() { python3 "$RENDER" "$1" --cols 40 --engine glyph --frames 1 2>/dev/null | tail -n +2 | sed '/^$/d'; }

black_body="$(body_of "$TMP/black.png")"
white_body="$(body_of "$TMP/white.png")"
[ -n "$black_body" ] || { echo "FAIL $NAME: empty body for black input"; exit 1; }
[ -n "$white_body" ] || { echo "FAIL $NAME: empty body for white input"; exit 1; }

# Black must contain no space cells at all.
if printf '%s\n' "$black_body" | grep -q ' '; then
    echo "FAIL $NAME: black frame rendered with empty cells (ramp inverted?)"
    exit 1
fi
# White must contain nothing BUT space cells.
if printf '%s\n' "$white_body" | grep -qv '^ *$'; then
    echo "FAIL $NAME: white frame rendered with dense cells (ramp inverted?)"
    exit 1
fi

echo "PASS $NAME"
