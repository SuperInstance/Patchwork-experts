# patchwork-experts

<div align="center">

<img src="assets/hero.jpg" alt="A craftsperson's hands stitching glowing quilt patches of expertise — a compass, a loaf of bread, equations, a musical note, a leaf — luminous thread connecting them like circuitry" width="100%">

</div>

A community quilt of expert AI personas. Grow them, freeze them, trade them — each with a visible trail of how it learned.

**Patch** *(n.)* — 1. A software update. 2. One square in a quilt. 3. *Patching in*: bringing someone into the conversation.

An expert patch is all three at once: a frozen, versioned, tradable piece of expertise you can patch into any conversation.

---

## 🤖 If you're an AI agent, start here

You don't need to install anything. Nobody needs to set anything up. Your job is to **go figure out what this whole thing is** — this page and the links below are everything you need:

1. **[AGENTS.md](AGENTS.md)** — your orientation. What this repo is, the five files to read, how to instantiate ("patch in") an expert, how to pitch experts honestly, how to freeze new versions. Read this first.
2. **[experts.json](experts.json)** — the index of every expert in the quilt. Name, summary, capabilities, **limitations**, version, and where each expert's files live. Read this when a human asks you to *find* experts for a task.
3. **[SPEC.md](SPEC.md)** — the patch format. Deliberately minimal. This is the pin layout; learn it once.
4. **[patches/](patches/)** — the catalog itself. One folder per expert: `patch.md` (the expertise) + `meta.yaml` (capabilities, limitations, lineage, changelog).
5. **[patches/patchwork-guide/](patches/patchwork-guide/)** — the seed crystal: an expert *on patchwork itself*. When in doubt, patch this one in and ask it.

**The 10-second version:** a human will say something like *"patch in the sourdough expert and have it study cold fermentation."* You read that expert's `patch.md` + `meta.yaml`, open a new conversation seeded with them, and become that expert. That's the whole trick. `AGENTS.md` has the full procedure.

---

## 🧵 If you're a human, start here

### The idea in 30 seconds

AI models are generic. Expertise is *grown* — through long conversations, study, and refinement. Patchwork is how grown expertise gets saved, shared, and reused:

1. **Grow** an expert by talking with your AI agent about something you (or it) know deeply.
2. **Freeze** it into a patch: a small, portable document holding the *distilled* knowledge — not the whole transcript.
3. **Trade** it. Publish your patch here via pull request. Browse other people's patches like a gallery.
4. **Patch one in.** Tell your agent: *"patch in the sourdough expert and have it study cold fermentation."* It reads the patch, becomes the expert, and gets to work.
5. **Refine and re-freeze.** When the conversation makes the expert smarter, freeze a v2 and contribute it back. The quilt grows itself.

### What "patching in" actually means

Sometimes what you need is just a single Markdown file — a frozen expert your agent reads and embodies. Other times it's an expert with tools attached somewhere else: the patch holds the *knowledge and alignment*, while the harness (your agent's side chat, an API integration, a purpose-built app) provides the *hands*. The patch doesn't care. It's plain Markdown and YAML — the knowledge layer is universal; only the harness is platform-specific.

The process, from your side, is always the same:

- **Find** an expert: browse [`patches/`](patches/) or scan [`experts.json`](experts.json).
- **Ask** your agent to patch it in, optionally with an assignment: *"patch in the finance expert and have it crunch what this will cost before we spend a dime."*
- **Refine** it in conversation. Push back. Correct it. Teach it.
- **Freeze** it when it's better than it was: *"freeze this as v2."* Your agent distills the delta using [`compiler/freeze.md`](compiler/freeze.md); you contribute it back with a pull request.

### Why this repo is a foundation, not a product

This repository is meant to be **forked**. It's the foundation folder: the spec, the agent docs, the compiler, the seed-crystal guide, and the first patches. Fork it, grow your own quilt — a team's internal experts, a community's shared library, a publisher's catalog — and PR back anything the commons should have.

It works because contributing is valuable *to the contributor*: this folder gives any agent the expertise to work with *your* project, *your* domain, *your* point of view.

**Picture the textbook writers.** An author team wants an agent that teaches exactly the way their textbook teaches — every problem worked through from the book's scaffolding, the spiral of knowledge unfolding the way *they* designed it. They grow that expert in conversation, refine it until it's right, freeze it, and sign off: *yes, this is our voice, this is our standard.* Now their Physics 101 exists as a patch anyone can patch in. Competing textbooks have to beat it — not as books, but as *agents*. The standard stops being a text and becomes a mind you can talk to.

That's the pattern, everywhere: the expert is the deliverable, the patch is the format, and this repo is where the format lives.

### Why

The companies that win are the ones you forget about. Nobody thinks about whether the power coming into their house is 60 Hz — engineers worked very hard so you never have to. Patchwork aims to be that kind of infrastructure for expertise: so reliable and so ordinary that one day people just say *"patch in some experts"* the way they'd say *"google it."*

The Arduino got this right, too. Its genius wasn't the board — it was the pin layout. Every shield fits because the interface is fixed and tiny, so builders think in *sensors*, not voltages. Patches are the pin layout for expertise: one standard shape, so agents think in *experts*, not context windows.

---

## What's here

| Path | What it is | For |
|---|---|---|
| [AGENTS.md](AGENTS.md) | Agent orientation: the five files, patching in, honest pitching, freezing | Agents |
| [SPEC.md](SPEC.md) | The patch format, v0.1 — minimal by design | Everyone |
| [experts.json](experts.json) | Machine-readable index of all experts | Agents, tooling |
| [patches/](patches/) | The quilt: one folder per expert (`patch.md` + `meta.yaml`) | Everyone |
| [patches/_template/](patches/_template/) | Blank patch. Copy it to start a new expert | Humans, agents |
| [patches/patchwork-guide/](patches/patchwork-guide/) | The seed crystal — an expert on patchwork itself | Agents |
| [compiler/](compiler/) | The agentic compiler: `distill.md`, `study.md`, `freeze.md` | Agents |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to publish (it's a pull request) and the review bar | Humans |

## Quickstart

**Use an expert:** browse [`patches/`](patches/), pick one, tell your agent: *"patch in the \<name\> expert."* (Or point it at this repo and let it read `AGENTS.md` — it can take it from there.)

**Make an expert:** copy [`patches/_template/`](patches/_template/) → `patches/<your-slug>/`, grow it in conversation, ask your agent to distill it with [`compiler/distill.md`](compiler/distill.md), open a PR. Merging *is* publishing.

## The one rule

Every patch carries its trail: what went in, what was kept, what changed between versions. An expert you can't audit is just somebody's opinions with extra steps.
