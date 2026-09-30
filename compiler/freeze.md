# Compiler: freeze

Turn a refined conversation into a new patch version.

## Input

- The expert's current `patch.md` and `meta.yaml`.
- A conversation in which the expert was refined: corrections, new
  knowledge, changed stances, discovered limits.

## Procedure

1. **Diff, don't rewrite.** Identify exactly what changed versus the current
   patch: new knowledge, corrected knowledge, new/changed stances,
   newly discovered limits.
2. **Decide the version bump** (see `SPEC.md`):
   - *Minor*: knowledge refined or extended. The expert knows more.
   - *Major*: stances or method changed. The expert thinks differently.
3. **Update `patch.md`** with the delta, keeping the existing structure.
   Distill — don't paste conversation excerpts.
4. **Update `meta.yaml`**:
   - Adjust `capabilities` / `limitations` if they shifted.
   - Append to `lineage`: what this round of refinement consisted of.
   - Add a `changelog` entry: version, date, and a plain-language note
     saying what changed and why. If a stance flipped, record the reasoning.
5. **Show the diff to the human** before finalizing. Then update
   `experts.json` (bump the version).

## Quality bar

Someone reading the changelog a year from now should understand *why* the
expert changed, not just *that* it did. Write the note for them.
