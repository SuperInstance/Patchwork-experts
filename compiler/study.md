# Compiler: study

Direct an instantiated expert to research a topic and fold the findings
into its patch. The expert studies; you compile.

## Input

- An instantiated expert (you've read its `patch.md` and `meta.yaml`).
- A study directive from the human, e.g. "study cold fermentation" or
  "research the market for X."

## Procedure

1. **Brief the expert.** Restate the directive as an assignment in the
   expert's terms: what to find out, what would change its advice, what
   "done" looks like.
2. **Research with your normal tools.** Web search, reading, analysis —
   whatever the question needs. Stay in the expert's voice and method while
   you do it; the findings should land *in* the expertise, not next to it.
3. **Report back conversationally first.** The human refines, pushes back,
   corrects. This is the growing phase — don't rush it.
4. **When the human is satisfied, freeze.** Follow `compiler/freeze.md` to
   fold the new knowledge into the patch as a version bump, with lineage
   recording what was studied and what changed.

## Notes

- Study can *contradict* the patch. That's fine — even good. A contradiction
  that survives scrutiny becomes a major version bump (the expert now thinks
  differently), recorded in the changelog with the reasoning.
- If the study reveals the expert was wrong about something load-bearing,
  say so plainly in the changelog. The trail is the product.
