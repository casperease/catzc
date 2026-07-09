# ADR: Agile principles — the twelve principles behind the manifesto

## Rules: ADR-AGILEP

### Rule ADR-AGILEP:1

Satisfy the customer through early and continuous delivery of valuable software — the highest priority, and the reason every other principle
exists.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:2

Welcome changing requirements, even late — an agile process turns change into the customer's competitive advantage rather than treating it as
a failure of planning.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:3

Deliver working software frequently — on a cadence of weeks rather than months, preferring the shorter interval.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:4

Business people and developers work together daily throughout the project — collaboration is continuous, not a hand-off at the boundaries.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:5

Build projects around motivated individuals — give them the environment and support they need, and trust them to get the job done.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:6

Favour direct conversation — the most efficient and effective way to convey information to and within a team is face-to-face.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:7

Working software is the primary measure of progress — not documents produced, hours spent, or tasks marked done.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:8

Sustain a constant pace indefinitely — sponsors, developers, and users should be able to maintain the pace without burning out; agile is a
sustainable process, not a sprint to exhaustion.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:9

Attend continuously to technical excellence and good design — quality is what keeps the cost of change low and so enhances agility.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:10

Maximise the work not done — simplicity is essential; the cheapest, most responsive system is the one that does no more than it must.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:11

Let architectures, requirements, and designs emerge from self-organizing teams — the best solutions come from the people doing the work, not
from an authority above them.

- [The twelve principles](#the-twelve-principles)

### Rule ADR-AGILEP:12

Reflect and adjust at regular intervals — the team periodically tunes its own behaviour to become more effective; continuous improvement is
built into the process.

- [The twelve principles](#the-twelve-principles)

## Context

Behind the four values ([ADR-AGILEV](agile-values.md)) the Agile Manifesto ([ADR-AGILE](agile.md)) sets out twelve principles that make the
values operational [^1]. Where a value is a preference, a principle is a working instruction — it says what an agile process actually does.
The twelve are the bridge between the manifesto's short comparative statements and the concrete process rules elsewhere in this repository
(flow, promotion, small batches, fast feedback), which are specialisations of these principles for this platform.

## The twelve principles

The principles group into a few themes, though the manifesto lists them as a flat set:

- **Deliver value early and often** (principles 1, 3, 7). The purpose is valuable software in the customer's hands; frequent delivery of
  working software, measured by that software rather than by proxies, is how the purpose is served.
- **Embrace change** (principles 2, 10). Late change is welcomed and turned to advantage, and simplicity — maximising the work _not_ done —
  keeps the system cheap to change.
- **Build around people** (principles 4, 5, 6, 11). Motivated individuals, trusted and supported, collaborating daily and face-to-face, and
  self-organizing around the work, produce the best architectures and designs.
- **Sustain and improve** (principles 8, 9, 12). A constant, indefinitely maintainable pace; continuous attention to technical excellence;
  and regular reflection that tunes the team's own behaviour keep the process healthy over the long run.

Each principle is a rule above; the grouping is only a reading aid. Together they define an agile process as one that delivers working
software continuously, absorbs change cheaply, is built around trusted people, and improves itself.

## Why

**The principles operationalise the values.** A value states a preference; a principle says what to do about it. "Responding to change over
following a plan" becomes "welcome changing requirements, even late" and "reflect and adjust at regular intervals" — statements a team can
act on and check itself against.

**They are the source the repository's process rules specialise.** Rules such as small batches, continuous integration, and short feedback
loops are this platform's concrete expression of principles 1, 3, and 12. Holding the twelve as the source keeps those specific rules
anchored to something durable rather than to a framework's current fashion.

**Quality and sustainability are first-class, not afterthoughts.** Principles 8, 9, and 10 make technical excellence, a sustainable pace, and
simplicity part of the definition of agile — not optional extras a team gets to once the features are done. Low change-cost depends on them.

## How to apply

When shaping or judging a process, check it against the twelve: does it deliver working software frequently, welcome late change, keep the
team sustainable, and reflect to improve? A practice that serves one of the principles has a place; a practice that serves none is ceremony
and can be dropped ([ADR-NOWASTE](../principles/reduce-waste.md)). Where a repository process rule elaborates a principle for this platform,
cite the principle it specialises so the lineage stays visible.

## References

[^1]:
    _Principles behind the Agile Manifesto_ (2001), <https://agilemanifesto.org/principles.html>. The twelve principles that accompany and
    elaborate the four values of the [Manifesto for Agile Software Development](https://agilemanifesto.org).

## Dora explains

DORA's technical and management capabilities are, in large part, measurable realisations of these principles — frequent delivery, low
change-cost, team autonomy, and continuous improvement.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the operational form of early, frequent delivery of
  working software.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — welcoming late change is only affordable when releasing is
  routine.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — self-organizing teams that own their work reflect
  principles 5 and 11.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — regular reflection that tunes the team's behaviour is a learning
  culture in practice.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
