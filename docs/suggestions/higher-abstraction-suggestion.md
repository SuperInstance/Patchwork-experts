# Five suggestions, ranked by what they change

Written after reading SPEC.md, AGENTS.md, `experts.json`, the seed crystal, and the three
compiler pipelines. Not a wish list — each of these has a cost, a failure mode, and a way
of knowing it worked.

---

## 0. The observation everything else follows from

**Nothing in this repository can fail.**

`capabilities: [diagnosing starter problems]` is a claim with no evidence attached. A patch
written by a careful person and a patch written by someone in ninety seconds are
indistinguishable from the outside, because there is no operation you can perform on a
patch that comes back "no".

This is not a quality complaint. It is a structural one. The format is excellent at
**provenance** — the changelog, the lineage, the version bump are all real and all rare in
this kind of project. It has nothing at all at the level of **verification**. So the repo
will get good at accumulating patches and never get good at knowing which patches are good,
and the two failure modes look identical from outside.

Everything below is aimed at that one gap.

---

## 1. A patch should be falsifiable. *(highest value, lowest cost)*

Add an optional third file, `patches/<slug>/probes.yaml`. Not a benchmark. A smoke test.

```yaml
# probes.yaml — run these; a correct expert passes, a plausible one does not
probes:
  - q: "A starter doubled in 4 hours at 26°C. What do you do first?"
    expect_contains: ["feed", "warm", "hydrogen", "acidity"]
    reject_contains: ["discard", "start over"]
    why: "the classic false answer is 'throw it out and start over'"
  - q: "Hydration 95% at altitude. What changes?"
    expect_contains: ["gluten", "evaporation", "adjust"]
    note: "this is a v1.2 knowledge addition, so it should FAIL on v1.1"
```

Why this and not a score: **you are not trying to rank patches, you are trying to catch the
ones that are wrong.** A patch whose probes fail is not "scored badly", it is *broken*, and
that is the only verdict this library needs. Three probes per patch is enough to catch a
fabricated one.

The `note` field does something more interesting: it lets a probe be **versioned against a
known-good failure**. A v1.1 sourdough expert that gets hydration-at-altitude wrong is not
a broken patch; it is a patch that has not been frozen yet. That gives the changelog
something to be *about*.

**Cost:** a third file, optional, ~10 lines per patch.
**How I'd know it worked:** publish three patches, one of them deliberately thin, and see
whether the thin one is caught before anyone relies on it.

---

## 2. Refusals are the payload, so make `limitations` operational. *(highest leverage)*

Right now `limitations` is prose. Prose about limitations is the easiest section in the
entire format to write *well* and the easiest to write *falsely*, and a reader has no way
to tell which they got. Ask any patch author to write "not a food-safety authority" and
every single one will, whether or not it is true.

Turn it into a decision:

```yaml
# meta.yaml
decline_when:
  - "asked for medical or legal advice"
  - "asked about a commercial product by name"
  - "the conversation needs current prices or availability"
escalate_to: "a human, before answering"
```

This is the part I would argue hardest for, and the reason is specific to what a patch
actually *is*.

**A fresh LLM has no idea what it does not know.** That is not a bug, it is the property
that makes it useful in every other way. A model will answer your sourdough question and
your cardiac question with the same tone, because tone is not indexed to reliability.

A patch is the one place a system can hand a model **a pre-registered blindness**. Not
knowledge — knowledge is the cheap half, every prompt has it. A declared, versioned,
auditable set of situations where *this particular mind should stop and say so*. That is
something a bare model structurally cannot supply and something a human expert can,
because a human expert knows the edges of their own knowledge.

That is the general-purpose value proposition. It is not currently written down anywhere,
and if the format is going to survive contact with a gallery of strangers' patches, it is
the property that will not survive contact without it.

---

## 3. The seed crystal is a monoculture, and monocultures are the failure mode I trust least here.

