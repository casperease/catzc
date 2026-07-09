# ADR: DORA — Loosely coupled teams

## Rules: ADR-DORALCT

### Rule ADR-DORALCT:1

A team makes large-scale changes to the design of its own system without needing permission from anybody outside the team and without
depending on another team's schedule to ship — that independence, not the presence of service boundaries, is the capability.

- [Summary](#summary)

### Rule ADR-DORALCT:2

Independent deployability is the test of loose coupling: a service deploys on demand regardless of the state of the services it depends on,
and its functional tests run against test doubles rather than a shared, fully integrated environment.

- [Why it matters](#why-it-matters)

### Rule ADR-DORALCT:3

Team topology and system architecture reinforce each other on purpose — team boundaries are drawn to match the intended architecture (the
Inverse Conway Maneuver), and one coherent concern lives behind one clear boundary rather than spilling across several teams.

- [How to apply](#how-to-apply)

### Rule ADR-DORALCT:4

Interfaces between teams are explicit, versioned, and backward-compatible, so a producer can change its internals and ship on its own
schedule while every consumer keeps working against the version it already integrated against.

- [How to apply](#how-to-apply)

### Rule ADR-DORALCT:5

A "big-bang" deployment — several services released together because their interdependencies leave no other choice — is evidence of tight
coupling, not an acceptable operating mode; treat the need for simultaneous releases as the defect to remove, not a fact to schedule around.

- [Common pitfalls](#common-pitfalls)

## Context

Loosely coupled teams is one of DORA's technical capabilities, and it is as much an organizational finding as an architectural one: the
research ties team independence to software delivery performance because coordination cost, not raw system complexity, is what slows
delivery down. A team that must ask permission outside itself, or wait on another team's release, pays that cost on every change.

DORA frames the capability as teams that "can make large-scale changes to the design of their systems without the permission of somebody
outside the team or depending on other teams," working through well-defined interfaces and bounded contexts. It sits alongside continuous
delivery and trunk-based development in the DORA Core Model, and it depends on the same architectural discipline that those capabilities
assume: clear seams, explicit interfaces, and no hidden coupling through shared state or shared deployment windows.

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
globset's native trigger projection — never by hand-matching another track's source paths ([ADR-TRACK](../design/tracks.md)). That
subscription surface is what keeps a change in one track from rebuilding, or blocking on, every other track's teams.

Within a track, the same discipline applies one level down: the allowed edge between two modules is declared once in `dependencies.yml` and
gated against the actual code, so a module's dependents are a checked-in fact rather than whatever the code happens to call
([ADR-MODDEPS](../automation/controlling-module-dependencies.md)). And the platform stays open for extension without ever editing shared
infrastructure to accommodate a new consumer — a new module, function, or dependency is a new file, never a hand-edited registration that
every other contributor must route around ([ADR-EXTEND](../automation/open-closed-architecture.md)). Together these three give a concrete,
computed answer to "does this change require coordinating with, or waiting on, another team" — the question this capability is built to keep
answered "no."

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

Loosely coupled teams is DORA's link between organizational structure and delivery speed: the same independence that lets a team ship on its
own schedule is what the deployment-frequency and lead-time metrics ultimately measure at the system level.

- [Team experimentation](https://dora.dev/capabilities/team-experimentation/) — independent deployability is what lets a team run its own
  experiments without coordinating a shared release.
- [Teams empowered to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — a loosely coupled boundary is what
  makes an independent tooling choice safe in the first place.
- [Job satisfaction](https://dora.dev/capabilities/job-satisfaction/) — DORA ties reduced coordination overhead and team autonomy to lower
  burnout and higher satisfaction.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automates the independent, on-demand deployment that loose
  coupling makes possible.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
