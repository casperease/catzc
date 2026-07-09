# ADR: Pull work through the system — do not push it

## Rules: ADR-PULLWORK

### Rule ADR-PULLWORK:1

Work is pulled, not pushed. A stage takes the next item only when it has the capacity to finish it; pushing work into a stage that is not
ready creates queues and partially-done work ([ADR-NOWASTE](../principles/reduce-waste.md), the partially-done-work waste).

- [Decision](#decision)

### Rule ADR-PULLWORK:2

Reduce batch size to the smallest increment that can move on its own. Small batches shorten feedback, lower the cost of any one change, and
keep queues short ([ADR-QUEUECOST](queues-cost-money.md)); large batches do the opposite on every count.

- [Decision](#decision)

### Rule ADR-PULLWORK:3

Defer commitment to the last responsible moment. Decide when the most is known, and keep reversible options open where the cost of keeping
them is low — but decide before the lack of a decision starts to cost more than the option is worth.

- [Why](#why)

### Rule ADR-PULLWORK:4

Limit work in progress. Finishing beats starting: a cap on concurrent work forces the queue down, exposes the real constraint, and reduces
the task-switching waste ([ADR-NOWASTE](../principles/reduce-waste.md)) — by Little's Law, less work-in-progress is directly less lead time
([ADR-QUEUECOST](queues-cost-money.md)).

- [How to apply](#how-to-apply)

## Context

A push system schedules work from the top: forecast demand, break it into a plan, and push each batch into the next stage on schedule,
whether or not that stage is ready. Toyota rejected this because pushing into an unready stage builds inventory — work sitting in a queue,
tying up capital, decaying, and hiding problems. Its replacement is the pull system, signalled by kanban: a stage draws its next input only
when it has finished the last, so the amount of work in flight is capped and demand, not a forecast, sets the pace [^1].

In software the "inventory" is partially-done work — unmerged branches, half-built features, tickets in flight
([ADR-NOWASTE](../principles/reduce-waste.md)) — and the cost is the same: capital tied up, merge risk accumulating, and the real bottleneck
hidden behind a full queue. This article states the pull discipline; its cost side — why the queues are where the money goes — is
[ADR-QUEUECOST](queues-cost-money.md).

## Decision

Pull work through the flow rather than pushing it, in the smallest batches, deciding as late as is responsible, with work-in-progress
capped:

- **Pull.** A stage starts a new item only when it can finish it, signalled by its own free capacity — not by an upstream schedule that
  needs somewhere to put its output.
- **Small batches.** Break work down to the smallest increment that can be integrated and delivered on its own. This is the same move agile
  makes for responsiveness ([ADR-VALUES](agile-values.md)) and lean makes for flow — one lever, two payoffs.
- **Defer commitment.** Make irreversible decisions at the last responsible moment, when knowledge is greatest ([ADR-LEAN](lean.md)). This
  is not procrastination: it is refusing to spend certainty you do not yet have, while still deciding before indecision itself becomes the
  cost.
- **Limit work in progress.** Cap the number of items in flight. The cap is what actually forces small batches and exposes the constraint,
  rather than merely encouraging them.

## Why

**Pushing builds invisible inventory.** Work pushed into an unready stage does not get done faster; it waits, and waiting work is the
dominant cost in the system ([ADR-QUEUECOST](queues-cost-money.md)). Pull caps the inventory by construction.

**Small batches are the highest-leverage lever.** A smaller batch fails smaller, reviews faster, integrates cleaner, and reaches feedback
sooner. Nearly every flow benefit — shorter queues, faster learning, lower change cost — traces back to shrinking the batch.

**Late decisions are better-informed decisions.** The cost of change rises over time, so the most valuable moment to decide is the last one
at which the decision is still cheap. Deferring commitment keeps options open until then; the discipline is knowing when "the last
responsible moment" has arrived and committing [^2].

**A WIP limit makes the rest real.** "Prefer small batches" and "finish before starting" are aspirations until a cap enforces them. The
limit is what turns pull from a slogan into a mechanism, and by Little's Law it lowers lead time arithmetically
([ADR-QUEUECOST](queues-cost-money.md)).

## How to apply

Start fewer things and finish them. Before pulling in new work, ask whether there is capacity to complete it or whether it will simply join
a queue as partially-done work ([ADR-NOWASTE](../principles/reduce-waste.md)). Break a change into the smallest slice that can integrate and
deliver on its own, rather than batching several concerns into one large push. Hold irreversible decisions until the last responsible
moment, and keep the number of changes in flight small enough that the flow, not the plan, sets the pace.

## References

[^1]:
    Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988). Just-in-time and the kanban pull signal: a stage
    produces only what the next stage has pulled, capping inventory and exposing problems that a full queue would hide.

[^2]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003), principles "Deliver fast" and "Defer commitment" — pull,
    small batches, and last-responsible-moment decisions applied to software.

## Dora explains

DORA finds that working in small batches and limiting work in progress are among the strongest predictors of short lead time and stable
delivery — the pull discipline measured directly.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the core pull move and the strongest single lever on
  lead time.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — a WIP cap is what turns pull and small batches into an enforced
  mechanism.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — pulling small increments to done on demand is continuous
  delivery in practice.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