`patchwork-guide` is described as *"patch this one in when you're unsure how any of this
works."* Patch that instruction literally and you get: every agent, on every uncertain
task, loading the same orientation expert, which then advises in the same shape, which
produces patches in the same shape, which get indexed by the same guide.

I have watched a fleet of models converge on one answer through what was supposed to be an
independent check, and the mechanism was always the same: the thing everyone was measured
against had drifted. A shared orientation expert that everyone consults *is* the shared
frame, and it will harden.

Two cheap mitigations, either is fine:

- **Prefer no expert to the guide.** `patchwork-guide` is for humans and for genuinely lost
  agents. An agent that has read SPEC.md and AGENTS.md does not need it, and the habits it
  teaches are the monoculture.
- **Add a diversity field** to the index — a coarse tag of what *shape* of thinking an
  expert brings (`analytical` / `empirical` / `adversarial` / `conversational`). Not
  domain. Shape. A gallery that can only be navigated by domain will fill with one
  temperament per domain.

---

## 4. Composition is the general-purpose question, and the spec currently forbids it.

`AGENTS.md`: *"Never mix two experts' patches into one conversation. One expert per
conversation — that's what keeps each context clean."*

That is a good rule and it is a rule that *defines away the hard problem*. Real expertise is
compositional — a finance expert and an architecture expert are not two separate things,
they are a third thing that neither one is. And "general-purpose" is not a property you get
from a large catalogue of non-interacting parts. It is a property you get from parts that
compose.

The rule exists because the spec has no answer for what happens when they disagree. So:

- **Keep the rule**, and add the missing case rather than pretending it doesn't exist.
- **A blend patch is a first-class artifact.** Not two patches concatenated — a third
  thing, with its own `decline_when`, its own probes, and a declared precedence for the
  conflicts. When two experts disagree, the blend patch says who wins and why, in advance.
- **Declare conflicts, don't discover them.** Two patches that both claim to be
  authoritative on the same question should be *allowed* to merge, and required to
  state which is in charge.

The general-purpose version of this repo is a library of composable minds. Right now it is
a library of minds. The difference is one field and one rule, and the repo is the right
place to invent them.

---

## 5. Version numbers currently mean "changed", and they should mean "better".

`major.minor` with a changelog is good practice and it is currently unmeasurable. A
consumer has no way to know whether v1.2 is an improvement, a regression, or a different
editorial choice — and neither does the author, after the fact.

The cheapest honest improvement, and it does not require a score:

> **A minor bump is a claim.** The author is asserting that the new version handles
> something the old one did not. The probes are what makes that checkable: a probe that
> passes on v1.2 and failed on v1.1 is the receipt for the minor bump. A minor bump with
> no such probe is a changelog entry, which is a story.

If you want a number rather than a story later, the one that would actually be meaningful
is **probe coverage of the declared capabilities** — not "how many probes pass" (that is
gameable and everyone will game it) but "is there at least one probe for each declared
capability, and does each declared limitation have a probe that a wrong expert fails."

---

## What I would build first, in order

1. **`decline_when`** — it is the part that makes a patch worth more than a prompt, and it
   is three lines of YAML.
2. **`probes/`** — optional, cheap, and the only thing in the format that can return "no".
3. **A blend patch as a worked example**, even an ugly one, because the spec currently has
   no vocabulary for it and a vocabulary arrives by example far more reliably than by rule.
4. The diversity tag, when the gallery is big enough for it to matter. It will matter.

The seed crystal should be the one that grows `probes/` first, since it is the patch
everyone reads and it is the one that has to model the practice.

---

## One thing I would not do

I would not add a leaderboard. A leaderboard turns "is this expert any good" into "which
expert wins", and the second question is much less useful than the first and enormously
easier to game. A gallery needs a **refuse-to-load** outcome and a **use-anyway** outcome,
and nothing in between. The refusal is the feature. It is what makes the rest of the
catalogue trustworthy, and it is the only thing here that makes a *shared* library
different from a *collection*.
