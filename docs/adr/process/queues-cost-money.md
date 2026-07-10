# ADR: The money is lost in the queues — Little's Law and the cost of delay

## Rules: ADR-PROC-QUEUECOST

### Rule ADR-PROC-QUEUECOST:1

The dominant cost in delivery is queue time, not work time. An item spends most of its lead time waiting between steps, so the largest lever
on speed is shortening queues, not speeding up the work — the money is lost in the queues.

- [Decision](#decision)

### Rule ADR-PROC-QUEUECOST:2

Little's Law governs flow: average flow time equals average work-in-progress divided by average throughput. Throughput is near-fixed in the
short run, so lead time falls by cutting work-in-progress ([ADR-PROC-PULLWORK](pull-work.md)), not by exhortation to hurry.

- [The arithmetic](#the-arithmetic)

### Rule ADR-PROC-QUEUECOST:3

Delay has a measurable price. Cost of delay turns queue time into money and sets priority: work the highest cost-of-delay item first, and
treat a long feedback queue as an ongoing expense rather than a neutral wait.

- [The arithmetic](#the-arithmetic)

### Rule ADR-PROC-QUEUECOST:4

Machine time is cheap and follows Moore's law; human attention is the constraint. So spend compute to drain the human queue — parallel
gates, eager caches ([ADR-AUTO-CACHE](../automation/caching.md)), ephemeral environments, rebuild-don't-wait. A minute of CPU is cheaper
than a minute of a person blocked.

- [Decision](#decision)

### Rule ADR-PROC-QUEUECOST:5

Batch size drives queue size. Large batches inflate queues and their variability; small batches ([ADR-PROC-PULLWORK](pull-work.md)) keep
both the queue and its cost of delay low. Reduce batch size before adding capacity.

- [How to apply](#how-to-apply)

## Context

Ask where the time goes in delivering a change and the intuitive answer is "the work" — writing the code, running the build, doing the
review. Measure it and the answer is almost always "the waiting": the change sits in a queue before review, before the build agent frees up,
before someone approves, before the environment is ready. Donald Reinertsen's central finding in product development flow is that the
economic cost of this waiting dwarfs the cost of the work itself, and that most organisations do not even measure it [^1]. The money is lost
in the queues.

Lean has said this since Ohno: the visible waste is the waiting between steps, not the steps. This article makes the claim quantitative for
CI/CD, using the two laws from [ADR-PROC-LEAN](lean.md) — Little's Law for how queues set lead time, and Moore's Law for why the cheapest
way to drain a queue is usually to spend machine time.

## Decision

Manage the queues, not just the work. Concretely:

- **Attack wait time first.** When lead time is too long, find where items wait — before review, before an agent, before an environment —
  and shorten that queue before optimising any step's runtime. Delays are the largest waste
  ([ADR-PRIN-NOWASTE](../principles/reduce-waste.md)) and the hardest to see because they look like idle time, not cost.
- **Lower work-in-progress to lower lead time.** By Little's Law, with throughput fixed, cutting the number of items in flight cuts lead
  time directly ([ADR-PROC-PULLWORK](pull-work.md)). This needs no one to work faster.
- **Spend the cheap resource to save the dear one.** Human wait is expensive and machine time is cheap and getting cheaper (Moore's law), so
  run gates in parallel, cache results so nothing is recomputed ([ADR-AUTO-CACHE](../automation/caching.md)), and stand up throwaway
  environments rather than queueing for a shared one. Buying down a human queue with compute is almost always the right trade.

## The arithmetic

**Little's Law** [^2]. For any stable system, average flow time equals average work-in-progress divided by average throughput
(`flow time = WIP ÷ throughput`). Read it as a lever: throughput (how many changes the pipeline completes per unit time) is roughly fixed by
the system's design in the short run, so the term you can move is work-in-progress. Halving the number of changes in flight halves their
average lead time — arithmetic, not effort. This is the formal reason [ADR-PROC-PULLWORK](pull-work.md) caps work-in-progress.

**Cost of delay** [^1]. Every item has a cost of delay — the value lost per unit time it is late. Multiplying queue time by cost of delay
turns a wait into a number, which does two things: it sets priority (work the highest cost-of-delay item first, not the biggest or the
oldest), and it justifies spending money to remove the wait. A feedback queue that delays every change by an hour is not free; it is that
hour times the cost of delay of everything in it, every day.

**Moore's Law as an economic input** [^3]. Because compute grows cheap relative to human time, the price of draining a queue with machine
time keeps falling. Parallelism, caching, and ephemeral infrastructure are the levers; the devbox/pipeline parity that lets the same gates
run anywhere ([ADR-AUTO-PARITY](../automation/devbox-pipeline-parity.md)) is what lets a developer pay a few seconds of local CPU to avoid a
push-and-wait round trip through the pipeline queue.

## Why

**Optimising the work while ignoring the queue is a rounding error.** If an item waits ninety percent of its lead time, halving the ten
percent spent working improves lead time by five percent, while halving the queue improves it by forty-five. The leverage is entirely in the
wait.

**A queue whose cost is never measured gets tolerated.** A wait that no one has put a number on looks like harmless idle time, so it
survives. Attaching a cost of delay to it makes the expense visible and the case for removing it obvious — the same reason lean insists on
making the work visible ([ADR-PROC-OBSERVEWIP](observe-work.md)).

**Compute is the cheapest lever left.** Most other ways to shorten a queue cost human effort or organisational change. Spending machine time
— which halves in price on a predictable cadence — is the one lever that keeps getting cheaper, so it should usually be reached for first.

## How to apply

When something feels slow, measure where the change waits before optimising how fast any step runs, and shorten the largest queue first.
Keep work-in-progress low ([ADR-PROC-PULLWORK](pull-work.md)) — it is the Little's-Law lever on lead time. Reduce batch size before adding
capacity, because large batches are what inflate the queue in the first place. And prefer spending compute over spending human wait:
parallelise gates, cache so nothing is recomputed across a session ([ADR-AUTO-CACHE](../automation/caching.md)), and use ephemeral
environments rather than queueing for shared ones.

## References

[^1]:
    Donald G. Reinertsen, _The Principles of Product Development Flow: Second Generation Lean Product Development_ (2009). The economic case
    that queues, not the work, are the dominant cost in development, that cost of delay is the missing currency, and that most teams fail to
    measure either.

[^2]:
    John D. C. Little, "A Proof for the Queuing Formula: L = λW", _Operations Research_ 9 (1961). `L = λW` — items in system equals arrival
    rate times wait — rearranges to flow time = work-in-progress ÷ throughput and holds for any stable system.

[^3]:
    Gordon E. Moore, "Cramming More Components onto Integrated Circuits", _Electronics_ (1965). Used here for its economic consequence:
    compute grows cheap relative to human time, so trading machine time for human wait is a trade that keeps improving.
