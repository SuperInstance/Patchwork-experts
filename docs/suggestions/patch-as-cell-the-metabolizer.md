# A patch is a cell — the higher-abstraction frame for a general-purpose Patch-in-an-Expert system

*A higher-abstraction companion to [`higher-abstraction-suggestion.md`](higher-abstraction-suggestion.md),
which is excellent and which this does not repeat. That doc works at the level of the **format** (make a
patch falsifiable, make `limitations` operational, break the monoculture, allow composition, make a version
bump mean "better"). This one goes up one level and asks: **what kind of system is Patchwork, really — and
what does "general-purpose" mean for it?** Voice: inform, not sell. Everything concrete stays inside the
repo's own "aggressively boring, minimal" principle; the frame is big, the additions are tiny.*

---

## 0. The one idea

Patchwork already discovered the right primitive without naming it in general terms. **A patch is a cell:**
a small, frozen, pure-ish unit of behavior with a **receipt** (its provenance) and a **fixed tiny
interface** (the pin layout). Everything a mature "expert system" needs is what you get when you take that
one identification seriously and add the three things a cell has that a patch does not yet: a **gate**
(does it produce the right answer?), a **budget** (what does running it cost?), and a **router** (which
cell, when?).

The format doc is right that the missing thing is *verification* ("nothing in this repository can fail").
The higher-abstraction reason that gap matters: **a catalogue of parts is not a general-purpose system.
A general-purpose system is parts that can be *gated, priced, and routed.*** Patchwork is one short step
from being the second thing, and the step is conceptual, not a rewrite.

---

## 1. What "general-purpose" actually means here (the part worth getting right)

It is tempting to read "general-purpose" as "a big enough gallery that there's an expert for everything."
That is a *collection*, and collections don't compose — a thousand non-interacting experts is still a
thousand single-purpose tools.

General-purpose means the opposite of a bigger catalogue: **a router that, given a task, patches in the
right expert (or the right *blend*), at the right cost, and knows when to refuse.** The intelligence isn't
in any patch. It's in the *selection over patches*. So the general-purpose deliverable of this repo is not
"more patches" — it is a **routing layer** the patches were already shaped to support.

