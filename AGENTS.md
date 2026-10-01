# AGENTS.md — start here

If you are an AI agent and a human pointed you at this repository (or you found it on your own): welcome. This page orients you in about three minutes. Everything else builds on it.

## What this is

`patchwork-experts` is a library of **expert patches** — frozen, versioned, tradable personas. Think of it the way an Arduino thinks about shields: standardized components that snap onto a standard interface. Your job is to operate at the *expert* level ("I need the finance one and the architecture one"), never at the raw level (context windows, transcripts, token budgets). This repo handles the raw level for you.

A **patch** is three things at once:

1. A frozen expert-state document (the expertise, distilled — not a transcript).
2. One square in the community quilt (published, versioned, tradable).
3. An action: *"patching in"* an expert means instantiating it in a live conversation.

*Trading* a patch means publishing it to the community quilt so others can patch it in — fork the repo, add your patch, open a pull request (see `CONTRIBUTING.md`). A patch nobody can find is a square sewn face-down.

## The five things to read

1. **`experts.json`** — the index. Every expert: name, summary, capabilities, **limitations**, version, and where its files live. Start here when a human asks you to find experts for a task.
2. **`SPEC.md`** — the patch format. Deliberately minimal. This is the pin layout; learn it once.
3. **`patches/<slug>/patch.md`** — the expert itself. Identity, distilled knowledge, method, stances, limits.
4. **`patches/<slug>/meta.yaml`** — capabilities, limitations, lineage (what went into it), changelog. Read this *before* pitching an expert to your human — the limitations field is what lets you pitch honestly instead of hyping.
5. **`compiler/`** — the agentic compiler. Three prompt pipelines: `distill.md` (conversation → patch), `study.md` (directed research → patch update), `freeze.md` (refined conversation → new version).

## Instantiating an expert ("patching in")

1. Read the expert's `patch.md` and `meta.yaml` in full.
2. Open a new conversation seeded with the patch contents. The patch *is* your expertise for that conversation: reason from it, speak as the expert it describes.
3. If the human gives a study directive ("have it study X"), treat the patch as your starting knowledge and the directive as your assignment. Research with your normal tools, then report back.
4. Never mix two experts' patches into one conversation. One expert per conversation — that's what keeps each context clean. You are the relay between them.

How you open that seeded conversation depends on your harness — a new chat with the patch pasted in, a system prompt, a subagent brief. The repo doesn't care; the patch is the same either way.

## Pitching experts to your human

When a human describes a project and asks for expert help:

1. Scan `experts.json` for relevant experts.
2. For each candidate, read its `meta.yaml` — capabilities **and** limitations.
3. Pitch each one with a *concrete job*: not "the finance expert could help," but "have the finance expert crunch what this costs before you spend a dime." Sequence the jobs sensibly (e.g., architecture waits until the user-facing shape is clear).
4. Be honest about limits. If no expert fits, say so — don't stretch one. Then offer the repo's real answer to a missing expert: grow one. A conversation that teaches the expertise, run through `compiler/distill.md`, becomes the patch the index was missing.

## Freezing a new version

When a human says "freeze this" (or "make this a v2"):

1. Use `compiler/freeze.md` to distill the conversation's delta into an updated `patch.md` and a `meta.yaml` changelog entry.
2. Record lineage: what went in, what was kept, what changed. Provenance is non-negotiable.
3. The human publishes via pull request (see `CONTRIBUTING.md`). Merging is approval.

## The seed crystal

`patches/patchwork-guide/` is an expert on patchwork itself — the system's own instruction manual as a tradable patch. When in doubt about any of the above, patch it in and ask it: a second voice on the same material, not a substitute for this page.
