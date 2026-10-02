# Probes — a pilot

## What a probe is

A probe is a **falsifiable claim about a patch**, written as a script. Three parts, no more:

1. **The claim** — one sentence, in the script's comments. What the patch promises.
2. **How to run it** — the script itself. It sets up whatever it needs, checks the claim, and exits.
3. **What failure looks like** — a nonzero exit and a `FAIL` line saying what broke.

A probe that can't fail is a compliment, not a probe. If you can't write the failure case first, you don't have a probe yet.

## The deal

Probes are **payload**, not format. SPEC.md already says a patch may carry anything readable as payload — probes are a new kind of muscle, and they fit the existing pins without changing them.

- Probes live in `patches/<slug>/probes/`, one runnable script per probe: `NN-short-name.sh`. (The runner executes directly when the exec bit survived, and otherwise falls back to the shebang's interpreter — files created through the GitHub API lose their exec bit, so a fresh clone must still run.)
- Exit `0` means pass. Anything else means fail.
- Print `PASS <name>` or `FAIL <name>: <reason>` so a human can read the log without a decoder ring.
- Bash or python3 only. No new dependencies, no network, no side effects outside a temp dir you clean up.
- Keep it fast — under a couple of minutes per probe. A probe suite nobody runs is decoration.

## The runner

`run-probes.sh <patch-dir>` finds every probe under the patch's `probes/` directory, runs them one at a time, and prints a tally. It exits `0` only if every probe passes. That's the whole harness — deliberately too small to argue with.

## What probes are not (yet)

Not a test suite for the repo. Not CI. Not a publish gate — the human still decides what merges, and a failing probe is information, not a veto. This is a pilot: a few patches carry probes, we watch where the idea bends, and *then* we decide what deserves standardizing. Per principle 2, we learn by watching where the format breaks, not by predicting it.

## Writing a good probe

Probe the **contract**, not the implementation. The projectionist's probes don't check how `render_glyph` indexes its array — they check that a black frame renders dense and a white frame renders sparse, because *that's the promise*. When the implementation changes, contract probes keep passing. When the promise breaks, they catch it. The deliberate-break demo in this pilot (an inverted ramp) is caught by exactly one probe, which is how you know the probes are aimed right.
