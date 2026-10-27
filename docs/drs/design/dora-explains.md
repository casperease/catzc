# DORA explanations — design

The `Dora explains` rationale for the decision records in the `design/` domain, consolidated in one place. Each entry names its decision
record and rule code, then reproduces that record's tie to [DORA](../../references/dora/index.md) research and the domain-relevant
capability links. The decisions live in the decision records themselves; this file carries only their DORA rationale.

## Tracks

`Tracks — the repository's root concerns`

[DDR-TRACK](tracks.md)

> DORA identifies loosely coupled teams and code maintainability as drivers of delivery performance. Tracks establish named concerns with
> clear ownership, tech-stacks, and subscription boundaries, enabling independent verification and blast-radius isolation through
> git-reflected globsets.

- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — tracks partition ownership, prevent cross-cutting
  coupling, and isolate blast radius.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — named concerns, one tech-stack per track, and clear
  taxonomy reduce cognitive load.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Thin platforms

`Thin platforms — an API/CLI abstraction over a vendor layer`

[DDR-THINPLAT](thin-platforms.md)

> DORA's research identifies flexible infrastructure and tool empowerment as drivers of team autonomy and delivery performance. Thin
> platforms harmonize the vendor surface through a CLI abstraction, reducing cognitive load while keeping consequential decisions visible
> and delegating to the vendor's own primitives.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — the thin abstraction keeps the vendor swappable
  behind the CLI.
- [Empowering teams to choose tools](../../references/dora/capabilities.md#teams-empowered-to-choose-tools) — the platform surfaces vendor
  decisions, not hiding them.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — delegation over reimplementation keeps the platform
  small and maintainable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Self-service

`Self-service — safe by construction in controlled settings`

[DDR-SELFSERV](self-service.md)

> DORA's research consistently ties elite delivery performance to exactly the practices this DDR makes structural — version control as the
> single source of truth, trunk-based development, and automated deployment — and to lightweight, built-in change approval over heavyweight
> external review. Relevant DORA capabilities:

- [Version control](../../references/dora/capabilities.md#version-control) — the single source of truth for all production artifacts.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — small batches on trunk, short-lived branches.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — self-service delivery without manual gatekeeping.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — peer review over external
  change-advisory boards.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — the batch size that keeps self-service safe.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Value-chain diagrams

`Visual design of the value-chain diagrams — branch geometry and commit-colour semantics`

[DDR-VISUAL](visual-design.md)

> Visual grammar is a communication artifact, and DORA treats the clarity of a team's delivery model as part of how well the team can
> improve it: a shared, unambiguous picture of how work flows from commit to production is what lets a team reason about its own
> bottlenecks. Fixing branch geometry and colour semantics makes the value stream legible, which is a precondition for the
> measurement-and-improvement loop DORA describes.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the diagrams model the promotion flow this capability
  governs.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — the up/release, down/topic geometry and the
  fix-forward-then-cherry-pick rule encode a trunk-based branching model.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — the funnel-thinning rule makes batch size and
  how selective each gate is visible.
- [DORA research reference](../../references/dora/index.md).

## Audited git remote

`The audited server git remote — verified integration and PR ingress`

[DDR-REMOTE](server-remote-integration.md)

> DORA identifies trunk-based development, version control, and lightweight change approval as predictors of delivery performance.
> Integrating from the last verified commit keeps the trunk continuously integrable without exposing consumers to a dirty tip, and making
> the PR the authenticated ingress keeps change approval built-in and the audit trail complete.

- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — integrate from the stable verified point so the
  trunk stays continuously integrable and a dirty tip never propagates.
- [Version control](../../references/dora/capabilities.md#version-control) — the server's main is the authoritative copy of the repository
  with a complete, attributable history.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — the PR is built-in, authenticated
  ingress and approval, not a heavyweight external approval gate.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — authenticating every ingress at the PR keeps every commit
  on main attributable to a known principal.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Run modes

`Run modes — source mode and build mode`

[DDR-RUNMODE](run-modes.md)

> DORA ties deployment automation and continuous delivery to delivery performance. Shipping the toolset as a built, installable package that
> runs the very same modules — proven by the same tests in both modes — makes the delivered artifact a verified form of the source rather
> than a separate product, and keeps one body of code and tests behind both forms.

- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the built package installs onto a machine in one
  step, from one reproducible build.
- [Test automation](../../references/dora/capabilities.md#test-automation) — one body of tests proves the modules in both run modes.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one set of modules behind both modes, with no second
  copy to drift.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Track types

`Track types — what a track owns, and where tracks are declared`

[DDR-TRACKTYPE](track-types.md)

> DORA identifies loosely coupled teams and flexible infrastructure as drivers of delivery performance. Typing each track as deployable or
> holder, and naming the vendor that reads it, keeps a platform change inside one track and lets a gate tell a deliverable from a vendor's
> configuration without guessing.

- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — a vendor change touches one track and never re-keys
  another vendor's.
- [Teams empowered to choose tools](../../references/dora/capabilities.md#teams-empowered-to-choose-tools) — each tool's settings are a
  track of their own, declared once.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Vendoring

`Vendoring — a vendor is a tool vendored into the repository`

[DDR-VENDOR](vendoring.md)

> DORA identifies version control of everything the build needs, and automated deployment from one verified artifact, as drivers of delivery
> performance. Vendoring each tool and its settings into the commit makes HEAD the whole input of the build, so what BVT proved is what is
> promoted.

- [Version control](../../references/dora/capabilities.md#version-control) — the tools and their settings are in the commit, not on a feed
  or in a console.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the promoted commit needs no fetch that could
  differ between stages.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Module types

`Module types — what a module is placed as`

[DDR-MODTYPE](module-types.md)

> DORA identifies code maintainability and version control as drivers of delivery performance. One registry that says what a module is, and
> a track type that admits only the module types it should, keeps one tech-stack per track visible without reading the files.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one declared sort per module reduces guessing from
  folder names.
- [Version control](../../references/dora/capabilities.md#version-control) — the module and its type are read from the tracked tree, so
  every checkout names the same units.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Module aspects

`Module aspects — a unit's files partition into live and tests`

[DDR-ASPECT](module-aspects.md)

> DORA identifies loosely coupled teams and code maintainability as predictors of delivery performance. Partitioning modules into live and
> test aspects creates clear ownership boundaries, prevents accidental shipping of unreviewed code, and enables independent reasoning about
> each concern.

- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — aspects partition code and tests, enabling
  independent change and verification.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — explicit, convention-driven partitions reduce
  cognitive load and prevent silent errors.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Repository filters

`Repository filters — named views over the model, and the lamp language`

[DDR-FILTER](repository-filters.md)

> DORA identifies code maintainability and test automation as drivers of delivery performance. Named, overlapping views over the hard model
> let a reader work in a small subset of a large repository, and a lamp that shows its domain's work in progress and failures, lit or not,
> keeps a broken test or an unstaged change in sight without opening another view.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a reader works in a declared subset, so the large
  repository stays easy to find one's way in.
- [Test automation](../../references/dora/capabilities.md#test-automation) — a failing test file turns its lamp red at once, and the red
  lapses by itself once the tested files change.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
