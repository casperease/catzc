# Principle: Reduce waste

## Rules: PDR-NOWASTE

### Rule PDR-NOWASTE-DROPUNNEEDEDSTEPS

For any step, ask "could I deliver the same outcome without this step?" — if yes, the step is waste; eliminate it, or address the structural
constraint that makes it necessary.

- [How to apply](#how-to-apply)

### Rule PDR-NOWASTE-PREFERLEANDEFAULTS

Prefer automation over manual steps, convention over configuration, self-service over approvals, small batches over large, and fast feedback
over deferred validation.

- [How to apply](#how-to-apply)

## Context

Work that does not deliver value to the end result is waste. It consumes time, attention, and capacity without contributing to the outcome.
Waste is often invisible because it is embedded in processes that feel productive — handoffs, reviews, approvals, extra features, rework —
but each of these is a symptom of a system that could be designed better.

## Principle

Identify and eliminate work that does not contribute to the desired outcome.

The categories of waste are the seven wastes of lean, adapted to software: partially done work, extra features, relearning, handoffs, task
switching, delays, and defects ([EDR-LEAN-SEVENWASTES](../external/lean/lean.md#rule-edr-lean-sevenwastes)).

## Why

Waste compounds. A handoff introduces a delay. The delay causes task switching. The task switching causes relearning. The relearning
introduces a defect. The defect requires partially done work to be revisited. Eliminating waste at any point in this chain breaks the
cascade.

The goal is not to optimize individual steps but to remove the steps that should not exist. A faster approval process is still slower than
no approval process. A better handoff template still loses more context than no handoff.

## How to apply

When evaluating a process or design, ask: _could I deliver the same outcome without this step?_ If the answer is yes, the step is waste.
Either eliminate it or understand what structural constraint makes it necessary — then address the constraint.

Prefer automation over manual steps. Prefer convention over configuration. Prefer self-service over approvals. Prefer small batches over
large batches. Prefer fast feedback over deferred validation.

This principle is technology-agnostic. It applies to code, processes, organizational structures, and any system where human effort is a
finite resource.
