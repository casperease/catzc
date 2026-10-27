# Process: Build quality in — you cannot inspect it in at the end

## Rules: WDR-BUILTIN

### Rule WDR-BUILTIN-QUALITYBUILTIN

Quality is built into the process, not inspected in afterwards. Every step produces already-correct output; there is no separate stage that
blesses defective work as finished. The definition of done includes green quality gates, not a later sign-off.

- [Decision](#decision)

### Rule WDR-BUILTIN-PREVENTORDETECT

Prevent structurally where possible; otherwise detect immediately. A defect is either made impossible to express, or caught at authoring,
build, or the first line of execution — never at production time and never silently ([PDR-POKAYOKE](../principles/poka-yoke.md)).

- [Decision](#decision)

### Rule WDR-BUILTIN-GATESAREPARTOFWORK

Tests and quality gates are part of producing the work, not a checkpoint bolted on after it. They run identically on the devbox and in the
pipeline and must agree, so quality is proven where the work is done.

- [How to apply](#how-to-apply)

### Rule WDR-BUILTIN-QUALITYFURTHESTLEFT

Concentrate quality effort at the furthest-left point, because a defect's cost grows with the distance it travels from its origin
([PDR-NOWASTE](../principles/reduce-waste.md), the defects waste). A fault an assertion catches at entry is free; the same fault in
production is an incident. Stopping the line ([WDR-ANDON](holding-the-line.md)) is therefore cheap and expected, not a failure event: the
best stop is the earliest and smallest — a gate on the devbox — and the worst is a stop discovered in production. Optimise for stopping
furthest left, not for never stopping.

- [Why](#why)

## Context

Traditional quality assurance is an inspection step: build the thing, then hand it to a separate stage that looks for defects and sends the
bad ones back. W. Edwards Deming's objection, adopted by the Toyota Production System ([EDR-LEAN][r1]), is that inspection at the end is
both too late and too weak — it finds defects after the cost of making them is already sunk, and it cannot find them all. Toyota's answer is
jidoka: build quality into each step so the output is correct by construction, and stop the line when it is not [^2].

The Poppendiecks carry this into software as "build integrity in" [^1]. It is the natural partner of poka-yoke
([PDR-POKAYOKE](../principles/poka-yoke.md)): where poka-yoke is the mechanism (prevent, else detect early), building quality in is the
policy that there is no other mechanism — no end-of-line QA stage to fall back on.

## Decision

Quality is a property of how the work is produced, not a gate at the end of it. This has three consequences the platform enforces:

- **No inspection stage.** There is no step whose job is to find defects in finished work. The gates run _as_ the work is produced, and a
  change is not "done pending QA" — it is done when its quality gates are green.
- **Prevent, then detect.** The first choice is to make the defect impossible to express — derive behaviour from convention so there is
  nothing to get wrong ([PDR-POKAYOKE](../principles/poka-yoke.md), [PDR-REDUCEVAR](../principles/reduce-variability.md)). Where that is
  impossible, catch it at the earliest moment: an editor rule, a static-analysis quality gate, an assertion at the first line of execution.
- **Same gates everywhere.** The quality checks are the same on the devbox and in the pipeline and must agree, so "it passed on my machine"
  and "it passed in CI" are the same statement.

## Why

**Inspection is too late and too weak.** By the time a separate QA stage looks at the work, the cost of the defect is already spent, and
sampling never catches everything. Building quality in removes the defect at the point where removing it is cheapest — before it exists, or
at its origin.

**A fallback QA stage erodes the process that feeds it.** If there is an inspection net at the end, every upstream step is quietly permitted
to be a little careless. Removing the net is what forces each step to be correct by construction — the same reason the line stops rather
than routing defects to a rework area ([WDR-ANDON](holding-the-line.md)).

## How to apply

When adding a capability, ask first whether the defect it could introduce can be made impossible — a convention, a type, a constrained input
([PDR-POKAYOKE](../principles/poka-yoke.md)). If not, add the check that catches it earliest and wire it into the quality gates that run on
both the devbox and the pipeline. Never propose a "review will catch it" or "QA will find it" step as the quality mechanism — those are
inspection, and inspection is what this rule replaces.

## References

[^1]:
    Mary and Tom Poppendieck, _Lean Software Development: An Agile Toolkit_ (2003), principle "Build integrity in". Perceived and conceptual
    integrity come from building quality into the process, supported by test-driven development and continuous integration rather than
    end-of-line inspection.

[^2]:
    Taiichi Ohno, _Toyota Production System: Beyond Large-Scale Production_ (1988), on jidoka; and W. Edwards Deming, _Out of the Crisis_
    (1986), "Cease dependence on inspection to achieve quality" — the origin of building quality in rather than inspecting it in.

[r1]: ../external/lean/lean.md
