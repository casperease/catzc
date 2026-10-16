---
catzc:
  immutable:
    with_body_sha: "1b8bb45ab915"
    path: docs/adr/research/trunk-based-development.md
    folder: docs/adr/research
    name: trunk-based-development
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-DORA-TRUNK#{1-5}
    cites:
      - ADR-DSGN-LIFE#6
      - ADR-FLOW-CD#2
      - ADR-PRIN-ONELIVE#4
    links:
      - docs/adr/design/commit-lifecycle.md#rule-adr-dsgn-life6
      - docs/adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2
      - docs/adr/principles/one-living-version.md#rule-adr-prin-onelive4
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#continuous-integration
      - docs/references/dora/capabilities.md#fast-flow
      - docs/references/dora/capabilities.md#test-automation
      - docs/references/dora/capabilities.md#trunk-based-development
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/capabilities.md#working-in-small-batches
      - docs/references/dora/core-model.md#version-history
      - docs/references/dora/index.md
      - docs/references/dora/metrics.md#instability
      - docs/references/dora/metrics.md#reliability
      - docs/references/dora/metrics.md#throughput
      - docs/references/dora/publications.md#2016-state-of-devops-report
      - docs/references/dora/publications.md#2017-state-of-devops-report
      - docs/references/dora/publications.md#2022-accelerate-state-of-devops-report
      - "https://dora.dev/capabilities/trunk-based-development/"
---

# ADR: DORA — Trunk-based development

## Rules: ADR-DORA-TRUNK

### Rule ADR-DORA-TRUNK:1

Keep branches short-lived: merge individual work into trunk at least once a day, and ideally several times a day. A branch that lives more
than a few hours is an exception to explain, not the normal unit of work.

