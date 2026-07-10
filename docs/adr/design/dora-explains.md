# DORA explanations — design

The `Dora explains` rationale for the ADRs in the `design/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Tracks — the repository's root concerns (`ADR-DSGN-TRACK`)

DORA identifies loosely coupled teams and code maintainability as drivers of delivery performance. Tracks establish named concerns with
clear ownership, tech-stacks, and subscription boundaries, enabling independent verification and blast-radius isolation through
git-reflected globsets.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — tracks partition ownership, prevent cross-cutting
  coupling, and isolate blast radius.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — named concerns, one tech-stack per track, and clear taxonomy
  reduce cognitive load.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Thin platforms — an API/CLI abstraction over a vendor layer (`ADR-DSGN-THINPLAT`)

DORA's research identifies flexible infrastructure and tool empowerment as drivers of team autonomy and delivery performance. Thin platforms
harmonize the vendor surface through a CLI abstraction, reducing cognitive load while keeping consequential decisions visible and delegating
to the vendor's own primitives.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — the thin abstraction keeps the vendor swappable behind
  the CLI.
- [Empowering teams to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — the platform surfaces vendor
  decisions, not hiding them.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — delegation over reimplementation keeps the platform small
  and maintainable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Self-service — safe by construction in controlled domains (`ADR-DSGN-SELFSERV`)

DORA's research consistently ties elite delivery performance to exactly the practices this ADR makes structural — version control as the
single source of truth, trunk-based development, and automated deployment — and to lightweight, built-in change approval over heavyweight
external review. Relevant DORA capabilities:

- [Version control](https://dora.dev/capabilities/version-control/) — the single source of truth for all production artifacts.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — small batches on trunk, short-lived branches.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — self-service delivery without manual gatekeeping.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — peer review over external change-advisory
  boards.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the batch size that keeps self-service safe.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Visual design of the value-chain diagrams — branch geometry and commit-colour semantics (`ADR-DSGN-VISUAL`)

Visual grammar is a communication artifact, and DORA treats the clarity of a team's delivery model as part of how well the team can improve
it: a shared, unambiguous picture of how work flows from commit to production is what lets a team reason about its own bottlenecks. Fixing
branch geometry and colour semantics makes the value stream legible, which is a precondition for the measurement-and-improvement loop DORA
describes.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the diagrams model the promotion flow this capability governs.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — the up/release, down/topic geometry and the
  fix-forward-then-cherry-pick rule encode a trunk-based branching model.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the funnel-thinning rule makes batch size and gate
  selectivity visible.
- [DORA research overview](https://dora.dev/research/).

## The commit lifecycle — states, environment occupancy, and the stable sync point (`ADR-DSGN-LIFE`)

This model is a statement about how change flows into, through, and out of the mainline, which is the core of what DORA measures. A clear
lifecycle — one direction, named rejection points, a distinction between rejected/retired/superseded, a single stable integration point that
is not HEAD — is what lets a team keep the mainline continuously integrable and lets its consumers depend on it without inheriting its
churn.

- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — the HEAD-vs-stable-sync-point rule and the
  one-directional ladder are how a trunk stays continuously integrable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the promotion ladder and single-occupant environments are the
  delivery pipeline this capability governs.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automatic discard at BVT/L3 and the out-of-band topic
  deploy are automated-deployment behaviours.
- [Version control](https://dora.dev/capabilities/version-control/) — "history is never rewritten; a discarded commit stays on the record"
  is a version-control discipline.
- [DORA research overview](https://dora.dev/research/).

## The audited server git remote — verified integration and PR ingress (`ADR-DSGN-REMOTE`)

DORA identifies trunk-based development, version control, and lightweight change approval as predictors of delivery performance. Integrating
from the last verified commit keeps the trunk continuously integrable without exposing consumers to a dirty tip, and making the PR the
authenticated ingress keeps change approval built-in and the audit trail complete.

- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — integrate from the stable verified point so the trunk
  stays continuously integrable and a dirty tip never propagates.
- [Version control](https://dora.dev/capabilities/version-control/) — the audited server remote is the single source of truth with a
  complete, attributable history.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — the PR is built-in, authenticated ingress
  and approval, not a heavyweight external gate.
- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — authenticating every ingress at the PR keeps every commit on
  main attributable to a known principal.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Module aspects — a unit's files partition into live and tests (`ADR-ASPECT`)

DORA identifies loosely coupled teams and code maintainability as predictors of delivery performance. Partitioning modules into live and
test aspects creates clear ownership boundaries, prevents accidental shipping of unreviewed code, and enables independent reasoning about
each concern.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — aspects partition code and tests, enabling independent
  change and verification.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — explicit, convention-driven partitions reduce cognitive load
  and prevent silent errors.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
