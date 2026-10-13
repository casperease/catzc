# docs/adr/research/flexible-infrastructure.md

`ADR: DORA — Flexible infrastructure`

## Rules: ADR-DORA-FLEXINFRA

### Rule ADR-DORA-FLEXINFRA:1

Flexible infrastructure means five NIST characteristics together — on-demand self-service, broad network access, resource pooling, rapid
elasticity, and measured service — not any single one of them in isolation; a system that scales but still needs a human to provision it is
not flexible infrastructure.

- [Summary](#summary)

### Rule ADR-DORA-FLEXINFRA:2

Infrastructure configuration is checked into version control, and provisioning, configuration changes, and deployments happen through an
automated mechanism — never through console clicks, manual tickets, or an undocumented runbook.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-FLEXINFRA:3

Adopting infrastructure as code is a cross-functional change, not a tooling swap — it touches information-security controls and approval
policy as much as it touches provisioning scripts, so it rolls out through a single, low-risk pilot application before it scales org-wide.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-FLEXINFRA:4

Self-service infrastructure stays a guardrail, never a gate: an Internal Developer Platform that mandates rigid, one-size-fits-all
infrastructure or requires a manual ticket to reach cloud resources has negated the capability it claims to offer.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-FLEXINFRA:5

Measure the capability by what NIST's characteristics predict — time to provision, self-service adoption rate, elasticity, and cost
transparency — never by the raw percentage of workloads hosted on cloud servers or by migration volume and speed.

- [Common pitfalls](#common-pitfalls)

## Context

Flexible infrastructure is DORA's technical capability for the compute, storage, and network layer underneath everything else: continuous
delivery, deployment automation, and platform engineering all assume that an environment can be provisioned and changed without waiting on
hardware procurement or a manual ticket. DORA grounds the capability in the NIST definition of cloud computing, which names five essential
characteristics — on-demand self-service, broad network access, resource pooling, rapid elasticity, and measured service.[^1]

DORA frames the mechanism for reaching that state as infrastructure as code: infrastructure configuration lives in version control, and
developers provision environments, change configuration, and execute deployments through an automated path rather than a manual one.
Flexible infrastructure is also the layer that platform engineering builds on — DORA calls it "the underlying engine that powers successful
platform engineering," because an Internal Developer Platform can only offer genuine self-service when the infrastructure underneath it is
itself self-service, elastic, and measured.

## Summary

Flexible infrastructure lets teams rapidly and reliably adapt to changing business needs without being bottlenecked by hardware procurement
or manual provisioning. DORA operationalizes this through the five NIST characteristics: on-demand self-service (consumers provision
resources without human interaction from the provider), broad network access (capabilities reachable from diverse devices), resource pooling
(provider resources pooled in a multi-tenant model and dynamically assigned), rapid elasticity (capabilities scale outward or inward on
demand), and measured service (resource use is automatically controlled, optimized, and reported).

The mechanism that gets a team to that state is infrastructure as code: infrastructure configuration checked into version control, with
provisioning, configuration changes, and deployments executed through an automated mechanism rather than by hand.

## Why it matters

DORA's research ties flexible infrastructure to a 30% gain in organizational performance, alongside faster throughput and higher levels of
stability. It also improves cost visibility: teams meeting all five cloud characteristics are 2.6 times more likely to be able to accurately
estimate the cost to operate their software. In an AI-accelerated development context, flexible, elastic infrastructure is also what lets
teams spin up automated, on-demand test environments to absorb higher change volume and catch AI-generated regressions before they reach
production.

## How to apply

Adopt infrastructure as code as the mechanism: infrastructure configuration lives in version control, and provisioning, configuration
changes, and deployments run through an automated path. Treat the move as a cross-functional change rather than a tooling swap — it requires
real engineering effort and touches policy, including how information-security controls get implemented — and start small, piloting the
automated process on a single, low-risk application before scaling it further.

Flexible infrastructure is the engine that platform engineering runs on: an Internal Developer Platform built on top of it can prioritize
self-service and autonomy, so developers focus on writing application code instead of waiting on infrastructure. This platform realizes that
model as a thin CLI over the Azure control plane ([ADR-DSGN-THINPLAT](../design/thin-platforms.md)), with self-service provisioning made
safe by routing every change through a single versioned source of truth and trunk-based guardrails rather than a manual ticket
([ADR-DSGN-SELFSERV](../design/self-service.md)). The Azure data model turns environment, subscription, and resource-group identity into
resolved, config-driven values instead of hand-typed ones ([ADR-AZ-DATAMOD](../azure/azure-data-model.md)), which is what lets provisioning
scale elastically across environments and customers without hand-authored drift.

Align incentives alongside the technical change — give system owners both the visibility to build more efficient systems and the incentive
to do so, so efficiency gains are pursued rather than left on the table.

## Common pitfalls

- **The cloud penalty (lift and shift).** Moving an application to the cloud unchanged, without adapting its architecture to the platform,
  can leave an organization worse off than staying in the data center — the benefits of flexible infrastructure accrue to workloads willing
  to transform, not to a like-for-like relocation.
- **Building gates instead of guardrails.** An Internal Developer Platform that mandates rigid, one-size-fits-all infrastructure
  requirements or requires a manual ticket to approve access to cloud resources negates the self-service benefit the capability exists to
  provide.
- **Incentivizing the wrong metrics.** Rewarding pure migration volume or speed drives teams to bypass modernization and architectural
  updates, producing a sprawling cloud footprint instead of a flexible one.
- **Measuring the wrong thing.** Success is not the percentage of workloads hosted on cloud servers. Measure instead against the NIST
  characteristics: time to provision (how long from request to a ready environment or resource), self-service adoption rate (the share of
  infrastructure requests fulfilled automatically via APIs or a platform versus a manual IT ticket), elasticity (whether the system scales
  up and down without human intervention), and cost transparency (whether a product team can view and forecast its own infrastructure
  costs).

## References

[^1]:
    DORA, _Flexible infrastructure_ capability, <https://dora.dev/capabilities/flexible-infrastructure/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Flexible infrastructure sits in the Core Model's fast-flow group. DORA defines it by the five NIST cloud characteristics and ties it to
continuous delivery, software delivery performance, availability, cost visibility, and organizational performance — but only when a team
adopts that flexibility: moving to the cloud without it ("lift and shift") makes performance worse.

- **Catalogue entry:** [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure)
- **Category:** [Fast flow](../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0:
  [fast flow](../../references/dora/core-model.md#fast-flow).
- **Evidence:**
  - [2018 Accelerate State of DevOps Report](../../references/dora/publications.md#2018-accelerate-state-of-devops-report) — teams that use
    the essential cloud characteristics are 23× more likely to be elite performers.
  - [2019 Accelerate State of DevOps Report](../../references/dora/publications.md#2019-accelerate-state-of-devops-report) — 29% of cloud
    adopters meet all five characteristics, and those that do are 2.6× more likely to estimate their costs accurately.
  - [2021 Accelerate State of DevOps Report](../../references/dora/publications.md#2021-accelerate-state-of-devops-report) — teams using all
    five cloud characteristics improve delivery, operational, and organizational performance.
  - [2022 Accelerate State of DevOps Report](../../references/dora/publications.md#2022-accelerate-state-of-devops-report) — its report page
    names the capability.
  - [2023 Accelerate State of DevOps Report](../../references/dora/publications.md#2023-accelerate-state-of-devops-report) — flexible
    infrastructure yields 30% higher organizational performance, while plain lift-and-shift can do harm.
  - [2024 Accelerate State of DevOps Report](../../references/dora/publications.md#2024-accelerate-state-of-devops-report) — flexible
    infrastructure raises organizational performance, and a cloud migration that does not use its flexibility can be worse than staying in a
    data centre.
- **Predicts:** [continuous delivery](../../references/dora/capabilities.md#continuous-delivery),
  [software delivery performance](../../references/dora/core-model.md#software-delivery-performance), availability (see
  [reliability](../../references/dora/metrics.md#reliability)), cost visibility, and
  [organizational performance](../../references/dora/core-model.md#organizational-performance).
- **Related capabilities:**
  - [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — the Internal Developer Platform that flexible
    infrastructure powers; self-service infrastructure is what lets it offer genuine autonomy.
  - [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the automated mechanism infrastructure as code
    provisions and deploys through.
  - [Version control](../../references/dora/capabilities.md#version-control) — the source of truth infrastructure configuration is checked
    into under infrastructure as code.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
