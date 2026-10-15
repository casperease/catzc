---
catzc:
  derived:
    path: docs/adr/research/learning-culture.md
    kind: adr
    body_sha: acfd23004c4f
    defines:
      - ADR-DORA-LEARNING#1
      - ADR-DORA-LEARNING#2
      - ADR-DORA-LEARNING#3
      - ADR-DORA-LEARNING#4
      - ADR-DORA-LEARNING#5
    adrs: []
    links:
      - docs/adr/principles/reduce-waste.md
      - docs/adr/process/holding-the-line.md
      - docs/adr/process/inspect-and-adapt.md
      - docs/references/dora/capabilities.md#climate-for-learning
      - docs/references/dora/capabilities.md#generative-organizational-culture
      - docs/references/dora/capabilities.md#job-satisfaction
      - docs/references/dora/capabilities.md#learning-culture
      - docs/references/dora/capabilities.md#team-experimentation
      - docs/references/dora/core-model.md#climate-for-learning
      - docs/references/dora/core-model.md#organizational-performance
      - docs/references/dora/index.md
      - docs/references/dora/metrics.md#change-fail-rate
      - docs/references/dora/metrics.md#change-lead-time
      - docs/references/dora/metrics.md#deployment-frequency
      - docs/references/dora/metrics.md#failed-deployment-recovery-time
      - "https://dora.dev/capabilities/learning-culture/"
---

# ADR: DORA — Learning culture

## Rules: ADR-DORA-LEARNING

### Rule ADR-DORA-LEARNING:1

Treat learning as a strategic investment necessary for growth, not a grudging burden and not something avoided — the organization's stance
on learning is a deliberate choice, not an accident of how much slack happens to exist.

