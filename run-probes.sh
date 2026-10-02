#!/usr/bin/env bash
# run-probes.sh — run every probe in a patch's probes/ directory.
#
# Usage: run-probes.sh <patch-dir>   (e.g. run-probes.sh patches/projectionist)
#
# Discovers <patch-dir>/probes/*.sh, runs each one, prints a tally.
# Exits 0 only if every probe passes. That's the whole harness.
set -u

if [ $# -ne 1 ]; then
    echo "usage: run-probes.sh <patch-dir>" >&2
    exit 2
fi

PATCH_DIR="$1"
PROBE_DIR="$PATCH_DIR/probes"

if [ ! -d "$PROBE_DIR" ]; then
    echo "no probes: $PROBE_DIR does not exist" >&2
    exit 2
fi

probes=( "$PROBE_DIR"/*.sh )
if [ ! -e "${probes[0]}" ]; then
    echo "no probes: nothing in $PROBE_DIR" >&2
    exit 2
fi

pass=0; fail=0; failed_names=()
for probe in "${probes[@]}"; do
    name="$(basename "$probe" .sh)"
    # Run it: directly if executable, otherwise via the interpreter named in
    # the shebang. (Files created through the GitHub API land without the
    # exec bit, so a fresh clone must still run.)
    cmd=("$probe")
    if [ ! -x "$probe" ]; then
        first_line="$(head -n 1 "$probe")"
        case "$first_line" in
            *python3*) cmd=(python3 "$probe") ;;
            *)         cmd=(bash "$probe") ;;
        esac
    fi
    # Give each probe two minutes; a hung probe is a failed probe.
    if command -v timeout >/dev/null 2>&1; then
        out="$(timeout 120 "${cmd[@]}" 2>&1)"
        code=$?
        [ $code -eq 124 ] && out="FAIL $name: timed out after 120s"
    else
        out="$("${cmd[@]}" 2>&1)"
        code=$?
    fi
    # The probe's own last line is the verdict; echo it for the log.
    echo "$out" | tail -n 1
    if [ $code -eq 0 ]; then
        pass=$((pass+1))
    else
        fail=$((fail+1)); failed_names+=("$name")
    fi
done

echo "---"
echo "probes: $pass passed, $fail failed"
if [ $fail -gt 0 ]; then
    echo "failed: ${failed_names[*]}"
    exit 1
fi
exit 0
