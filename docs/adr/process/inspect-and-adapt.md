# ADR: Inspect and adapt — kaizen built into the process

## Rules: ADR-ADAPT

### Rule ADR-ADAPT:1

Improvement is continuous and built into the process, not a periodic event bolted on. The team regularly inspects how it works and adapts it
— kaizen — so getting better is a standing activity ([ADR-AGILEP](agile-principles.md), reflect and adjust).

- [Decision](#decision)

### Rule ADR-ADAPT:2

Adapt from evidence, not opinion. A decision to change the process rests on observed signals — gate results, flow and queue measures,
incidents — read off the real system ([ADR-OBSERVE](observe-work.md)), not on assertion or seniority.

- [Decision](#decision)

### Rule ADR-ADAPT:3

Amplify learning: development is a knowledge-creating process. Capture what is learned in the system itself — a convention, a gate, an ADR —
so the knowledge holds and is not relearned ([ADR-NOWASTE](../principles/reduce-waste.md), the relearning waste).

- [Why](#why)

### Rule ADR-ADAPT:4

Feedback loops run continuously, at commit cadence. Every push recomputes the gates and the flow state
([ADR-PARITY](../automation/devbox-pipeline-parity.md), [ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)), so inspect-and-adapt
operates on every change, not only at a sprint boundary.

- [How to apply](#how-to-apply)

## Context

Kaizen — continuous, incremental improvement — is the Toyota Production System's engine. The stopped line
([ADR-HOLDLINE](holding-the-line.md)) is not just a fix; it is a signal that triggers a small root-cause investigation and a permanent
countermeasure, so the same defect cannot recur [^2]. Improvement is not a project that a team schedules; it is a reflex the system builds
in, one small adjustment at a time, driven by what actually happened.

The Poppendiecks carry this into software as "create knowledge" and "amplify learning" [^1]: development is not manufacturing a known
design, it is discovering the design, so the process must be a learning loop. Agile says the same in its twelfth principle — reflect at
regular intervals and tune accordingly ([ADR-AGILEP](agile-principles.md)). This article states the rule and ties it to the platform's
mechanism: the gates that recompute on every push are a learning loop running at commit cadence.

## Decision

Build improvement into the process as a continuous, evidence-driven loop:

- **Inspect and adapt continuously.** The team routinely examines how it works — where the line stops, where items wait
  ([ADR-QUEUE](queues-cost-money.md)), what the gates catch — and adjusts. This is a standing reflex, not a quarterly initiative.
- **Decide from evidence.** Process changes follow observed signals from the real system ([ADR-OBSERVE](observe-work.md)), not opinion. A
  recurring failure, a lengthening queue, or a flaky gate is data that motivates a specific countermeasure.
- **Amplify learning by capturing it.** When something is learned, it is encoded where it will hold — a convention that makes the mistake
  impossible to express ([ADR-POKA](../principles/poka-yoke.md)), a gate that catches it ([ADR-TEST](../automation/test-automation.md)), or
  an ADR that records the decision — so the next person inherits the knowledge instead of rediscovering it.

## Why

**Improvement decays unless it is built in.** A separate "improvement phase" is the first thing dropped under pressure. Making
inspect-and-adapt continuous — tied to the stopped line and the per-push gates — means it happens by default, exactly when the evidence is
freshest.

**Uncaptured learning is relearned.** Knowledge that lives only in someone's head is lost at every absence and every new joiner
([ADR-NOWASTE](../principles/reduce-waste.md), the relearning waste). Encoding a lesson as a convention, a gate, or an ADR is what turns a
one-time insight into a permanent property of the system.

**The countermeasure, not the fix, is the point.** Fixing a defect restores flow; asking why it was possible and removing that possibility
is what makes the system better. Kaizen is the discipline of always taking the second step, in small increments, from real evidence.

## How to apply

When the line stops or a gate catches something, do not only fix the instance — ask what made it possible and add the countermeasure that
prevents the class, then encode it where it holds ([ADR-POKA](../principles/poka-yoke.md), [ADR-TEST](../automation/test-automation.md)).
Prefer many small adjustments driven by observed signals ([ADR-OBSERVE](observe-work.md)) over occasional large reorganisations. When you
learn something worth keeping, capture it as a convention, a gate, or an ADR so it is not relearned. Treat the per-push gates as the
platform's built-in learning loop and let them run on every change, not only at a milestone.

## References

[^1]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003), principles "Create knowledge" and "Amplify learning" —
    software development is a knowledge-creating process, so the workflow is designed as a feedback loop that learns.

[^2]:
    Taiichi Ohno, _Toyota Production System_ (1988), on kaizen and the "five whys" — a stopped line triggers root-cause analysis and a
    permanent countermeasure, so improvement is continuous and built into daily work.

## Dora explains

DORA finds that a learning culture and deliberate experimentation are among the strongest cultural predictors of delivery performance —
inspect-and-adapt, made continuous, is what those capabilities describe.

- [Learning culture](https://dora.dev/capabilities/learning-culture/) — treating the process as something to inspect and improve is a
  learning culture in practice.
- [Team experimentation](https://dora.dev/capabilities/team-experimentation/) — adapting from evidence means running and learning from small
  changes to how the team works.
- [Customer feedback](https://dora.dev/capabilities/customer-feedback/) — the outermost inspect-and-adapt loop closes on what the customer
  actually experiences.
- [Generative organizational culture](https://dora.dev/capabilities/generative-organizational-culture/) — a blameless, evidence-driven
  response to a stopped line is what lets the loop run at all.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
