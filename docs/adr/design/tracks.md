# ADR: Tracks — the repository's root concerns

## Rules: ADR-TRACK

### Rule ADR-TRACK:1

A **track** is a named repository root concern, mapped onto exactly one root folder and named by that folder: `automation`,
`infrastructure`, `contracts`, and each `.<foldername>`. Every root folder names a track (`ADR-FOLDERS`); a track never spans two roots, and
a root never carries two tracks. Tracks are what this mono repository is composed of.

- [What a track is](#what-a-track-is)

### Rule ADR-TRACK:2

Every track carries one classification from the taxonomy: **core** (defines the internal ports the other tracks rest on — `automation`),
**external port** (the repository's boundary/configuration for one outside concern — `contracts`, and most `.<foldername>` roots), or
**adapter** (adapts the core to a delivery target — `infrastructure`, with its Bicep modules and named templates). Cross-cutting slices
(e.g. the cats configs — every yml/config file across automation) are **scopes over tracks**, not tracks: they select through the roots
rather than owning one.

- [The taxonomy](#the-taxonomy)

### Rule ADR-TRACK:3

A track owns one coherent **tech-stack**, and a new tech-stack opens a new track — never a subfolder inside an existing one. `automation`'s
stack is deliberately intricate: two automation layers (PowerShell and C#) packaged as PowerShell modules. `infrastructure`'s stack is
deliberately simple — Bicep plus PowerShell extension points and one configuration yml per subscription target — and rests on `automation`
for context and execution. Future concerns follow the same shape: a `frontend` track for small front-apps, a `services` track for PaaS
services and C# function apps.

- [A track has a tech-stack](#a-track-has-a-tech-stack)

### Rule ADR-TRACK:4

Tracks are **subscribable, never path-coupled**: a consumer binds to a track through its module dependencies (depm — dependencies between
modules, never on systems) or through its globset's native trigger projection (`ADR-GLOBS`), never by hand-matching the track's source paths.
The globsets are the coordinating source of truth for "which tracks and deployable-units carry changes in this commit" — computed from git,
the mechanism that keeps a change in one track from rebuilding every customer of every other track.

- [Subscription and coordination](#subscription-and-coordination)

### Rule ADR-TRACK:5

A **deployable-unit** is what ships: a whole track (`ci-automation` verifies the entire automation track) or a reduced composition (the
shared infrastructure templates in a defined order, one customer's foundation). Deployable-units determine pipelines **1-1** — one unit, one
pipeline — widening to **1-2** only when a DEPLOY stage is split out of CD. A pipeline never binds to a track except through the
deployable-unit that IS that track.

- [Tracks, units, pipelines](#tracks-units-pipelines)

## Context

A mono repository holds several concerns that differ in everything but their home: language, delivery target, cadence, and blast radius.
Without a named concept for "the root concern", those differences leak everywhere — pipelines path-filter on ad-hoc folder lists, tests
guess their scope, and a change in one corner rebuilds customers who never consumed it. The repository already had the ingredients (root
folders with strong conventions, the globset registry with durable-SHA stamps, per-module dependency maps); what was missing was the word
that ties them together and the rules that keep them tied.

### What a track is

The unit of "concern" in this repository is the root folder. `automation/` is the automation platform; `infrastructure/` is the IaC tree;
`contracts/` is the outward API surface; each `.<foldername>` configures exactly one external system (the repository's boundary for that
concern). Naming the concept makes the mapping normative: the folder is the registration, the folder name is the track name, and asking
"which track does this file belong to?" always has exactly one answer. That single-answer property is what every consumer below builds on.

### The taxonomy

Tracks are not peers in role, only in shape. The **core** track defines the internal ports — `automation` is the engine, and every other
track assumes it. **External ports** hold the repository's side of an outside contract: `contracts/` for consumers of this repo,
`.github/`/`.vscode/`-style dot-roots for the tools that read them. **Adapters** turn the core's capabilities toward a delivery target —
`infrastructure/` adapts to Azure through Bicep modules and named templates. The taxonomy earns its keep in review: a proposed root that is
none of these is probably a subfolder of an existing track, and a cross-cutting need (all config files, all markdown) is a **scope** — a
globset selecting through tracks — not a new root.

### A track has a tech-stack

The stack is the reason tracks exist as _separate roots_ rather than folders inside one tree: each stack brings its own toolchain, its own
verification, and its own failure modes. Keeping one stack per track keeps every gate honest — the automation suite verifies PowerShell/C#,
the infrastructure gates verify Bicep against its configuration model — and keeps the door open for new stacks (`frontend`, `services`)
without disturbing the existing ones. The dependency between stacks is explicit and one-directional: adapters and ports rest on the core
(`infrastructure` consumes `automation` for context and execution), never the reverse.

### Subscription and coordination

Two subscription surfaces exist, both derived from the same source of truth:

- **depms** — the module dependencies declare which modules (and by extension which tracks) a consumer rests on; the graph gates enforce
  them. A depm is module-to-module only — a dependency on a system is a dep, a different concern with different tooling.
- **globset projections** (`ADR-GLOBS`) — each track's globset projects to native vendor path filters that pipelines trigger on, and to a
  git-reflected area-of-control the PR report reads; test tooling derives blast radius from the same globsets. Nothing is committed per set.

This is the coordination answer to the monorepo's core tension: everything lives together, but nothing rebuilds together unless the change
actually touches it.

### Tracks, units, pipelines

A track is a concern; a deployable-unit is a shippable composition; a pipeline is a unit's delivery machine. The three relate strictly:
units compose from tracks (whole or reduced), pipelines bind to units 1-1 (1-2 when DEPLOY splits from CD), and nothing binds to a track's
source paths directly. `ci-automation` is the degenerate-but-common case where the unit is the whole core track; the per-customer CD
pipelines are the reduced case — one customer's foundation unit, composed from the infrastructure track's shared modules plus that
customer's configuration surface.

## Decision

Name the concept: repository root concerns are **tracks** — folder-named (ADR-TRACK:1), classified core/port/adapter (ADR-TRACK:2), one
tech-stack each (ADR-TRACK:3), subscribable only via depms and globset projections (ADR-TRACK:4), and shipped through deployable-units that
bind pipelines 1-1 (ADR-TRACK:5).

### How this is enforced

- **`ADR-FOLDERS`** (conventional folders) keeps the root inventory deliberate — a new root folder is a reviewed decision, and under this
  ADR it is the decision to open a track.
- **The globset registry** (`Catzc.Base.Globs`, `ADR-GLOBS`) declares each track's file set; pipelines filter on its native projection and
  the drift gate fails a trigger that no longer matches, while the git-reflected report answers what a change touches.
- **depms and the dependency-graph gates** (`ADR-MODDEPS`) enforce the declared subscription edges, including the one-directional core ←
  adapter/port dependency.
- **Code review** applies the taxonomy: a new root must name its classification and tech-stack; a cross-cutting need becomes a scope
  globset, not a root.

## Consequences

- "Which track does this change touch?" has one answer, computed (git-reflected against the globsets), not argued.
- Pipelines, tests, and reviewers all read the same coordination surface, so a change's blast radius is the same fact everywhere.
- Opening a concern is cheap and bounded: one root folder, one classification, one globset entry — and the rest of the repository is
  untouched by construction.
- The cost is discipline at the root: no drive-by root folders, no second stack smuggled into an existing track, and the registry has to
  stay curated as tracks grow.

## Dora explains

DORA identifies loosely coupled teams and code maintainability as drivers of delivery performance. Tracks establish named concerns with
clear ownership, tech-stacks, and subscription boundaries, enabling independent verification and blast-radius isolation through
git-reflected globsets.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — tracks partition ownership, prevent cross-cutting
  coupling, and isolate blast radius.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — named concerns, one tech-stack per track, and clear taxonomy
  reduce cognitive load.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
