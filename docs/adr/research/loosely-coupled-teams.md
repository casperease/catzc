---
catzc:
  derived:
    path: docs/adr/research/loosely-coupled-teams.md
    folder: docs/adr/research
    name: loosely-coupled-teams
    filetype: md
    kind: adr
    language: markdown
    track: docs
    body_sha: "24f01e1c2517"
    defines:
      - ADR-DORA-LOOSETEAMS#{1-5}
    links:
      - docs/adr/automation/controlling-module-dependencies.md
      - docs/adr/automation/open-closed-architecture.md
      - docs/adr/design/tracks.md
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#deployment-automation
      - docs/references/dora/capabilities.md#fast-flow
      - docs/references/dora/capabilities.md#job-satisfaction
      - docs/references/dora/capabilities.md#loosely-coupled-teams
      - docs/references/dora/capabilities.md#team-experimentation
      - docs/references/dora/capabilities.md#teams-empowered-to-choose-tools
      - docs/references/dora/core-model.md#fast-flow
      - docs/references/dora/core-model.md#organizational-performance
      - docs/references/dora/core-model.md#software-delivery-performance
      - docs/references/dora/core-model.md#version-history
      - docs/references/dora/core-model.md#well-being
      - docs/references/dora/index.md
      - docs/references/dora/metrics.md#instability
      - docs/references/dora/metrics.md#throughput
      - docs/references/dora/publications.md#2017-state-of-devops-report
      - docs/references/dora/publications.md#2021-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2022-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2023-accelerate-state-of-devops-report
      - "https://dora.dev/capabilities/loosely-coupled-teams/"
---

# ADR: DORA — Loosely coupled teams

## Rules: ADR-DORA-LOOSETEAMS

### Rule ADR-DORA-LOOSETEAMS:1

A team makes large-scale changes to the design of its own system without needing permission from anybody outside the team and without
depending on another team's schedule to ship — that independence, not the presence of service boundaries, is the capability.

