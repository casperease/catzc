# Process: Inspect and adapt — kaizen built into the process

## Rules: WDR-KAIZEN

### Rule WDR-KAIZEN-CONTINUOUSIMPROVEMENT

Improvement is continuous and built into the process, not a periodic event bolted on. The team regularly inspects how it works and adapts it
— kaizen — so getting better is a standing activity ([EDR-AGILEPRINCIPLES](../external/agile/agile-principles.md), reflect and adjust).

- [Decision](#decision)

### Rule WDR-KAIZEN-ADAPTFROMEVIDENCE

Adapt from evidence, not opinion. A decision to change the process rests on observed signals — gate results, flow and queue measures,
incidents — read off the real system ([WDR-OBSERVEWIP](observe-work.md)), not on assertion or seniority.

- [Decision](#decision)

### Rule WDR-KAIZEN-AMPLIFYLEARNING

Amplify learning: development is a knowledge-creating process. Capture what is learned in the system itself — a convention, a gate, a
decision record — so the knowledge holds and is not relearned ([PDR-NOWASTE](../principles/reduce-waste.md), the relearning waste).

- [Why](#why)

### Rule WDR-KAIZEN-COMMITCADENCEFEEDBACK

Feedback loops run continuously, at commit cadence. Every push recomputes the gates and the flow state, so inspect-and-adapt operates on
every change, not only at a sprint boundary.

- [How to apply](#how-to-apply)

### Rule WDR-KAIZEN-AGILEFROMMANIFESTO

Agile in this repository means the Agile Manifesto's four values and twelve principles ([EDR-AGILE](../external/agile/agile.md)), nothing
else. Agility is the ability to respond to change, proven by outcomes (working software delivered frequently, direction changed cheaply),
never by conformance to a process; a framework is one implementation of the values and yields to them on conflict.

- [Agile and lean grounding](#agile-and-lean-grounding)

### Rule WDR-KAIZEN-LEANISPOPPENDIECK

Lean in this repository means the Toyota Production System as the Poppendiecks map it to software ([EDR-LEAN](../external/lean/lean.md)):
just-in-time flow and jidoka, the seven principles and the seven wastes. Lean and agile are one responsiveness seen from two directions, and
a rule that serves neither is ceremony.

- [Agile and lean grounding](#agile-and-lean-grounding)

## Context

Kaizen — continuous, incremental improvement — is the engine of the Toyota Production System ([EDR-LEAN][r1]). The stopped line
([WDR-ANDON](holding-the-line.md)) is not just a fix; it is a signal that triggers a small root-cause investigation and a permanent
countermeasure, so the same defect cannot recur [^2]. Improvement is not a project that a team schedules; it is a reflex the system builds
in, one small adjustment at a time, driven by what actually happened.

The Poppendiecks carry this into software as "create knowledge" and "amplify learning" [^1]: development is not manufacturing a known
design, it is discovering the design, so the process must be a learning loop. Agile says the same in its twelfth principle — reflect at
regular intervals and tune accordingly ([EDR-AGILEPRINCIPLES][r2]). This article states the rule and ties it to the platform's mechanism:
the gates that recompute on every push are a learning loop running at commit cadence.

## Decision

Build improvement into the process as a continuous, evidence-driven loop:

- **Inspect and adapt continuously.** The team routinely examines how it works — where the line stops, where items wait
  ([WDR-QUEUECOST](queues-cost-money.md)), what the gates catch — and adjusts. This is a standing reflex, not a quarterly initiative.
- **Decide from evidence.** Process changes follow observed signals from the real system ([WDR-OBSERVEWIP](observe-work.md)), not opinion. A
  recurring failure, a lengthening queue, or a flaky quality gate is data that motivates a specific countermeasure. The consuming teams are
  the platform's customers, so a change to the platform rests on the signals observed in their use of it.
- **Amplify learning by capturing it.** When something is learned, it is encoded where it will hold — a convention that makes the mistake
  impossible to express ([PDR-POKAYOKE](../principles/poka-yoke.md)), a quality gate that catches it, or a decision record that names the
  decision — so the next person inherits the knowledge instead of rediscovering it.

## Why

**Improvement decays unless it is built in.** A separate "improvement phase" is the first thing dropped under pressure. Making
inspect-and-adapt continuous — tied to the stopped line and the per-push gates — means it happens by default, exactly when the evidence is
freshest.

**Uncaptured learning is relearned.** Knowledge that lives only in someone's head is lost at every absence and every new joiner
([PDR-NOWASTE](../principles/reduce-waste.md), the relearning waste). Encoding a lesson as a convention, a gate, or a decision record is
what turns a one-time insight into a permanent property of the system.

**The countermeasure, not the fix, is the point.** Fixing a defect restores flow; asking why it was possible and removing that possibility
is what makes the system better. Kaizen is the discipline of always taking the second step, in small increments, from real evidence.

## How to apply

When the line stops or a gate catches something, do not only fix the instance — add the countermeasure that prevents the class. Prefer many
small adjustments driven by observed signals over occasional large reorganisations, and treat the per-push gates, the same on the devbox and
in the pipeline, as the platform's built-in learning loop.

## Agile and lean grounding

A shared definition is a prerequisite for reasoning: without one, "more agile" or "leaner" is taste, and no design argument settles.
Anchored to the manifesto and to the Toyota Production System, each becomes checkable. Does this change lower the cost of responding to
change, and which value or principle does it serve? Does it shorten flow, build quality in, or remove waste
([PDR-NOWASTE](../principles/reduce-waste.md))?

When a practice contradicts a value, the practice changes, not the value. A practice that serves none of the values, principles, or lean
principles is ceremony and is dropped. Each lean principle has its home in a rule here: build quality in
([WDR-BUILTIN](build-quality-in.md)), create knowledge ([WDR-KAIZEN](inspect-and-adapt.md)), defer commitment and deliver fast
([WDR-PULLWORK](pull-work.md), [WDR-QUEUECOST](queues-cost-money.md)), optimise the whole ([WDR-OBSERVEWIP](observe-work.md)), and stop the
line ([WDR-ANDON](holding-the-line.md)). A repository rule that specialises a principle cites it so the lineage stays visible.

## References

[^1]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003), principles "Create knowledge" and "Amplify learning" —
    software development is a knowledge-creating process, so the workflow is designed as a feedback loop that learns.

[^2]:
    Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988), on kaizen and the "five whys" — a stopped line triggers
    root-cause analysis and a permanent countermeasure, so improvement is continuous and built into daily work.

[r1]: ../external/lean/lean.md
[r2]: ../external/agile/agile-principles.md
