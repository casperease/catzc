# ADR: DORA — Work in process limits

## Rules: ADR-DORAWIP

### Rule ADR-DORAWIP:1

A work in process (WIP) limit caps how much work is simultaneously assigned to a team member or sits in a workflow stage at once, so effort
concentrates on finishing a small number of high-priority items rather than spreading across many concurrent ones.

- [Summary](#summary)

### Rule ADR-DORAWIP:2

Visualize the work before limiting it. A board with a column per workflow stage — analysis, development, testing, operations — is the
precondition a WIP limit needs, because a limit on invisible work cannot be enforced or checked.

- [How to apply](#how-to-apply)

### Rule ADR-DORAWIP:3

Size each column's limit to the real capacity of the people who work it, not to an aspirational or round number — for example, four pairs of
developers implies a development-column limit of four, not more.

- [How to apply](#how-to-apply)

### Rule ADR-DORAWIP:4

Hold the limit once set, including through the idle time it sometimes produces. Idle time is a signal to fix the process causing the delay,
never a reason to raise the limit back up.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAWIP:5

Treat the limit itself as something imposed, not measured. What gets measured is its effect — mean lead time and its variability, whether
flow is increasing, whether obstacles surface, and whether the resulting actions target the real constraint.

- [Why it matters](#why-it-matters)

## Context

Work in process (WIP) limits are one of DORA's technical capabilities, and the one that turns pull and small batches from a description of
flow into an enforced mechanism. DORA defines the capability as restricting "the amount of work simultaneously assigned to team members" —
instead of multitasking across numerous assignments, a team prioritizes work, limits how much people work on, and focuses on completing a
small number of high-priority tasks.[^1]

The capability sits close to visual management and monitoring in DORA's model: a limit only functions once the work it constrains is
visible, and its value only shows up once the effect on flow is being watched. It formalizes the kanban half of lean thinking — pull signals
when a stage is ready for more work, and the WIP limit is the number that makes that signal real rather than aspirational.

## Summary

The capability is a cap on concurrent work, applied per person or per stage of a visualized workflow, sized to the real capacity of the
people doing that work and held even when it produces idle time. DORA reports that implementing WIP limits correctly produces shorter lead
times, higher quality, lower costs, and less waste, and that the effect is strongest when the limit is combined with a visual display of the
work and feedback loops from monitoring.

The requirement is not a single global cap but a limit per stage of the value stream — a number on each column of a storyboard — chosen from
team capacity and adjusted as flow changes, not fixed once and forgotten.

## Why it matters

DORA's research associates WIP limits, especially when combined with visual displays and monitoring feedback, with measurable improvements
in software delivery performance. The mechanism is that unbounded concurrent work hides its own cost: work sitting half-finished ties up
capacity, obscures the real bottleneck, and lengthens the time before any one item is actually done. A limit forces that cost into the open
— a full column stalls visibly, rather than silently accumulating started-but-unfinished work behind it.

Because a WIP limit is something imposed rather than measured directly, its value shows up downstream: shorter mean lead time, less
variability in that lead time, flow that keeps increasing rather than stalling, and obstacles that surface early enough to be acted on.

## How to apply

Make the invisible work visible first: a storyboard with a column per workflow stage is what a WIP limit is applied to, and without that
board there is nothing concrete to cap. Give each column an explicit limit — how many items may sit in it at once — set from the real
capacity of the people who work it, not from an aspirational or round number. When a stage's limit is reached, stop starting new work there
and instead work on unblocking what is already in flight.

Within this platform, the pull discipline this capability enforces is the general rule ([ADR-PULL](../process/pull-work.md#rule-adr-pull4)):
work is drawn into a stage only when it has capacity to finish it, and limiting work in progress is what turns that pull into a mechanism
rather than a slogan. The economic case for the cap follows Little's Law ([ADR-QUEUE](../process/queues-cost-money.md#rule-adr-queue2)) —
with throughput roughly fixed in the short run, cutting work in progress is what lowers lead time. And the storyboard itself depends on the
work being observed and rendered rather than tracked from memory ([ADR-OBSERVE](../process/observe-work.md#rule-adr-observe1)).

## Common pitfalls

- **Limiting a stage without visualizing the whole stream.** Capping one column while the rest of the value stream stays invisible leads
  teams to address whichever problem is easiest to see rather than the one that is actually constraining flow.
- **Setting the limit too high.** A limit above real capacity never binds — it looks like discipline without changing any behavior, and the
  underlying multitasking continues unchecked.
- **Relaxing the limit when idle time appears.** Idle time is the signal that a process problem needs fixing, not evidence that the limit is
  wrong; raising it back up trades away the signal instead of acting on it.
- **Leaving an easily-met limit unchanged.** A limit the team never comes close to reaching has stopped constraining anything and needs to
  be lowered, or it stops doing the job it was set to do.

## References

[^1]:
    DORA, _Work in process limits_ capability, <https://dora.dev/capabilities/wip-limits/>. Part of the DORA Core Model of capabilities that
    predict software delivery performance.

## Dora explains

WIP limits are one of the levers DORA ties directly to its flow metrics: capping concurrent work is what makes lead time fall and delivery
performance rise, and the capability is strongest exactly where DORA also measures visibility and monitoring.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the batch-size discipline that a WIP limit enforces
  alongside pull.
- [Work visibility in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — the storyboard a WIP limit is
  applied to.
- [Visual management](https://dora.dev/capabilities/visual-management/) — the at-a-glance display DORA finds strengthens the effect of a WIP
  limit.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