- [Summary](#summary)

### Rule ADR-DORA-LOOSETEAMS:2

Independent deployability is the test of loose coupling: a service deploys on demand regardless of the state of the services it depends on,
and its functional tests run against test doubles rather than a shared, fully integrated environment.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-LOOSETEAMS:3

Team topology and system architecture reinforce each other on purpose — team boundaries are drawn to match the intended architecture (the
Inverse Conway Maneuver), and one coherent concern lives behind one clear boundary rather than spilling across several teams.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-LOOSETEAMS:4

Interfaces between teams are explicit, versioned, and backward-compatible, so a producer can change its internals and ship on its own
schedule while every consumer keeps working against the version it already integrated against.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-LOOSETEAMS:5

A "big-bang" deployment — several services released together because their interdependencies leave no other choice — is evidence of tight
coupling, not an acceptable operating mode; treat the need for simultaneous releases as the defect to remove, not a fact to schedule around.

- [Common pitfalls](#common-pitfalls)

## Context

Loosely coupled teams is one of DORA's technical capabilities, and it is as much an organizational finding as an architectural one: the
research ties team independence to software delivery performance because coordination cost, not raw system complexity, is what slows
delivery down. A team that must ask permission outside itself, or wait on another team's release, pays that cost on every change.

DORA frames the capability as teams that "can make large-scale changes to the design of their systems without the permission of somebody
outside the team or depending on other teams," working through well-defined interfaces and bounded contexts.[^1] It sits alongside
continuous delivery in the DORA Core Model and beside trunk-based development in DORA's catalogue, and it depends on the same architectural
discipline that those capabilities assume: clear seams, explicit interfaces, and no hidden coupling through shared state or shared
deployment windows.

## Summary

The capability is team and system independence: teams complete their work without fine-grained communication with external parties, deploy
their service independently and on demand regardless of the state of the services it depends on, test without requiring an integrated
environment, and deploy during business hours with negligible downtime. Randy Shoup's observation — that service-oriented organizations run
tens of thousands of developers with small teams remaining productive — is DORA's illustration of the payoff: coupling, not headcount, is
the limiting factor on how large an engineering organization can grow while staying fast.

## Why it matters

Loosely coupled architectures directly enable continuous delivery and higher software delivery performance. Reduced dependencies and
communication overhead let small teams stay productive even as the organization around them grows. The capability shows up in DORA's outcome
metrics directly: it improves deployment frequency, shortens lead time for changes to reach production, and reduces the time to detect and
recover from problems, because a failure or a change stays inside the boundary where it originated instead of forcing cross-team
coordination to resolve.

## How to apply

This platform draws the same boundary DORA describes at the repository level: a **track** is one named root concern with one tech-stack,
classified core, external port, or adapter, and a consumer subscribes to a track only through its declared module dependencies or the
globset's native trigger projection — never by hand-matching another track's source paths ([ADR-DSGN-TRACK](../design/tracks.md)). That
subscription surface is what keeps a change in one track from rebuilding, or blocking on, every other track's teams.

Within a track, the same discipline applies one level down: the allowed edge between two modules is declared once in `dependencies.yml` and
gated against the actual code, so a module's dependents are a checked-in fact rather than whatever the code happens to call
([ADR-AUTO-DEPM](../automation/controlling-module-dependencies.md)). And the platform stays open for extension without ever editing shared
infrastructure to accommodate a new consumer — a new module, function, or dependency is a new file, never a hand-edited registration that
every other contributor must route around ([ADR-AUTO-EXTEND](../automation/open-closed-architecture.md)). Together these three give a
concrete, computed answer to "does this change require coordinating with, or waiting on, another team" — the question this capability is
built to keep answered "no."

## Common pitfalls

- **Big-bang deployments.** Interdependencies force several services to release together, turning what should be independent deployments
  into scheduled, multi-hour or multi-day events with downtime.
- **Tightly coupled architecture.** Small changes cascade into failures elsewhere, cross-team coordination becomes constant, and change
  management grows a bureaucratic approval layer to compensate for the coupling instead of removing it.
- **Shared integration test environments.** A scarce, hand-configured environment that takes weeks to obtain becomes the bottleneck, and it
  is rarely representative of production once teams get access to it.
- **Service-oriented in name only.** Many systems labeled service-oriented still cannot be tested or deployed independently per service —
  the label describes the diagram, not the actual coupling.
- **Operational complexity without matching discipline.** Microservices raise monitoring complexity (a failure can originate calls away from
  where it surfaces), invite internal denial-of-service without quotas and throttling, and are hard to debug without service discovery and
  standardized environments.

## References

[^1]:
    DORA, _Loosely coupled teams_ capability, <https://dora.dev/capabilities/loosely-coupled-teams/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Loosely coupled teams is DORA's link between organizational structure and delivery speed. It is a fast-flow capability in the Core Model: a
team structure and architecture that let teams test and deploy on demand without coordinating with other teams predicts continuous delivery
and, through it, software delivery performance.

- **Catalogue entry:** [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams)
- **Category:** [Fast flow](../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0:
  [fast flow](../../references/dora/core-model.md#fast-flow). Core V2 reframed the earlier loosely coupled architecture as loosely coupled
  teams ([version history](../../references/dora/core-model.md#version-history)).
- **Evidence:**
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — loosely coupled architectures and
    teams are crucial for continuous delivery.
  - [2021 Accelerate State of DevOps Report](../../references/dora/publications.md#2021-accelerate-state-of-devops-report) — cited on the
    capability page and report page as evidence for the capability.
  - [2022 Accelerate State of DevOps Report](../../references/dora/publications.md#2022-accelerate-state-of-devops-report) — continuous
    delivery, loosely coupled teams, version control, and continuous integration together add up to more than the sum of their parts; with
    above-average documentation quality, the capability's lift on organizational performance rises from 46% to 313%.
  - [2023 Accelerate State of DevOps Report](../../references/dora/publications.md#2023-accelerate-state-of-devops-report) — continuous
    integration, loosely coupled teams, and fast code reviews significantly improve delivery and operational performance.
- **Predicts:** [continuous delivery](../../references/dora/capabilities.md#continuous-delivery) and, through it,
  [software delivery performance](../../references/dora/core-model.md#software-delivery-performance) — the
  [throughput](../../references/dora/metrics.md#throughput) and [instability](../../references/dora/metrics.md#instability) metrics, which
  in turn predict [organizational performance](../../references/dora/core-model.md#organizational-performance) and
  [well-being](../../references/dora/core-model.md#well-being). The Quick Check names it one of three capabilities worth assessing first.
- **Related capabilities:**
  - [Team experimentation](../../references/dora/capabilities.md#team-experimentation) — independent deployability is what lets a team run
    its own experiments without coordinating a shared release.
  - [Teams empowered to choose tools](../../references/dora/capabilities.md#teams-empowered-to-choose-tools) — a loosely coupled boundary is
    what makes an independent tooling choice safe in the first place.
  - [Job satisfaction](../../references/dora/capabilities.md#job-satisfaction) — DORA feeds job satisfaction from continuous delivery, which
    this capability predicts.
  - [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — automates the independent, on-demand deployment
    that loose coupling makes possible.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
