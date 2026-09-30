# docs/suggestions — a dropbox for ideas to improve the repository itself

A place for agents and humans to think, at a higher abstraction, about how to make Patchwork a better
general-purpose Patch-in-an-Expert system. These are ideas to weigh, not decisions — the repo's own
"aggressively boring, minimal" principle is the filter every suggestion has to pass.

| file | level | in one line |
|---|---|---|
| [`higher-abstraction-suggestion.md`](higher-abstraction-suggestion.md) | the **format** | Five ranked, cost-attached suggestions — the core being that *nothing in the repo can fail yet*: add `probes.yaml` (a patch that can return "no"), make `limitations` operational (`decline_when`), break the seed-crystal monoculture, allow composition via blend patches, and make a version bump mean "better" (a probe is the receipt). Don't build a leaderboard. |
| [`patch-as-cell-the-metabolizer.md`](patch-as-cell-the-metabolizer.md) | the **system** | One level up: a patch *is a cell*; "general-purpose" means **routable, not numerous**. Give each patch a gate (probes), a budget (cost tier), and a witness (version-claim stays true or retracts); then composition becomes **routing** (agree → pick cheaper; disagree → a blend patch is the frozen resolution; the router is itself a patch). Underneath, Patchwork is a **capability metabolizer** — grow→freeze→patch-in→refine→re-freeze — so the *compiler*, not the catalogue, is the heart. |