- [Summary](#summary)

### Rule ADR-DORA-TRUNK:2

Cap active branches at three or fewer, and treat a code freeze or a dedicated stabilization/integration phase as a signal that trunk-based
development is not actually being followed — never as an accepted part of a normal release cadence.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-TRUNK:3

Treat small-batch decomposition as a skill every developer owns, and hold whoever merges to trunk responsible for keeping the build green
afterward — that responsibility never moves to a separate downstream team or a later gate.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-TRUNK:4

Review code synchronously — live review or pairing — at the moment a change is ready to merge. A heavyweight, multi-approval, asynchronous
review queue pushes developers toward larger batches and stalls the exact flow trunk-based development depends on.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-TRUNK:5

Run comprehensive automated tests against every change before it commits to trunk, and keep the build fast — a few minutes, not longer — so
that testing discipline never becomes the excuse to batch changes together.

- [Common pitfalls](#common-pitfalls)

## Context

Trunk-based development is one of DORA's technical capabilities, and it sits directly beside the two capabilities it depends on: version
control (the mainline it merges into) and continuous integration (the discipline that validates each merge). DORA defines it in contrast to
feature branching: "each developer divides their own work into small batches and merges that work into trunk at least once (and potentially
several times) a day," and "branches in trunk-based development typically last no more than a few hours, with many developers merging their
individual changes into trunk frequently."[^1]

DORA's catalogue lists it as a predictor of software delivery and operational performance, although Core V2 removed it from the DORA Core
Model and put working in small batches in its place. DORA's research (drawn from the 2016–2017 State of DevOps work) found that teams
following three practices — three or fewer active branches, merging to trunk at least once daily, and no code freezes or integration phases
— achieve higher delivery speed, stability, and availability than teams that do not. Feature branching, by contrast, defers integration and
so requires "bigger and more complex merge events" plus "additional stabilizing efforts and code freeze periods" to compensate.

## Summary

The capability is developers dividing their own work into small batches and merging it into a shared trunk at least once a day, rather than
accumulating change on long-lived feature branches. Branches exist, but they are short — typically hours, not days — and a developer pushes
directly to trunk with any release branches merged back quickly. The benefit DORA names directly: "one key benefit of the trunk-based
approach is that it reduces the complexity of merging events and keeps code current."

## Why it matters

DORA's research associates the three trunk-based practices — few active branches, daily merges, no freezes — with higher software delivery
and operational performance. The mechanism is integration cost: a branch that lives for hours diverges from trunk by a small, easy-to-merge
amount, while a branch that lives for days or weeks diverges by an amount that turns every merge into its own project. Feature branching
pays that cost indirectly, through bigger merge events and the stabilizing phases and code freezes teams add to absorb them — phases that
are themselves periods where the team is not shipping. Trunk-based development removes the need for the compensating mechanism by keeping
the underlying problem, large divergence, from building up in the first place.

## How to apply

The capability requires developers who can break their own work into small batches and who are responsible for keeping the build green after
they merge — a skill and a habit, not just a branching policy. It also requires the practices that make small, frequent merges safe:
synchronous code review or pairing at the point of merge, comprehensive automated testing run against every change before it commits, and a
build fast enough — DORA's guidance is a few minutes — that this testing never becomes a bottleneck. Branch protection that requires passing
tests, and advocates or mentors who help the rest of the team adopt the discipline, support the transition.

This platform realizes the capability directly: one living version of every behaviour is kept on trunk with no long-lived release or version
branches carrying an alternate copy of the code ([ADR-PRIN-ONELIVE#4](../principles/one-living-version.md#rule-adr-prin-onelive4)). The CI
discipline's 5–10 minute integration budget is the mechanical enforcement of "merge small and merge often"
([ADR-FLOW-CD#2](../flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd2)), and the commit lifecycle's rule that consumers sync from
the stable `main-UAT` occupant rather than the dirty tip of main keeps a trunk that merges frequently from also being a trunk that is unsafe
to build on ([ADR-DSGN-LIFE#6](../design/commit-lifecycle.md#rule-adr-dsgn-life6)).

## Common pitfalls

- **Heavyweight code review.** A review process that requires multiple approvals before a merge discourages developers from working in small
  batches — a change sits waiting for approval, so the incentive is to bundle more into it, and the queue of unreviewed changes grows into a
  downward spiral.
- **Asynchronous reviews.** Delaying review past the moment the developer is ready to merge increases the chance of a merge conflict by the
  time it is approved. A synchronous review, live or paired, at the point of readiness avoids the delay entirely.
- **Insufficient testing before commit.** Trunk stays stable only when tests run against every change before it commits; skipping or
  shrinking that testing to keep merges fast trades away the stability the whole capability exists to protect.

## References

[^1]:
    DORA, _Trunk-based development_ capability, <https://dora.dev/capabilities/trunk-based-development/>. A capability that predicts
    software delivery and operational performance; removed from the DORA Core Model in Core V2.

## Dora explains

Trunk-based development is a fast-flow capability that DORA's research ties to delivery speed, stability, and availability: teams with three
or fewer active branches, at least daily merges to trunk, and no code freezes or integration phases perform better. It drives continuous
delivery, but it is outside the Core Model: Core V2 replaced it with working in small batches.

- **Catalogue entry:** [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development)
- **Category:** [Fast flow](../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0: not in the Core Model (removed in V2, with
  working in small batches taking its place; see [version history](../../references/dora/core-model.md#version-history)).
- **Evidence:**
  - [2016 State of DevOps Report](../../references/dora/publications.md#2016-state-of-devops-report) — cited on the capability page for the
    trunk-based findings.
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — cited on the capability page; the
    report finds version control, continuous integration, trunk-based development, and test automation essential to continuous delivery.
  - [2022 Accelerate State of DevOps Report](../../references/dora/publications.md#2022-accelerate-state-of-devops-report) — with
    above-average documentation quality, trunk-based development's lift on organizational performance rises from 36% to 1525%.
- **Predicts:** higher software delivery and operational performance — speed ([throughput](../../references/dora/metrics.md#throughput)),
  stability ([instability](../../references/dora/metrics.md#instability)), and availability
  ([reliability](../../references/dora/metrics.md#reliability)). It is one of the capabilities that drive
  [continuous delivery](../../references/dora/capabilities.md#continuous-delivery), and the continuous integration page calls it predictive
  of delivery performance.
- **Related capabilities:**
  - [Version control](../../references/dora/capabilities.md#version-control) — the recoverable, attributable history a trunk-based team
    merges its small batches into.
  - [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — the validation discipline that proves each
    small, frequent merge is safe to build on.
  - [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — the batch-decomposition skill trunk-based
    development depends on developers having, and its replacement in the Core Model.
  - [Test automation](../../references/dora/capabilities.md#test-automation) — the automated testing run against every change before it
    commits to trunk.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
