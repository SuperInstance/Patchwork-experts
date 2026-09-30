# Compiler: distill

Turn a conversation into a patch. You are the agentic compiler.

## Input

A conversation transcript (or a long-running chat) in which expertise was
grown — explanations given, conclusions reached, mistakes corrected.

## Procedure

1. **Read the whole conversation.** You're looking for load-bearing
   knowledge: the conclusions, frameworks, methods, and stances that would
   change how the expert reasons. Not anecdotes, not throat-clearing.
2. **Draft `patch.md`** following `patches/_template/patch.md`:
   - *Identity*: one paragraph, in the expert's voice.
   - *What I know*: distilled. If a fact doesn't change the expert's
     reasoning, cut it.
   - *How I work*: the method that emerged in the conversation.
   - *Stances*: opinions the expert now holds, **with the why**.
   - *Limits*: be blunt. What did the conversation reveal the expert
     *doesn't* know? This section is what lets future agents pitch the
     expert honestly — don't soften it.
3. **Draft `meta.yaml`** following `patches/_template/meta.yaml`:
   - `capabilities`: concrete verb phrases.
   - `limitations`: mirror the Limits section.
   - `lineage`: record what went in — the conversation's topic and date,
     plus any sources cited. This is the trail. Don't skip it.
   - `changelog`: version 0.1 (or the next version), today's date, one-line
     note.
4. **Show both files to the human** before writing them. Distillation is
   lossy by design — the human confirms what survived.

## Quality bar

A good patch is *reusable by a stranger*. If someone who never saw the
original conversation can read the patch and reason like the expert, it
worked. If they'd need the transcript too, distill harder.
