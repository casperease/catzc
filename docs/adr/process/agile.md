# ADR: Agile — defined by the manifesto, measured by responsiveness

## Rules: ADR-AGILE

### Rule ADR-AGILE:1

Agile is defined by the Agile Manifesto — its four values ([ADR-AGILEV](agile-values.md)) and twelve principles
([ADR-AGILEP](agile-principles.md)) — not by any framework, ceremony, role, or tool.

- [Decision](#decision)

### Rule ADR-AGILE:2

Agility is the ability to respond to change: to alter direction quickly and cheaply as understanding grows. A process that makes change
expensive is not agile, whatever it is called.

- [Decision](#decision)

### Rule ADR-AGILE:3

The values and principles are authoritative; a framework (Scrum, Kanban, XP) is one implementation of them and yields to them on conflict —
when a practice contradicts a value, the value governs and the practice changes.

- [How to apply](#how-to-apply)

### Rule ADR-AGILE:4

Agility is proven by outcomes — working software delivered frequently and direction changed cheaply — never by conformance to a process. A
team that follows every ceremony yet cannot absorb change is not agile.

- [Why](#why)

## Context

"Agile" is among the most overloaded words in software. It is used to name a manifesto, a family of frameworks, a certification industry, and
a management style — often at cross purposes. When "agile" means a stand-up meeting to one person and a two-year transformation programme to
another, the word carries no shared meaning and cannot ground a decision.

This repository needs one fixed definition so that every later process rule — flow, promotion, small batches, fast feedback — rests on the
same foundation and so that a claim of "this is more agile" can be checked against something concrete rather than asserted.

## Decision

Agile is defined by the [Agile Manifesto](https://agilemanifesto.org) [^1]: its four values and twelve principles, and nothing else. The
values and principles are the definition; everything commonly labelled "agile" — Scrum, Kanban, Extreme Programming, SAFe — is an
_implementation_ that may or may not realise them.

The one-sentence reduction is this: **agility is the ability to respond to change.** The manifesto's authors set out to find better ways of
developing software, and every value and principle serves the capacity to move in a new direction quickly and cheaply as the team learns what
the customer actually needs. A process is agile to the exact degree that it keeps the cost of change low; a process that makes change
expensive — heavy sign-off, large batches, long feedback loops — is not agile no matter how many of its ceremonies are observed.

Because the definition is the values and principles, they sit above any framework. When a chosen practice conflicts with a value, the value
wins and the practice is what changes. A framework is a starting arrangement, not the authority.

## Why

**A shared definition is a prerequisite for reasoning.** Without one, "more agile" is a matter of taste and no design argument can be
settled. Anchoring the word to the manifesto turns it into something checkable: does this change lower the cost of responding to change, or
raise it?

**Responsiveness, not ritual, is the point.** The manifesto values working software and responding to change over process and plans. A team
can perform every ceremony and still be unable to change course — that is process conformance, not agility. Measuring by outcomes keeps the
attention on the capability the manifesto actually describes.

**Frameworks drift; the definition does not.** Practices are adapted, misremembered, and sold. Holding the values and principles as the
authority means an adaptation can always be tested against the source rather than against whatever the framework has become.

## How to apply

When a process decision is in question, do not ask "does the framework say to do this?" — ask "does this lower the cost of responding to
change, and which value or principle does it serve?" If a practice serves none of them, it is ceremony and can be dropped
([ADR-NOWASTE](../principles/reduce-waste.md)). If a practice contradicts a value, change the practice, not the value.

Treat the values ([ADR-AGILEV](agile-values.md)) and principles ([ADR-AGILEP](agile-principles.md)) as the two companion articles that carry
the detail; this article fixes only what agile _is_ and how the word is used across the rest of the repository's process rules.

## References

[^1]:
    Kent Beck et al., _Manifesto for Agile Software Development_ (2001), <https://agilemanifesto.org>. Seventeen practitioners meeting at
    Snowbird, Utah, set out to uncover better ways of developing software; the result is four values and twelve supporting principles. The
    manifesto is deliberately short and comparative — it prizes one thing over another rather than rejecting either side.

## Dora explains

DORA's research frames delivery performance as the capacity to make changes safely and quickly — the same responsiveness the manifesto
describes. Agile as defined here is the cultural and process foundation the technical capabilities below make measurable.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches keep the cost of change low, which is
  what agility means in practice.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the ability to release change on demand is responsiveness made
  concrete.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — responding to change depends on a team that learns and adjusts rather
  than conforms.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
