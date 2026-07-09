# ADR: DORA — Platform engineering

## Rules: ADR-DORA-PLATFORM

### Rule ADR-DORA-PLATFORM:1

Design the internal platform as a product for developers, with a named owner accountable for developer experience, rather than as an
infrastructure ticket queue; map the critical user journeys developers actually take through it and remove the friction points in them.

- [Summary](#summary)

### Rule ADR-DORA-PLATFORM:2

Reduce a developer's cognitive load by abstracting the underlying complexity — orchestration, security policy, compliance controls — behind
simple, opinionated "golden paths"; a developer who ships without needing to master the substrate is the capability working, not a stretch
goal.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-PLATFORM:3

Treat platform quality as a precondition for AI to help rather than harm delivery: on a high-quality platform, AI adoption's effect on
organizational performance is strong and positive; on a low-quality one, the same AI-generated throughput piles up as downstream disorder in
testing, security, and deployment.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-PLATFORM:4

Grow the platform from its minimum viable form — the golden path for the single most common workflow — rather than building comprehensive
coverage upfront on assumption; earn the next capability from observed usage, not from a roadmap drawn in advance.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-PLATFORM:5

Avoid the five antipatterns that stall adoption: building on assumption instead of user research, imposing standards top-down without
collaboration, running the platform as reactive ticket-ops, delaying release in pursuit of a "big bang" launch, and forcing
one-size-fits-all requirements onto teams whose needs genuinely differ.

- [Common pitfalls](#common-pitfalls)

## Context

Platform engineering sits alongside flexible infrastructure and tool empowerment in DORA's technical capability set: it is the discipline of
building and running the internal platform other teams build on, rather than treating infrastructure as a series of one-off requests. DORA
frames it as a sociotechnical discipline — engineers working at the intersection of the social interactions between teams and the technical
work of automation, self-service, and repeatability — realized as an "Internal Developer Platform" that delivers shared, high-quality tools,
services, and golden paths so teams can build, test, and deploy applications securely and in compliance.[^1]

By 2025 the practice reached near-universal adoption: DORA reports 90% of organizations using an internal developer platform and 76%
establishing a dedicated platform team. The capability's newer significance is its relationship to AI: DORA's research treats AI as an
amplifier of whatever the organization already has, and platform quality is what determines whether the amplified result is throughput or
chaos.

## Summary

The capability is building the internal platform as a product for developers rather than as an infrastructure ticket system. That means
assigning a product manager whose job is developer experience, designing "golden paths" that are the shared, high-quality, paved way to
build and deploy, and organizing the platform team around Team Topologies' idea of a platform as an internal product with its own users,
feedback loops, and roadmap.

The distinguishing move is the product mindset: a platform earns adoption by making the easy path also the correct one, not by mandating its
use. Where that mindset is absent, the same set of tools and services reverts to being infrastructure with extra ceremony.

## Why it matters

DORA's central finding here is that platform quality gates the return on AI adoption. When platform quality is high, the effect of AI
adoption on organizational performance becomes strong and positive; when platform quality is low, that effect is negligible. AI is an
amplifier — it magnifies organizational strengths and weaknesses rather than fixing them — so without a robust platform, the productivity
gains from AI-assisted coding get absorbed by downstream disorder in testing, security, and deployment rather than reaching the organization
as delivery performance.

The same mechanism explains the platform's value independent of AI: shifting cognitive load off developers, so they do not need to master
Kubernetes or security policy to ship, measurably improves productivity. DORA's research found this "developer independence" effect yields a
5% improvement in productivity at both the team and individual level. A platform that instead requires developers to understand its full
substrate has simply relocated the cognitive load rather than removed it.

## How to apply

DORA's guidance groups into four approaches, and this platform maps to two of them directly. The thin CLI abstraction over the vendor
substrate ([ADR-DSGN-THINPLAT](../design/thin-platforms.md)) is the golden path: consumers call `Verb-Noun` functions and edit
configuration, never touching the vendor wiring directly, which is exactly the cognitive-load shift DORA measures — and it is deliberately
held to the smallest set of APIs, tooling, and docs that accelerates delivery, the same minimum-viable-platform discipline DORA recommends
over building comprehensively upfront. Self-service as the platform's mode of use ([ADR-DSGN-SELFSERV](../design/self-service.md)) is the
other half: every self-service action is a reviewable, reproducible change to a single source of truth, which is what makes self-service
safe to offer widely rather than gated behind a queue.

Beyond what this platform already does, DORA's guidance calls for a product management mindset — a named owner for developer experience who
maps the critical user journeys developers take and removes friction in them — and for extensibility: clear APIs and a well-defined
contribution model, plus clear feedback on the outcome of a developer's task, which DORA identifies as the capability most correlated with a
positive platform experience.

Measurement follows the same four-way split: track software delivery performance (change lead time, deployment frequency, recovery time,
failure percentage, rework rate) to confirm the platform is improving outcomes, not just activity; track developer satisfaction with CSAT or
NPS surveys tied to specific platform changes; track adoption and retention with an approach like the H.E.A.R.T. framework, covering both
onboarding and continued use; and track task success — how efficiently developers complete key workflows on the platform, since a golden
path only counts if it is faster than the alternative it replaces.

## Common pitfalls

- **"Build it and they will come."** Building the platform on internal assumptions rather than user research; adoption fails when the
  platform was never validated against how developers actually work.
- **The "ivory tower."** Imposing rigid, top-down standards without collaborating with the teams that must use them; the predictable result
  is shadow IT workarounds that route around the platform rather than through it.
- **"Ticket-ops."** Running the platform as reactive infrastructure vending rather than genuine self-service; teams stay stuck in the same
  toil the platform was meant to remove.
- **The "big bang" release.** Withholding launch in pursuit of a "complete" platform; by the time it ships, developer needs have moved on
  from what was built.
- **"One-size-fits-all."** Applying one rigid set of requirements across teams with genuinely different needs — a data science team and a
  mobile team do not want the same golden path, and forcing one onto both drives adoption down for both.

## References

[^1]:
    DORA, _Platform engineering_ capability, <https://dora.dev/capabilities/platform-engineering/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Platform engineering is where DORA's research on AI and delivery performance converges: it is the capability that determines whether AI
adoption amplifies an organization's strengths or its downstream disorder, which in turn shapes every one of DORA's software-delivery
metrics — lead time, deployment frequency, recovery time, and change failure rate all move with platform quality.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — the infrastructure substrate the platform's golden
  paths are built on top of.
- [Teams empowered to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — the autonomy a golden path must
  preserve rather than override.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the delivery discipline a minimum-viable platform
  grows to support.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
