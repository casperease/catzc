---
catzc:
  derived:
    path: docs/adr/research/working-in-small-batches.md
    kind: adr
    body_sha: "9e7c3e8c16ec"
    adrs: []
---

# ADR: DORA — Working in small batches

## Rules: ADR-DORA-SMALLBATCH

### Rule ADR-DORA-SMALLBATCH:1

Break work into the smallest unit that is independent, negotiable, valuable, estimable, small, and testable (INVEST) — a slice that can be
deployed and validated on its own rather than a fragment that only makes sense bundled with other work.

- [Summary](#summary)

### Rule ADR-DORA-SMALLBATCH:2

Treat a unit of work that takes longer than a week to complete as too large. Split it further; do not let a large pull request —
AI-generated or hand-written — stand in for decomposition that was skipped.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-SMALLBATCH:3

Check releasable changes into trunk at least daily. Small batches only shorten the feedback loop when they are integrated continuously, not
accumulated on a branch and merged in one motion.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-SMALLBATCH:4

Use dark launching or feature toggles to merge incomplete work safely. Code completion and user-facing release are separate events; a batch
can integrate today and activate later.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-SMALLBATCH:5

Release and validate each batch as it completes. Never regroup several small batches into one larger release before testing or shipping —
that delays exactly the defect and user-validation feedback small batching exists to speed up.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-SMALLBATCH:6

Hold batch size down deliberately when AI assistance raises throughput. Small batches are the safety net that keeps faster, machine-assisted
change from turning into delivery instability.

- [Why it matters](#why-it-matters)

## Context

Working in small batches is a DORA capability describing how work is sized and sequenced, not a tool or a pipeline stage. DORA states it
plainly: "Working in small batches is an essential principle in any discipline where feedback loops are important, or you want to learn
quickly from your decisions."[^1] It sits alongside continuous integration and continuous delivery in the DORA Core Model, where Core V2 put
it in place of trunk-based development — those capabilities assume the work arriving at them is already sliced small enough to integrate,
test, and release quickly.

DORA's current framing gives the capability added weight in the AI era: generative AI tools tend to produce large, sweeping changes, and
without a deliberate discipline of small batches that tendency erodes review quality and delivery stability. DORA finds that working in
small batches amplifies AI's positive effect on product performance and turns AI's otherwise-neutral effect on friction into a net positive.

## Summary

The capability is sizing and sequencing work as the smallest unit that can move through the system on its own. DORA recommends the INVEST
principle for planning: batches should be **Independent** (deployable and verifiable on their own), **Negotiable** (iterable and open to
renegotiation as feedback arrives), **Valuable** (each one delivers something a stakeholder cares about), **Estimable** (enough is known to
scope it), **Small** (completable within hours to a couple of days inside a sprint), and **Testable** (verifiable on its own terms).

Applied day to day, this means developers check releasable changes into trunk at least daily, and use dark launching or feature toggles to
let code merge before the feature it belongs to is ready to show users. Batch size is a property of planning and integration cadence, not a
tool choice.

## Why it matters

DORA's research finds working in small batches, as part of lean product management, predicts software delivery and organizational
performance. The mechanism is the feedback loop: a small batch reaches production, a test suite, or a reviewer sooner, so the signal about
whether it works comes back sooner and course correction is cheap. A large batch defers that signal, and the longer it is deferred the more
expensive a wrong turn becomes. Small batches also raise efficiency and motivation — finishing something small is a completed unit of work,
not a fragment — and they guard against the sunk-cost fallacy, since there is less invested in any one slice for a team to feel obligated to
defend.

DORA is explicit that this capability has become more critical in the era of generative AI. AI tools can produce large amounts of change
quickly, and without small batching that capacity turns into large, hard-to-review contributions that destabilize delivery rather than
accelerate it. Working in small batches is what converts AI's raw throughput into a net positive rather than a net risk.

## How to apply

Plan features against INVEST so that a story is written small from the start rather than split under pressure later — independent enough to
deploy alone, negotiable enough to take feedback, valuable enough to justify shipping alone, estimable, completable in hours to a couple of
days, and testable on its own. Push developers to check releasable changes into trunk at least daily rather than holding them on a branch
until a larger feature is "done." Where a feature is not yet ready for users when its code is ready to merge, separate those two events with
dark launching or a feature toggle instead of delaying the merge.

Measure the discipline rather than assuming it: track how often production releases are possible across teams, what proportion of features
complete within a week or less, and whether features are actively decomposed to support minimum viable slices and rapid cycles. A team that
cannot answer these is not yet working in small batches, regardless of intent.

This platform's pull discipline is the same lever under a different name: work is pulled in the smallest batch that can move on its own
([ADR-PROC-PULLWORK](../process/pull-work.md)), because batch size is what drives queue size and cost of delay
([ADR-PROC-QUEUECOST](../process/queues-cost-money.md)). The CI discipline's small, continuously-integrated increments into one mainline
([ADR-FLOW-CD](../flow/cd-discipline-and-promotion-flow.md)) are small batching applied to the integration step specifically.

## Common pitfalls

- **Insufficient decomposition.** Work that takes longer than a week to complete is too large. AI-assisted development tends to generate
  sweeping changes; resist letting a large pull request substitute for splitting the work, since it raises the cognitive load of review and
  defeats the point of batching small.
- **Regrouping before release.** Combining several small batches into one release, or holding them until a bigger bundle is ready to test or
  ship, delays exactly the defect and user-validation feedback that small batches exist to surface quickly.

## References

[^1]:
    DORA, _Working in small batches_ capability, <https://dora.dev/capabilities/working-in-small-batches/>. Part of the DORA Core Model of
    capabilities that predict software delivery and organizational performance.

## Dora explains

Working in small batches is the capability DORA's metrics guide names as the usual first lever for all five delivery metrics: smaller
changes are easier to reason about, move faster through delivery, and are easier to recover from. It is a fast-flow capability in the Core
Model, where Core V2 put it in place of trunk-based development, and one of the seven capabilities of the AI Capabilities Model, where it
counters the large, unstable changes AI tends to produce.

- **Catalogue entry:** [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches)
- **Category:** [Fast flow](../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0:
  [fast flow](../../references/dora/core-model.md#fast-flow) (see [version history](../../references/dora/core-model.md#version-history));
  also a member of the [AI Capabilities Model](../../references/dora/ai.md#ai-capabilities-model).
- **Evidence:**
  - [2016 State of DevOps Report](../../references/dora/publications.md#2016-state-of-devops-report) — an experimental approach to product
    development (small batches, visibility of workflow, customer feedback) improves IT and organizational performance.
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — lean product management (small
    batches, customer feedback) drives organizational performance.
  - [2023 Accelerate State of DevOps Report](../../references/dora/publications.md#2023-accelerate-state-of-devops-report) — listed on the
    capability page as evidence for the capability.
  - [2024 Accelerate State of DevOps Report](../../references/dora/publications.md#2024-accelerate-state-of-devops-report) — AI adoption
    lowers delivery throughput and stability, and small batches and robust testing matter as the counterweight.
  - [2025 State of AI-assisted Software Development](../../references/dora/publications.md#2025-state-of-ai-assisted-software-development) —
    introduces the AI Capabilities Model, with working in small batches as one of its seven capabilities.
  - [2025 DORA AI Capabilities Model](../../references/dora/publications.md#2025-dora-ai-capabilities-model) — implementation strategies and
    ways to monitor progress for each of the seven capabilities.
- **Predicts:** as part of lean product management,
  [software delivery performance](../../references/dora/core-model.md#software-delivery-performance) and
  [organizational performance](../../references/dora/core-model.md#organizational-performance); the metrics guide names batch size the usual
  first lever for [change lead time](../../references/dora/metrics.md#change-lead-time),
  [deployment frequency](../../references/dora/metrics.md#deployment-frequency),
  [failed deployment recovery time](../../references/dora/metrics.md#failed-deployment-recovery-time),
  [change fail rate](../../references/dora/metrics.md#change-fail-rate), and
  [deployment rework rate](../../references/dora/metrics.md#deployment-rework-rate)
  ([key insights](../../references/dora/metrics.md#key-insights)). With AI, it amplifies AI's positive effect on
  [product performance](../../references/dora/ai.md#product-performance), turns AI's neutral effect on
  [friction](../../references/dora/ai.md#reduced-friction) positive, and counters AI-driven instability; the model diagram also connects it
  to [individual effectiveness](../../references/dora/ai.md#individual-effectiveness).
- **Related capabilities:**
  - [WIP limits](../../references/dora/capabilities.md#wip-limits) — capping concurrent work is the mechanism that forces batch size down
    rather than merely encouraging it.
  - [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — daily integration of small batches into one
    mainline is the branching discipline this capability depends on.
  - [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — validates each small batch fast enough to keep
    the feedback loop short.
  - [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — carries each validated small batch toward release
    without waiting for it to be regrouped with others.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
