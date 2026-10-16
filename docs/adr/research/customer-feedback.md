---
catzc:
  immutable:
    with_body_sha: "6d931cf1787f"
    path: docs/adr/research/customer-feedback.md
    folder: docs/adr/research
    name: customer-feedback
    filetype: md
    kind: adr
    language: markdown
    track: docs
  edges:
    defines:
      - ADR-DORA-FEEDBACK#{1-5}
    links:
      - docs/adr/design/thin-platforms.md
      - docs/adr/process/agile-values.md#rule-adr-proc-values3
      - docs/adr/process/inspect-and-adapt.md
      - docs/references/dora/capabilities.md#customer-feedback
      - docs/references/dora/capabilities.md#fast-feedback
      - docs/references/dora/capabilities.md#team-experimentation
      - docs/references/dora/capabilities.md#work-visibility-in-value-stream
      - docs/references/dora/capabilities.md#working-in-small-batches
      - docs/references/dora/core-model.md#organizational-performance
      - docs/references/dora/index.md
      - docs/references/dora/metrics.md#instability
      - docs/references/dora/metrics.md#reliability
      - docs/references/dora/metrics.md#throughput
      - docs/references/dora/publications.md#2016-state-of-devops-report
      - docs/references/dora/publications.md#2017-state-of-devops-report
      - docs/references/dora/publications.md#2019-accelerate-state-of-devops-report
      - "https://dora.dev/capabilities/customer-feedback/"
---

# ADR: DORA — Customer feedback

## Rules: ADR-DORA-FEEDBACK

### Rule ADR-DORA-FEEDBACK:1

Gather feedback from the customer before defining any candidate feature, and use it to validate that the problem is real before a solution
is designed for it. A feature justified by an assumption about the customer, not by evidence from the customer, has not cleared the bar.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-FEEDBACK:2

Once a real problem is confirmed, iterate toward a solution that solves that problem and nothing more, and check its business viability
before committing further work to it. Scope grows from validated need, not from the size of the idea.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-FEEDBACK:3

Judge success by outcome metrics — for example acquisition, activation, retention, referral, and revenue (AARRR) — never by whether a
feature shipped. Shipping is an input to the outcome, not the outcome itself.