- [Summary](#summary)

### Rule ADR-DORA-LEARNING:2

Fund learning concretely: keep a training budget, protect time for informal exploration, and cover the cost of conferences and
certifications, so the commitment is a resourced practice rather than a stated value with nothing behind it.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-LEARNING:3

Make it safe to fail. Treat failures as data for improvement — blameless post-mortems, not blame — so people keep taking the reasonable
risks that learning and experimentation require.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-LEARNING:4

Keep knowledge-sharing on a standing cadence — recurring forums such as lightning talks, brown-bag sessions, or lunch-and-learns, and a
share-back expectation after conferences or training — rather than leaving it to depend on individual initiative.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-LEARNING:5

Measure the climate for learning directly, by asking people whether their organization treats learning as an investment, rather than
inferring it from a training budget line that nobody actually uses.

- [Common pitfalls](#common-pitfalls)

## Context

Learning culture sits among DORA's cultural capabilities, alongside generative organizational culture, team experimentation, job
satisfaction, transformational leadership, and well-being — the capabilities that describe the human and organizational climate delivery
work happens inside, rather than a specific technical practice.

DORA defines the capability by the question it asks of an organization: does it treat learning as an investment necessary for growth, as a
necessary burden undertaken only grudgingly, or as something avoided entirely?[^1] Research from DORA and from other fields, including
accounting, finds that a climate for learning is a significant predictor of software delivery performance and of organizational performance
more broadly.

## Summary

A learning culture is an organizational climate that treats learning as strategic — an investment, not an expense — rather than as an
obligation to be minimized. DORA's research associates this climate with increased deployment frequency, reduced lead time for changes,
reduced time to restore service, reduced change failure rate, and a strong team culture.

The climate is measured directly, by survey, rather than inferred from spend. The reference instrument asks how strongly people agree with
three statements about their organization: learning is the key to improvement; once the organization quits learning it endangers its future;
and learning is viewed as an investment, not an expense.[^2]

## Why it matters

The mechanism runs through psychological safety and knowledge retention. If failure is punished, people stop trying new things, and the
experimentation that learning depends on stops with it — DORA's guidance is explicit that making it safe to fail, through blameless
post-mortems and treating failures as improvement opportunities, is what keeps people willing to take reasonable risks. Where that safety is
absent, the organization sees fewer of the small experiments and honest post-incident findings that feed the rest of its improvement loop.

Learning that stays in one person's head is also learning the organization has not actually captured — it is lost the moment that person is
absent or leaves, and every new joiner relearns it from scratch. A climate that funds and schedules sharing turns individual insight into an
organizational asset instead of a personal one, which is why DORA's research finds this climate predictive of delivery performance and, in
other fields such as accounting, of organizational performance generally.

## How to apply

Catzc treats capturing what is learned as a first-class step in its own improvement loop rather than an optional afterthought
([ADR-PROC-KAIZEN](../process/inspect-and-adapt.md)): when something is learned, it is encoded as a convention, a gate, or an ADR so the
next person inherits the knowledge instead of rediscovering it, which is the direct countermeasure to relearning
([ADR-PRIN-NOWASTE](../principles/reduce-waste.md), the relearning waste). The platform's stopped-line discipline treats a caught defect as
a root-cause investigation rather than a blame event, and warns explicitly that punishing a stop teaches people to route around it
([ADR-PROC-ANDON](../process/holding-the-line.md)) — the same safety-to-fail stance DORA describes for post-mortems, applied to the gate
that catches the defect in the first place.

## Common pitfalls

- **Treating learning as a burden or skipping it.** An organization that undertakes learning grudgingly, or avoids it, gets none of the
  climate benefit — the stance on learning has to be a genuine investment, not a checkbox.
- **Punishing failure.** If mistakes bring blame instead of a blameless post-mortem, people stop taking the reasonable risks that
  experimentation and learning both require, and the organization loses its main source of honest signal.
- **Leaving sharing to individual initiative.** Knowledge-sharing that depends on someone volunteering, with no regular forum and no
  expectation that conference or training attendees report back, decays into relearning the moment that person is unavailable.
- **Measuring the budget instead of the climate.** A training line item that exists on paper but is not used, or that nobody feels
  encouraged to draw on, is not the same as a climate for learning — the honest measure is whether people agree learning is valued, not
  whether a line exists.

## References

[^1]:
    DORA, _Learning culture_ capability, <https://dora.dev/capabilities/learning-culture/>. A climate-for-learning capability that is not
    part of the DORA Core Model.

[^2]:
    DORA cites _An empirical analysis of the levers of control framework_ as the source of the three-statement survey instrument used to
    measure an organization's climate for learning.

## Dora explains

DORA places learning culture in its climate-for-learning category, but not in the Core Model, whose climate-for-learning group carries the
same name. It ties an organization that treats learning as an investment rather than a cost to better software delivery performance, a
strong team culture, and organizational performance.

- **Catalogue entry:** [Learning culture](../../references/dora/capabilities.md#learning-culture)
- **Category:** [Climate for learning](../../references/dora/capabilities.md#climate-for-learning) — not in the Core Model, although the
  Core Model's [climate for learning](../../references/dora/core-model.md#climate-for-learning) group shares its name.
- **Evidence:** the capability page cites no report year, so the catalogue attributes its findings to no specific publication.
- **Predicts:** software delivery performance — higher [deployment frequency](../../references/dora/metrics.md#deployment-frequency),
  shorter [change lead time](../../references/dora/metrics.md#change-lead-time) and time to restore (the metric
  [failed deployment recovery time](../../references/dora/metrics.md#failed-deployment-recovery-time)), and a lower
  [change fail rate](../../references/dora/metrics.md#change-fail-rate) — together with a strong team culture and
  [organizational performance](../../references/dora/core-model.md#organizational-performance).
- **Related capabilities:**
  - [Team experimentation](../../references/dora/capabilities.md#team-experimentation) — running and learning from small changes is the
    learning culture's climate put into practice.
  - [Generative organizational culture](../../references/dora/capabilities.md#generative-organizational-culture) — the blameless,
    information-rich climate that makes it safe to surface and learn from failure.
  - [Job satisfaction](../../references/dora/capabilities.md#job-satisfaction) — a climate that invests in people's growth is part of what
    makes work satisfying.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
