# ADR: DORA — Visibility of work in the value stream

## Rules: ADR-DORA-WORKVIS

### Rule ADR-DORA-WORKVIS:1

Make the flow of work visible end to end, from business intent through to the customer, not only at the station a team happens to own.
Visibility of work means understanding how work moves through the whole value stream and having visibility into that flow, including product
and feature status.

- [Summary](#summary)

### Rule ADR-DORA-WORKVIS:2

Keep the current state of work on a shared, visual display or dashboard that anyone can read, rather than reconstructing it from memory, a
status meeting, or a chat thread. Information about the flow of product development work stays readily available, not gathered on request.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-WORKVIS:3

Map the value stream with the cross-functional stakeholders who actually do the work, covering the whole stream end to end rather than one
team's segment of it, and record lead time, process time, and percent complete and accurate at each step. Re-run the mapping exercise
periodically rather than treating one map as permanent.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-WORKVIS:4

Treat visibility of work as a driver of organizational performance as well as delivery performance — profitability, market share, and
productivity — not merely a delivery-team convenience.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-WORKVIS:5

Direct improvement effort at the bottleneck the value-stream map actually shows, and grant the team the authority to change it, rather than
assuming the organization already understands its own stream or polishing the step that is easiest to see.

- [Common pitfalls](#common-pitfalls)

## Context

Visibility of work in the value stream sits in DORA's lean product management cluster, alongside working in small batches, team
experimentation, and visibility into customer feedback. DORA defines it as the extent to which teams understand how work flows from business
through to customers and have visibility into that flow, including product and feature status.[^1]

DORA's research finds that this cluster of capabilities predicts both software delivery performance and organizational performance —
measured in profitability, market share, and productivity. Visibility of work is therefore not a reporting nicety layered on top of
delivery; it is one of the mechanisms DORA associates with better outcomes on both axes.

## Summary

A team proficient in this capability understands how work moves through the business from idea to customer, has visibility into that flow,
shows the flow state on visual displays or dashboards, and keeps information about the flow of product development work readily available
rather than gathered on demand.

DORA's recommended approaches are concrete: hold a value stream mapping exercise with cross-functional stakeholders, covering five to
fifteen process blocks and recording lead time, process time, and percent complete and accurate for each; visualize the current state with
kanban boards, card walls, or storyboards that carry work-in-progress limits; create a future-state map and re-run the exercise regularly,
for example every six months; and share the resulting artifacts across the organization, updating them at least annually.

## Why it matters

DORA ties this capability to both software delivery performance and organizational performance, so the payoff is not confined to the
engineering function. A value stream that is mapped and visible lets an organization see where work actually waits, rather than where it
feels like it waits, and that shared, accurate picture is what makes prioritizing an improvement a matter of evidence instead of opinion.
Without it, every claim about where the flow is slow competes on anecdote, and effort tends to land on the step that is most visible or most
irritating rather than the one that is actually constraining throughput.

## How to apply

This platform renders the flow rather than reporting on it: the value-chain diagrams show every commit's delivery state by construction —
position is time, colour is the furthest state reached — so a reader decodes where a change sits without asking anyone
([ADR-DSGN-VISUAL](../design/visual-design.md)). The underlying discipline that diagram specialises is stated generally: treat the state of
work as something rendered and observed, not inferred from memory, and judge progress from the real running artifact rather than a proxy
like a ticket status ([ADR-PROC-OBSERVEWIP](../process/observe-work.md)).

Applying the capability elsewhere follows the same shape: pick a flow worth mapping, walk it end to end with the people who actually do each
step, record where time is spent rather than assuming, and put the resulting picture somewhere everyone can see it without asking — a
dashboard, a rendered diagram, or a shared board — and revisit it on a cadence rather than once.

## Common pitfalls

- **Assuming the map is already known.** Overestimating how well the organization understands its own end-to-end value stream skips the
  mapping exercise that would have surfaced the actual bottleneck.

- **Mapping a segment instead of the stream.** Covering only the part a single team owns, rather than the full path from business intent to
  customer, hides handoffs and waits that sit between teams.

- **Improving the wrong step.** Focusing effort on the area that is easiest to see or most familiar, rather than the one the map shows as
  the actual constraint, spends effort without moving the bottleneck.

- **Withholding the authority to act.** Producing a map and a set of dashboards without giving the team the authority to change what they
  show leaves visibility with no path to improvement.

## References

[^1]:
    DORA, _Visibility of work in the value stream_ capability, <https://dora.dev/capabilities/work-visibility-in-value-stream/>. Part of the
    DORA Core Model of capabilities that predict software delivery performance and organizational performance.

## Dora explains

DORA groups this capability with working in small batches, team experimentation, and visibility into customer feedback as its lean product
management cluster, and finds the cluster predicts both software delivery performance and organizational performance — profitability, market
share, and productivity.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — smaller batches are easier to see moving through a
  visible value stream, and a visible stream makes batch size itself easy to observe.
- [Visibility into customer feedback](https://dora.dev/capabilities/customer-feedback/) — the value stream this capability makes visible
  runs all the way to the customer, and customer feedback is what closes that loop.
- [Visual management](https://dora.dev/capabilities/visual-management/) — the visual displays and dashboards this capability calls for are
  visual management applied to the value stream specifically.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — a visible stream is what shows a team where a work-in-progress limit
  is needed and whether it is holding.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
