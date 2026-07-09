# ADR: Process terms — the foundational vocabulary of flow

## Rules: ADR-LEANTERMS

### Rule ADR-LEANTERMS:1

Every process term in this repository has one canonical meaning, fixed here. The process ADRs use these terms identically; a term used with
a private or shifting meaning is a defect, the same way an undeclared identifier is.

- [The terms](#the-terms)

### Rule ADR-LEANTERMS:2

The constraint (bottleneck) is the single step that sets the throughput of the whole system. Time saved at a non-constraint is not saved by
the system, and time lost at the constraint is lost by the system — so improvement effort goes to the constraint, not to whichever step is
easiest to speed up.

- [The constraint](#the-constraint)

### Rule ADR-LEANTERMS:3

Optimise the whole, not the part. A local optimum that does not lift the system constraint delivers no system gain and often harms the whole
(a faster non-constraint just piles work in front of the constraint). "This step got faster" is not an outcome; "the system got faster" is.

- [The constraint](#the-constraint)

### Rule ADR-LEANTERMS:4

Flow is measured, not felt. Throughput, work-in-progress, and lead time are defined quantities related by Little's Law
([ADR-LEAN](lean.md)); decisions about batch size and work-in-progress rest on those measures, never on "we feel slow".

- [Flow primitives](#flow-primitives)

### Rule ADR-LEANTERMS:5

Work is classified by who acts: an automated step runs to completion with no human action, a manual step requires a person. Human attention
is the scarce constraint and machine time is cheap and falling (Moore's Law, [ADR-LEAN](lean.md)), so the platform's direction of travel is
to convert manual steps into automated ones — spending the cheap resource to protect the dear one.

- [Automated and manual](#automated-and-manual)

## Context

The process ADRs — lean ([ADR-LEAN](lean.md)), pulling work ([ADR-PULLWORK](pull-work.md)), queues ([ADR-QUEUECOST](queues-cost-money.md)),
and the rest — all reason in the same vocabulary: constraint, throughput, lead time, work-in-progress, batch, queue. That reasoning only
holds together if the words mean exactly one thing across every article. When "bottleneck" means the constraint to one author and "the
slowest thing I noticed" to another, a flow argument stops being checkable.

This article is the glossary those articles share. It fixes the primitive terms so the others can build on them without re-defining them,
and it names the two laws — Little's and Moore's — that make the flow claims quantitative, pointing to [ADR-LEAN](lean.md) as the article
that owns and elaborates them. It defines the nouns; the companion articles state the laws and rules that relate them.

## The terms

### Flow primitives

The base measures of how work moves. They are quantities, not moods.

- **Throughput.** The rate at which the system completes units of work — items delivered per unit time. The system-level output measure.
- **Work-in-progress (WIP).** The number of items started but not yet finished — everything currently inside the system, including items
  sitting idle in a queue.
- **Lead time.** The clock time from when an item enters the system to when it is delivered — the customer's wait, counting both work and
  waiting.
- **Cycle time.** The clock time an item spends being actively worked at a step, from start of work to done — a subset of lead time that
  excludes the waiting.
- **Flow time.** Lead time viewed as the quantity Little's Law governs: `flow time = WIP ÷ throughput` ([ADR-LEAN](lean.md)). Cutting
  work-in-progress lowers it arithmetically, with no one working faster.
- **Batch size.** The amount of work moved between steps as a unit. Small batches shorten lead time and expose defects sooner; large batches
  hide both.
- **Queue.** Items waiting between steps, not being worked. Queue time is pure waiting — the largest and most invisible component of lead
  time, and the one the platform attacks first ([ADR-QUEUECOST](queues-cost-money.md)).
- **Value stream.** The end-to-end sequence of steps a change passes through from idea to running in production. "The whole" that gets
  optimised is the value stream, not any one step ([ADR-OBSERVEWIP](observe-work.md)).

### The constraint

Terms from the Theory of Constraints [^1] — the account of why a system has exactly one thing worth improving at a time.

- **Constraint.** The one step whose capacity sets the throughput of the entire system. Every system has one; if it did not, throughput
  would be infinite. The constraint is where improvement pays.
- **Bottleneck.** The same thing named by its symptom — the step where work visibly piles up in front and starves the steps behind. In this
  repository "bottleneck" and "constraint" are the same term; a bottleneck is not merely "a slow step", it is _the_ limiting step.
- **Local optimisation.** Improving a single step in isolation. A local optimum at a non-constraint yields no system gain, and often a
  system loss, because a faster non-constraint only delivers work to the constraint faster.
- **Global optimisation ("optimise the whole").** Improving the system's end-to-end throughput, which means improving the constraint (or
  moving it). Global optimisation is the goal; local optimisation is the common mistake that feels like progress.

### Automated and manual

How a step is classified by the actor it requires.

- **Automated.** A step that runs to completion with no human action once triggered — repeatable, unattended, and identical every time. The
  platform's default and destination for every step it can reach ([ADR-EAC](../principles/everything-as-code.md),
  [ADR-ZERO](../automation/zero-ceremony-poka-yoke.md)).
- **Manual.** A step that requires a person to act. Manual steps are legitimate where human judgement is the point (a review, a release
  decision); they are waste where they are merely un-automated toil.
- **The direction of travel.** Because human attention is the scarce constraint and machine time is cheap and falling (Moore's Law,
  [ADR-LEAN](lean.md)), a manual step that needs no judgement is a candidate for automation — spend compute to drain the human queue, never
  the reverse.

### The named laws

Two laws make the flow claims quantitative. [ADR-LEAN](lean.md) owns and elaborates both; they are listed here so the vocabulary is
complete.

- **Little's Law.** For any stable system, `flow time = WIP ÷ throughput`. The practical consequence is that work-in-progress, not effort,
  is the lever on lead time ([ADR-LEAN](lean.md), applied in [ADR-QUEUECOST](queues-cost-money.md)).
- **Moore's Law.** Compute capacity per unit cost roughly doubles on a regular cadence, so machine time trends toward free while human
  attention stays the scarce constraint — the economic basis for automating and for spending compute to save people's time
  ([ADR-LEAN](lean.md)).

## Why

**A shared vocabulary is a prerequisite for a flow argument.** Constraint, throughput, and lead time are only useful if they mean one thing
everywhere. Fixing them once, here, lets every other process article reason without re-defining its terms and lets a reader check a claim
against a definition rather than a connotation.

**The constraint focuses effort.** Naming the constraint as _the_ limiting step — not "a slow bit" — is what turns "let us go faster" into a
decidable question: which step is the constraint, and does this change lift it? Everything else is local optimisation dressed as progress.

**Definitions keep automation honest.** Pinning "automated" to "no human action, identical every time" stops a hand-run script from being
called automation, and pinning the scarce resource to human attention explains why the platform spends machine time so freely
([ADR-LEAN](lean.md), [ADR-CACHE](../automation/caching.md)).

## How to apply

When a process or flow decision is in question, use these words with these meanings and no others. Before proposing a speed-up, name the
constraint and check the change against it — a change that improves a non-constraint is waste
([ADR-NOWASTE](../principles/reduce-waste.md)). Before calling a step "automated", check it runs with no human action and is identical every
time. When an article needs a term elaborated — Little's Law, cost of delay, pull versus push — cite the ADR that owns it rather than
redefining it here, so the vocabulary stays single-source.

## References

[^1]:
    Eliyahu M. Goldratt and Jeff Cox, _The Goal: A Process of Ongoing Improvement_ (1984). The Theory of Constraints — that a system's
    throughput is set by a single constraint, and that improving a non-constraint yields no system gain — and the five focusing steps for
    finding and lifting it. Little's Law and Moore's Law carry their primary references in [ADR-LEAN](lean.md).

## Dora explains

DORA's delivery metrics are this vocabulary measured: deployment frequency and change lead time are throughput and lead time, and DORA's
finding that small batches drive both is Little's Law reading out on real systems.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — batch size defined here is the lever DORA finds most
  strongly tied to short lead time.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — limiting work-in-progress is Little's Law applied to the flow
  primitives above.
- [Visibility of work in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — you cannot find the constraint
  in a value stream you cannot see.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — the automated/manual distinction made concrete at the
  deployment step.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
