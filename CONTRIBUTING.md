# Contributing

Publishing a patch is a pull request. Opening the PR is proposing;
merging is approval. That's the whole mechanism — the community
infrastructure is GitHub itself.

## Adding a new expert

1. Copy `patches/_template/` to `patches/<your-slug>/`.
2. Grow the expert in conversation with your AI agent, then ask it to
   distill the result using `compiler/distill.md`.
3. Fill in `meta.yaml` — especially `limitations` and `lineage`.
4. Add an entry to `experts.json`.
5. Open a PR. In the description, say what the expert is and what went
   into it (a sentence or two is fine).

## Updating an expert

Use `compiler/freeze.md`, bump the version per `SPEC.md`, open a PR.
If it's someone else's expert, that's a fork-and-PR like any open-source
contribution — or fork the whole repo and let your variant live its own life.

## The review bar

- **Distilled, not dumped.** If the patch reads like a transcript, it
  needs another pass.
- **Honest limits.** A patch with no limitations listed will be asked
  for them. The limits are what make the expert trustworthy.
- **Lineage recorded.** What went in, what was kept, what changed.
  No trail, no merge.
- **Spec-conformant.** Two files, right sections, valid YAML. (The
  template makes this easy.)

## The seed crystal rule

Learned something about *using* patchwork itself? That belongs in
`patches/patchwork-guide/` as a version bump. The manual improves the
same way everything else here does.