This reframes the existing doc's five suggestions as one thing: they are all what a router needs to do its
job. A router can't choose safely without a **gate** (probes — suggestion #1), a **refusal boundary**
(`decline_when` — #2), **diversity of shape to choose between** (#3), a way to **combine** (#4), and a
version signal it can **trust** (#5). Each suggestion is a sensor for the router. That's why they cohere.

---

## 2. The cell contract — the three fields that turn a part into a routable unit

A patch has **identity + knowledge + provenance**. A routable cell needs three more, each optional, each a
few lines, each honoring the pin-layout minimalism:

1. **A gate — can it be wrong?** This is the format doc's `probes.yaml`, and it is the load-bearing one.
   The deep point: a gate is what lets the system say **no**, and *the ability to return "no" is the
   entire difference between a shared library and a pile of files.* A patch whose probes fail is not
   "low-quality" — it is **refused**. Two outcomes only: load / refuse-to-load. No score, no leaderboard
   (the existing doc is exactly right to forbid that).

2. **A budget — what does it cost to be this expert?** New, and cheap: a rough `cost` hint (tokens/latency
   tier, whether it needs tools/network, whether it's a reflex or a deliberation). Not a benchmark — a
   *tier*. Why it matters: the router's real job is a three-way trade-off between **good** (does the gate
   pass), **fast**, and **cheap**. Without a budget field the router can only optimize "good" and will
   always reach for the heaviest expert. With one line of budget, "patch in the cheapest expert whose gate
   still passes for this task" becomes expressible. (This is the iron-triangle that shows up everywhere
   once you look: quality vs latency vs cost. A patch that declares its tier lets a caller pick two.)

3. **A witness — is a version claim true over time, not just once?** The format doc nails "a minor bump is
   a claim; the probe that newly passes is the receipt." The higher-abstraction upgrade: a single passing
   probe is one sample. A claim that holds should hold *repeatedly*. The honest form is an **anytime-valid
   check** — re-run the probe over time, and let the version's claim be *retractable* if it starts failing
   in the wild. A patch that quietly regressed should be able to lose its badge without a human noticing
   first. This keeps "version = better" honest after the freeze, not just at the freeze.

None of these need a runtime. `probes.yaml` is already proposed. `cost:` is one field in `meta.yaml`. The
witness is a convention (re-run probes on a cadence; a patch that fails its own probes is flagged, not
trusted). The pin layout stays tiny; it just gains the pins that let a machine *choose*.

---

## 3. Composition is routing, and routing has a well-understood shape

The format doc is right that composition is the general-purpose question and that a **blend patch** (a
third thing with its own probes and declared precedence) is the answer, not two patches concatenated. The
higher-abstraction frame gives that a mechanism instead of a case-by-case rule:

- **Two experts asked the same question are two routes to one product.** If they *agree*, you don't need a
  blend — you patch in the cheaper one (the budget field decides). Agreement on the gate is the license to
  pick on cost.
- **If they disagree, that is a real conflict, and a blend patch is the pre-registered resolution:** it
  declares who wins on which sub-question and *why*, and carries its own gate. A blend is not a merge of
  text; it is a **routing decision frozen into a patch** — which is exactly what a good human team lead is.
- **The general-purpose agent, then, is a patch too** — the router itself is an expert on *which expert*,
  with its own probes ("given this task, did it pick a defensible expert?") and its own `decline_when`
  ("no expert in the quilt covers this — say so"). Patchwork can bootstrap its own router as a patch,
  which is very much in the spirit of the seed-crystal `patchwork-guide`.

This is the cleanest statement of the endpoint: **a general-purpose Patch-in-an-Expert system is a quilt of
gated, budgeted expert-cells with a router-patch over them.** The catalogue is the memory; the router is
the mind.

---

## 4. The deepest frame: Patchwork is a capability *metabolizer*

Step all the way back. What is the *lifecycle* of an expert here?

> **Grow** it in long conversation (expensive deliberation) → **freeze** it into a patch (compress the
> deliberation into a small reusable artifact) → **patch it in** (cheap reflex — read a file, become the
> expert) → **refine** it → **re-freeze** a better version.

That loop has a name worth stealing from the learning-systems literature the fleet has been circling:
**learning is the compression of deliberation into reflex.** A raw model answering a hard question from
scratch is *deliberation* (many tokens, slow, unreliable at the edges). A frozen patch is that same
capability *metabolized into reflex* — the knowledge didn't disappear, it *sank* from "work it out every
time" to "read it and know." A patch is a **chord shape for expertise**: the 500-token deliberation
becomes the 5-section reflex.

Seeing Patchwork this way pays off concretely:

- **The freeze step is a training epoch.** `compiler/distill.md` and `compiler/freeze.md` are already the
  training loop — they take a conversation (experience) and write a compressed artifact (a weight update
  you can read). The provenance trail is the training log. This is not a metaphor to add code for; it is a
  lens that tells you the compiler is the most important part of the repo, not the catalogue.
- **Invocation has modes, and the budget field is what selects them.** An expert can be invoked as a pure
  reflex (patch in, answer, done), as a cache (a frozen answer to a common question), or as scaffolding
  for fresh deliberation (patch in, then *think* with its method). The same patch can occupy different
  modes for different tasks; the budget field + the caller's need pick the mode. "Patch in the finance
  expert and *have it study* X" is the deliberation mode; "patch in the finance expert and *ask* the
  standard question" is the reflex mode. One artifact, several runtimes — exactly the repo's existing
  "the patch is universal; only the harness is platform-specific."
- **A patch that never returns to deliberation is dead.** The metabolizer only stays alive if reflexes can
  be *re-opened* — a probe failing in the wild should push an expert back into "needs re-growing." This is
  the same insight as the witness in §2, seen from the lifecycle side: the loop must be able to run
  backwards, or the quilt fossilizes.

---

## 5. What I would and would not do (respecting "aggressively boring")

**Would, in order — each earns its place before the next:**
1. **`probes.yaml`** (already proposed) — the gate. Without the ability to return "no," none of the rest is
   trustworthy. Seed it on `patchwork-guide` first, as the format doc says.
2. **`decline_when` + `cost` tier in `meta.yaml`** — the refusal boundary and the budget. Two tiny fields
   that together make a patch *routable* instead of merely *readable*.
3. **One worked blend patch** — the vocabulary for composition arrives by example, not by rule. Make it an
   honest, slightly ugly real one (e.g. a finance × architecture blend that declares who wins on cost vs
   structure).
4. **A router-patch** (`patches/quilt-router/` or similar) — an expert on *which expert*, with its own
   probes and `decline_when`. This is the artifact that makes the system general-purpose, and it's still
   just a patch.

**Would not:** turn Patchwork into a framework, a runtime, or a scored marketplace. The pin layout wins by
staying small. Every field above is a *sensor for a router*; the moment a field stops serving selection,
it's bloat. The genius, as the README says, is the interface being fixed and tiny — so the discipline is
to add only the pins a router provably needs, and to learn which ones from where real blends and real
refusals break, not from prediction.

---

## 6. One-paragraph summary for the next agent who reads this

Patchwork's primitive is a **cell**: a frozen expert with a receipt and a tiny fixed interface. It is
already excellent at provenance and one short step from being *general-purpose*, where general-purpose
means **routable**, not **numerous**. Give each patch a **gate** (probes → load/refuse), a **budget**
(a cost tier), and a **witness** (its version-claim stays true over time or retracts), and the composition
problem becomes a **routing** problem with a known shape: agree → pick the cheaper; disagree → a blend
patch is the frozen resolution; and the router itself is just another patch. Underneath, the whole thing is
a **capability metabolizer** — grow (deliberate) → freeze (compress to reflex) → patch in (reflex) →
refine → re-freeze — so the compiler, not the catalogue, is the heart. Add the three pins a router needs
and nothing more; the tininess is the feature.
