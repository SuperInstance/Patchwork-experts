# patchwork-experts

A community quilt of expert AI personas. Grow them, freeze them, trade them — each with a visible trail of how it learned.

**Patch** *(n.)* — 1. A software update. 2. One square in a quilt. 3. *Patching in*: bringing someone into the conversation.

An expert patch is all three at once: a frozen, versioned, tradable piece of expertise you can patch into any conversation.

## The idea in 30 seconds

AI models are generic. Expertise is *grown* — through long conversations, study, and refinement. Patchwork is how that grown expertise gets saved, shared, and reused:

1. **Grow** an expert by talking with your AI agent about something you know (or want it to learn).
2. **Freeze** it into a patch: a small, portable document holding the distilled knowledge — not the whole transcript.
3. **Trade** it. Publish your patch here via pull request. Browse other people's patches like a gallery.
4. **Patch one in.** Tell your agent: *"patch in the sourdough expert and have it study cold fermentation."* It reads the patch, becomes the expert, and gets to work.
5. **Refine and re-freeze.** When the conversation makes the expert smarter, freeze a v2 and contribute it back. The quilt grows itself.

## Why

The companies that win are the ones you forget about. Nobody thinks about whether the power coming into their house is 60 Hz — engineers worked very hard so you never have to. Patchwork aims to be that kind of infrastructure for expertise: so reliable and so ordinary that one day people just say *"patch in some experts"* the way they'd say *"google it."*

The Arduino got this right, too. Its genius wasn't the board — it was the pin layout. Every shield fits because the interface is fixed and tiny, so builders think in *sensors*, not voltages. Patches are the pin layout for expertise: one standard shape, so agents think in *experts*, not context windows.

## What's here

| File | What it is |
|---|---|
| `AGENTS.md` | **If you're an AI agent, start here.** How to read, instantiate, and freeze patches. |
| `SPEC.md` | The patch format. Deliberately minimal — the pin layout. |
| `experts.json` | Machine-readable index of every expert in the quilt. |
| `patches/` | The quilt itself. One folder per expert: `patch.md` + `meta.yaml`. |
| `patches/_template/` | Blank patch template. Copy it to start a new one. |
| `patches/patchwork-guide/` | The seed crystal: an expert on patchwork itself. The system bootstraps by containing its own instruction manual as a tradable expert. |
| `compiler/` | The agentic compiler: prompts for distilling conversations into patches, directing study, and freezing new versions. |
| `CONTRIBUTING.md` | How to publish a patch (it's a pull request). |

## Quickstart

**I want to use an expert.** Browse `patches/`, pick one, and tell your AI agent: *"Read `patches/<name>/patch.md` and `meta.yaml`, then patch that expert into a new conversation."* (If your agent knows patchwork, just say *"patch in the \<name\> expert."*)

**I want to make an expert.** Copy `patches/_template/` to `patches/<your-slug>/`, grow it in conversation with your agent, then ask your agent to distill it using `compiler/distill.md`. Open a PR — merging *is* publishing.

## The one rule

Every patch carries its trail: what went in, what was kept, what changed between versions. An expert you can't audit is just somebody's opinions with extra steps.
