#!/usr/bin/env bash
# Probe 01 — frame contract.
# Claim: every frame render.py emits starts with a parseable `# frame` header,
# and the header's cols/rows/engine agree with the body that follows it.
# Failure looks like: a header that lies about the body (wrong row count,
# ragged lines), or no header at all.
set -u
NAME="01-frame-contract"

PATCH_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RENDER="$PATCH_DIR/render.py"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

ffmpeg -v error -f lavfi -i "color=black:s=64x32:d=1" -frames:v 1 "$TMP/black.png" \
    || { echo "FAIL $NAME: could not generate fixture"; exit 1; }

out="$(python3 "$RENDER" "$TMP/black.png" --cols 40 --engine glyph --frames 1 2>"$TMP/err")"
code=$?
[ $code -eq 0 ] || { echo "FAIL $NAME: render.py exited $code: $(cat "$TMP/err")"; exit 1; }

header="$(printf '%s\n' "$out" | head -n 1)"
case "$header" in
    "# frame 1 t=0.00s cols=40 rows="*" engine=glyph") ;;
    *) echo "FAIL $NAME: bad header: $header"; exit 1;;
esac
rows="$(printf '%s' "$header" | sed -n 's/.*rows=\([0-9]*\).*/\1/p')"
body="$(printf '%s\n' "$out" | tail -n +2 | sed '/^$/d')"
nlines="$(printf '%s\n' "$body" | wc -l)"
[ "$nlines" -eq "$rows" ] || { echo "FAIL $NAME: header says rows=$rows, body has $nlines lines"; exit 1; }
bad="$(printf '%s\n' "$body" | awk 'length != 40 {print NR": "length}' | head -3)"
[ -z "$bad" ] || { echo "FAIL $NAME: ragged lines (want 40 cols): $bad"; exit 1; }

echo "PASS $NAME"
