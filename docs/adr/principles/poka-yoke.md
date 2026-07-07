# Principle: Poka-yoke — make mistakes impossible

## Rules: ADR-POKA

### Rule ADR-POKA:1

Prefer structural prevention — make the wrong thing impossible to express; derive behavior from convention (naming, placement, structure) so
there is no separate registration to fall out of sync.

- [Principle](#principle)

### Rule ADR-POKA:2

Where prevention is impossible, detect the error at the earliest moment — authoring time, build time, or the first line of execution — never
at production time and never silently.

- [Principle](#principle)

### Rule ADR-POKA:3

Fail fast — stop the moment a defect is detected and fix it at source; never continue with bad state hoping something downstream compensates
(jidoka).

- [Principle](#principle)

### Rule ADR-POKA:4

Zero ceremony — if the platform can do a step for the author, it should; the ideal workflow is one action with no prerequisites and no
follow-up.

- [Principle](#principle)

### Rule ADR-POKA:5

Evaluate every design against two questions: can the author get this wrong, and does this add ceremony? If either answer is unsatisfying,
the design is not done.

- [How to apply](#how-to-apply)

## Context

Systems that depend on people doing the right thing fail when people do the wrong thing. Documentation, code review, and discipline are not
reliable error prevention mechanisms — they are quality filters applied after the error has already been introduced. The further an error
travels from its point of origin, the more expensive it is to find and fix.

## Principle

Poka-yoke (ポカヨケ) is a manufacturing concept: design the process so that errors cannot happen, or if they do, they are caught at the
point of origin before they propagate.

Applied to software systems, this means:

1. **Structural prevention.** Make the wrong thing impossible to express. If the system derives behavior from convention (naming, placement,
   structure), there is no separate registration or configuration to get out of sync. The correct outcome is the only outcome.

2. **Immediate detection.** Where prevention is not possible, catch the error at the earliest moment — at authoring time (editor rules,
   linters), at build time (static analysis, tests), or at the first line of execution (assertions, precondition checks). Never at
   production time. Never silently.

3. **Fail fast.** When an error does occur, stop immediately. Do not continue with bad state in the hope that something downstream will
   compensate. The cost of a defect is proportional to the distance it travels from its point of origin. An error caught at the point of
   origin is a one-line fix. The same error caught three layers later is an incident. This is the Toyota concept of _jidoka_ — stop the line
   the moment a defect is detected, fix it at the source, and only then resume. Continuing production with a known defect guarantees that
   defective output accumulates downstream.

4. **Zero ceremony.** Every manual step is an opportunity for error. If the platform can do something for the author, the author should not
   have to do it. The ideal workflow has one action with no prerequisites and no follow-up steps.

## Why

- **Errors prevented are cheaper than errors detected.** A structural constraint costs nothing at runtime. A code review comment costs a
  round-trip. A production incident costs trust.

- **Conventions enforced mechanically scale.** Documentation-based conventions decay as the team grows. Tooling-enforced conventions hold
  regardless of team size, experience, or turnover.

- **Ceremony drives non-compliance.** Every required step that does not directly serve the author's intent is a step that will be skipped,
  forgotten, or done incorrectly. Reducing ceremony reduces error surface.

## How to apply

When evaluating a design, ask two questions:

1. **Can the author get this wrong?** If a mistake is possible, either prevent it structurally (conventions, derived behavior, constrained
   inputs) or catch it immediately (static analysis, assertions, automated tests).

2. **Does this add ceremony?** If the author has to do something that the platform could do for them, the platform should do it. Every
   manual step removed is an error class eliminated.

If the answer to either question is unsatisfying, the design is not done.

This principle is technology-agnostic. It applies to code, configuration, infrastructure, pipelines, and any other system where humans
author artifacts that machines consume.

## Dora explains

DORA's research identifies code maintainability and platform engineering as drivers of team efficacy and delivery performance. Poka-yoke
prevents defects at their origin through structural prevention and immediate detection, reducing the cost and friction of change.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — structural enforcement of conventions scales beyond
  documentation and code review.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — zero-ceremony platforms eliminate prerequisites and
  follow-up steps, reducing defect introduction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
