# Patch format spec — v0.1

## Design principles

1. **Aggressively boring.** A patch is plain Markdown plus a small YAML file. No proprietary runtime, no special tooling to read it. Any LLM on any system can consume it — that *is* the portability story.
2. **Minimal and stable.** Like a pin layout: few fields, rarely changed. We learn what needs standardizing by watching where the format breaks, not by predicting it.
3. **Provenance is non-negotiable.** Every patch records what went into it and what changed between versions. An expert you can't audit is just somebody's opinions with extra steps.
4. **Build patches, not quilts.** Every patch should be worth keeping even if the quilt never comes. The quilt is what emerges when enough good patches exist — a consequence, never a blueprint. Frameworks are for things that can't stand alone.

## Anatomy of a patch

A patch is a directory: `patches/<slug>/` containing exactly two files.

### `patch.md` (required)

The expert's frozen state — distilled knowledge, not a transcript. Sections:

```markdown
# {Expert name}

## Identity
Who this expert is, in one paragraph. Voice, background, perspective.

## What I know
The load-bearing knowledge. Distilled: conclusions, frameworks, key facts —
not the raw material they came from. If it doesn't change how the expert
reasons, it doesn't belong here.

## How I work
The expert's method. How it approaches problems, what it checks first,
how it handles uncertainty.

## Stances
Opinions the expert holds and *why*. Stances are versioned knowledge —
they're allowed to change, but the change gets recorded.

## Limits
What this expert doesn't know, won't do, or is bad at. Be blunt.
```

Keep it tight. A patch that takes longer to read than to use has failed.

### `meta.yaml` (required)

```yaml
name: Sourdough Sage            # human-readable
slug: sourdough-sage            # matches the directory name
version: 1.2                    # major.minor
author: octocat                 # who grew it
description: >-                 # one or two sentences, for the index
  A baker's expert on sourdough: starters, fermentation, troubleshooting.
capabilities:                   # what it's good for — concrete verbs
  - diagnosing starter problems
  - designing fermentation schedules
limitations:                    # what it's bad at — be honest
  - not a professional food-safety authority
  - weak on gluten-free baking
lineage:                        # what went into it (the trail)
  - "40-conversation bake log, distilled 2026-09"
  - "Tartine Bread, chapters 3-5"
changelog:
  - version: 1.2
    date: 2026-09-28
    note: "Added cold-fermentation study; corrected hydration advice for high-altitude."
  - version: 1.0
    date: 2026-09-01
    note: "Initial freeze."
```

## Versioning

`major.minor`. Bump **minor** when knowledge is refined or extended. Bump **major** when stances or method change — i.e., the expert now *thinks* differently, not just *knows* more. Every bump gets a changelog entry. No silent edits.

## What the spec does NOT cover

The spec covers the *patch*, not the *harness*. How a particular agent instantiates a patch (a seeded side chat, a system prompt, an API call) is platform-specific and lives outside this spec. The patch itself stays universal.
