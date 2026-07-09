# ADR: Observe the work — make it visible, and go and see

## Rules: ADR-OBSERVEWIP

### Rule ADR-OBSERVEWIP:1

Make the state of the work visible at all times. Where each commit sits in the flow — and what state it has reached — is rendered, not
inferred from memory or a status meeting ([ADR-VISUAL](../design/visual-design.md), [ADR-LIFE](../design/commit-lifecycle.md)).

- [Decision](#decision)

### Rule ADR-OBSERVEWIP:2

Go and see the real artifact. Decisions rest on the actual running software and real signals — genchi genbutsu, "go and see for yourself" —
not on proxies like tasks-marked-done or hours spent; working software is the measure of progress ([ADR-PRINCIPLES](agile-principles.md)).

- [Decision](#decision)

### Rule ADR-OBSERVEWIP:3

Surface problems loudly, at their origin. Console output is a first-class concern that reports outcomes and announces work before it blocks
([ADR-CONSOLE](../automation/powershell/console-output-matters.md)); a problem is made visible where it happens, never buried or deferred.

- [How to apply](#how-to-apply)

### Rule ADR-OBSERVEWIP:4

Observe the whole value stream, not one local step. Optimise concept-to-cash end to end and guard against a local optimum that speeds one
station while starving the whole (optimise the whole; [ADR-LEAN](lean.md)).

- [Why](#why)

## Context

Toyota managers are taught genchi genbutsu — go to the actual place and see the actual thing. A report about the floor is a lossy
compression of the floor; a defect described second-hand is a defect you cannot fix. The same instinct drives the visual factory: the state
of every station is made visible at a glance, so an abnormality announces itself instead of waiting to be discovered [^1].

Software delivery is harder to see than a factory floor — the work is invisible by default, buried in branches, queues, and machine state.
Lean's response is to make it visible deliberately. This repository does so in two places: the value-chain diagrams render every commit's
delivery state ([ADR-VISUAL](../design/visual-design.md)), and console output is treated as a first-class channel that reports what actually
happened ([ADR-CONSOLE](../automation/powershell/console-output-matters.md)). This article states the underlying rule those specialise.

## Decision

Treat visibility of the work as a requirement, not a nicety, and treat direct observation as the basis for decisions:

- **Render the flow.** The position and state of every commit is shown by construction, not reconstructed on demand
  ([ADR-VISUAL](../design/visual-design.md)): position is time, colour is the furthest state reached, and a glance decodes where a change
  is. The value stream is the visual factory.
- **Go and see.** Judge progress from the real running artifact and real signals — a green gate, a deployed environment, a monitored metric
  — not from a proxy. "Done" means the software does the thing, observed, not a task ticked ([ADR-PRINCIPLES](agile-principles.md), working
  software is the measure).
- **Announce, don't bury.** When something happens that a human needs to know — a slow step about to block, a problem detected — it is said
  plainly on the console at the moment it happens ([ADR-CONSOLE](../automation/powershell/console-output-matters.md)), not swallowed and
  discovered later.

## Why

**You cannot improve what you cannot see.** Inspect-and-adapt ([ADR-KAIZEN](inspect-and-adapt.md)) needs evidence, and evidence needs
observation. A flow whose state is invisible can only be managed by anecdote; a flow that is rendered can be managed by fact.

**Proxies lie; artifacts do not.** Tasks-marked-done, hours logged, and percent-complete drift away from reality the moment they are used to
steer. The running software, the gate result, and the monitored metric are the ground truth genchi genbutsu insists on
([ADR-PRINCIPLES](agile-principles.md)).

**Local visibility hides global stalls.** A dashboard that shows one busy station green can conceal a value stream choking on a queue two
stations upstream. Observing the whole — end-to-end lead time, where items wait — is what keeps optimisation honest [^2]
([ADR-QUEUECOST](queues-cost-money.md)).

## How to apply

Prefer making the work visible over reporting on it. When adding a step, ask what state it produces and how that state will be seen — a
commit colour ([ADR-VISUAL](../design/visual-design.md)), a console line
([ADR-CONSOLE](../automation/powershell/console-output-matters.md)), a monitored signal — and make that the default, not an opt-in. Judge
whether work is done by observing the real artifact, not by a proxy. When you reason about speed, look at the whole value stream and find
where items wait, rather than at how fast any single station runs.

## References

[^1]:
    Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988), on genchi genbutsu ("go and see") and the visual
    workplace — abnormalities are made to announce themselves at the place they occur.

[^2]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003), "See the whole" — optimise the end-to-end value stream
    rather than local measures, which requires making the whole stream visible.

## Dora explains

DORA finds that visibility of work across the value stream, visual management, and monitoring are capabilities that distinguish
high-performing teams — seeing the work is a precondition for improving its flow.

- [Visibility of work in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — a rendered end-to-end flow is
  exactly this capability.
- [Visual management](https://dora.dev/capabilities/visual-management/) — making state visible at a glance is the visual factory applied to
  delivery.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — going to see the real running artifact
  depends on real signals from it.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
