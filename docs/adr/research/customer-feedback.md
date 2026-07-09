# ADR: DORA — Customer feedback

## Rules: ADR-DORACF

### Rule ADR-DORACF:1

Gather feedback from the customer before defining any candidate feature, and use it to validate that the problem is real before a solution
is designed for it. A feature justified by an assumption about the customer, not by evidence from the customer, has not cleared the bar.

- [How to apply](#how-to-apply)

### Rule ADR-DORACF:2

Once a real problem is confirmed, iterate toward a solution that solves that problem and nothing more, and check its business viability
before committing further work to it. Scope grows from validated need, not from the size of the idea.

- [How to apply](#how-to-apply)

### Rule ADR-DORACF:3

Judge success by outcome metrics — for example acquisition, activation, retention, referral, and revenue (AARRR) — never by whether a
feature shipped. Shipping is an input to the outcome, not the outcome itself.

- [Summary](#summary)

### Rule ADR-DORACF:4

Collect customer satisfaction metrics on a regular cadence, and keep them updated and broadcast rather than gathered once and filed away. A
metric nobody sees cannot inform a design decision.

- [Why it matters](#why-it-matters)

### Rule ADR-DORACF:5

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

catzc treats the teams that consume the platform as its customers ([ADR-THINPLAT](../design/thin-platforms.md)) — a platform team building a
product for other teams, not a project delivered once and left alone. The evidence this capability calls for is the same evidence the
platform's own inspect-and-adapt loop already consumes ([ADR-KAIZEN](../process/inspect-and-adapt.md)): that loop's outermost turn closes on
what a consuming team actually experiences, not on an assumption about what it wants, which is exactly the "gather feedback, validate the
problem" sequence this capability describes. The agile value of customer collaboration over contract negotiation
([ADR-VALUES](../process/agile-values.md#rule-adr-values3)) is the standing commitment behind it: a continuing relationship with consuming
teams, not a fixed specification agreed once, is what is allowed to steer what the platform builds next.

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
    DORA, _Customer feedback_ capability, <https://dora.dev/capabilities/customer-feedback/>. Part of the DORA Core Model of capabilities
    that predict software delivery performance, grouped under lean product management.

## Dora explains

DORA ties customer feedback to both software delivery performance and organizational performance, treating it as one of the practices that
keeps a team's delivery effort pointed at outcomes that matter rather than at output for its own sake.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — a small batch is what makes it affordable to
  validate with the customer before committing further work.
- [Team experimentation](https://dora.dev/capabilities/team-experimentation/) — experimentation is the mechanism that turns validated
  feedback into a shipped, tested change.
- [Visibility of work in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — satisfaction metrics are only
  useful when they are kept as visible as the rest of the delivery flow.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