- [Summary](#summary)

### Rule ADR-DORA-FEEDBACK:4

Collect customer satisfaction metrics on a regular cadence, and keep them updated and broadcast rather than gathered once and filed away. A
metric nobody sees cannot inform a design decision.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-FEEDBACK:5

Act on feedback even when it is inconvenient, and never structure a team so that it is blocked from acting on what it learns. Feedback that
cannot change a decision is a ritual, not a capability.

- [Common pitfalls](#common-pitfalls)

## Context

Customer feedback is one of DORA's capabilities for lean product management, grouped alongside visibility of work in the value stream,
working in small batches, and team experimentation. Where those capabilities shape how work moves once it is underway, customer feedback
shapes what work is worth starting: it is the mechanism that keeps a team building the right thing, not only building things right.

DORA frames it as a discipline with a definite shape — gather feedback first, validate the problem, iterate a solution scoped to that
problem, confirm viability, and track outcome metrics — rather than a vague instruction to "listen to users".[^1] The shape matters because
each step guards against a specific failure: skipping straight to a solution, over-building past the validated problem, or declaring success
on delivery instead of on outcome.

## Summary

The capability is regularly collecting customer satisfaction metrics and seeking out customer input on product quality, then using that
input to inform design decisions. DORA describes the pattern as a six-step loop: gather customer feedback first, before defining any
potential features; validate that a real problem exists; iterate on a solution that actually solves that problem, and nothing more; confirm
business viability; track key metrics to gauge success, for example AARRR (acquisition, activation, retention, referral, revenue); and
iterate again to improve those metrics.

The through-line is that a feature is not evidence of progress by itself. It is a hypothesis, tested against a validated problem and then
against outcome metrics, and the loop only closes when the metrics move — not when the code ships.

## Why it matters

DORA's research associates this capability with higher performance on two axes: software delivery performance, measured in delivery speed,
stability, and availability, and organizational performance, measured in profitability, market share, and productivity. Teams that collect
customer satisfaction metrics regularly and use that feedback to help design products show stronger outcomes on both.

The mechanism is that feedback collected early and acted on continuously catches a wrong assumption while it is still cheap to change,
whereas feedback collected late — or not acted on — lets a team build fully, ship, and only then discover that the assumption was wrong.
Regular, visible satisfaction metrics are what make the signal available in time to act on it, rather than after the decision it should have
informed.

## How to apply

catzc treats the teams that consume the platform as its customers ([ADR-DSGN-THINPLAT](../design/thin-platforms.md)) — a platform team
building a product for other teams, not a project delivered once and left alone. The evidence-first stance this capability calls for is the
one the platform's own inspect-and-adapt loop applies ([ADR-PROC-KAIZEN](../process/inspect-and-adapt.md)): a change rests on signals
observed in the real system, not on an assumption or on seniority, which is the "gather feedback, validate the problem" sequence this
capability describes, applied to the platform's own process. The agile value of customer collaboration over contract negotiation
([ADR-PROC-VALUES](../process/agile-values.md#rule-adr-proc-values3)) is the standing commitment behind it: a continuing relationship with
consuming teams, not a fixed specification agreed once, is what is allowed to steer what the platform builds next.

## Common pitfalls

- **Feedback gathered too late, or not at all.** Defining a feature before validating that the problem is real inverts the loop; the feature
  then has no evidence behind it, only an assumption.

- **Feedback misread or ignored.** Misinterpreting what a customer needs, or setting aside feedback because it is inconvenient, defeats the
  purpose of gathering it in the first place — the loop only works if the signal is allowed to change the decision.

- **Teams blocked from acting on it.** A team that gathers feedback but has no room to act on it — because of process, approval, or
  structure — has the appearance of the capability without its effect.

- **Success measured by delivery, not outcome.** Treating a shipped feature as the finish line, rather than tracking whether it moved an
  outcome metric, is why DORA's research finds that only about a third of proposed features actually improve business outcomes.

## References

[^1]:
    DORA, _Customer feedback_ capability, <https://dora.dev/capabilities/customer-feedback/>. A fast-feedback capability outside the DORA
    Core Model, grouped under lean product management.

## Dora explains

Customer feedback is a fast-feedback capability outside the Core Model. DORA treats it as one of the lean product management capabilities,
which together predict both software delivery performance and organizational performance, and it finds that customer engagement also
strengthens people's identification with organizational goals.

- **Catalogue entry:** [Customer feedback](../../references/dora/capabilities.md#customer-feedback)
- **Category:** [Fast feedback](../../references/dora/capabilities.md#fast-feedback) — not in the Core Model.
- **Evidence:**
  - [2016 State of DevOps Report](../../references/dora/publications.md#2016-state-of-devops-report) — an experimental approach to product
    development (small batches, visibility of workflow, customer feedback) improves IT and organizational performance.
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — lean product management, including
    customer feedback, drives organizational performance.
  - [2019 Accelerate State of DevOps Report](../../references/dora/publications.md#2019-accelerate-state-of-devops-report) — cited on the
    capability page.
- **Predicts:** together with the other lean product management capabilities, software delivery performance — speed
  ([throughput](../../references/dora/metrics.md#throughput)), stability ([instability](../../references/dora/metrics.md#instability)), and
  availability ([reliability](../../references/dora/metrics.md#reliability)) — and
  [organizational performance](../../references/dora/core-model.md#organizational-performance) in profitability, market share, and
  productivity.
- **Related capabilities:**
  - [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — a small batch is what makes it affordable
    to validate with the customer before committing further work.
  - [Team experimentation](../../references/dora/capabilities.md#team-experimentation) — experimentation is the mechanism that turns
    validated feedback into a shipped, tested change.
  - [Work visibility in value stream](../../references/dora/capabilities.md#work-visibility-in-value-stream) — satisfaction metrics are only
    useful when they are kept as visible as the rest of the delivery flow.
- [DORA research program](../../references/dora/index.md) — the overview these findings sit within.
