---
catzc:
  derived:
    path: docs/adr/research/team-experimentation.md
    kind: adr
    body_sha: "2f9ea2451e97"
    defines:
      - ADR-DORA-EXPERIMENT#{1-4}
    links:
      - docs/adr/design/self-service.md
      - docs/adr/design/thin-platforms.md
      - docs/adr/process/agile-values.md
      - docs/references/dora/capabilities.md#climate-for-learning
      - docs/references/dora/capabilities.md#customer-feedback
      - docs/references/dora/capabilities.md#generative-organizational-culture
      - docs/references/dora/capabilities.md#learning-culture
      - docs/references/dora/capabilities.md#team-experimentation
      - docs/references/dora/capabilities.md#transformational-leadership
      - docs/references/dora/core-model.md#organizational-performance
      - docs/references/dora/core-model.md#software-delivery-performance
      - docs/references/dora/index.md
      - docs/references/dora/publications.md#2016-state-of-devops-report
      - docs/references/dora/publications.md#2017-state-of-devops-report
      - "https://dora.dev/capabilities/team-experimentation/"
---

# ADR: DORA — Team experimentation

## Rules: ADR-DORA-EXPERIMENT

### Rule ADR-DORA-EXPERIMENT:1

Teams work on new ideas and test solutions with real users to achieve business outcomes without asking permission from outside the team —
treat that freedom as the capability itself, not a side effect of trust granted for other reasons.

- [Summary](#summary)

### Rule ADR-DORA-EXPERIMENT:2

A story card is a reminder of an ongoing conversation between the customer and the team, not a fixed contract; teams write and change
specifications during development as they learn, rather than executing a specification handed down before work started.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-EXPERIMENT:3

Treat technical staff as the experts on implementation details. Giving specific direction on how the work is done, rather than what outcome
it must reach, removes the judgment the capability depends on.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-EXPERIMENT:4

Provide the information, context, and dedicated time for a team to design and run its own experiments; withholding any of the three
forecloses the capability even where permission to experiment exists in principle.

- [How to apply](#how-to-apply)

## Context

Team experimentation sits among DORA's cultural capabilities, alongside generative organizational culture, learning culture, and
transformational leadership: it measures whether a team is free to try new ideas and test them with real users, rather than executing a
specification handed down by someone else. DORA defines it as the ability "to work on new ideas independently, without having to get
permission from outside of the team," to "write and change specifications during development," and to "make changes to stories and
specifications without having to get permission from outside of the team."[^1]

It is not part of the DORA Core Model; DORA counts it among the lean product management capabilities that together predict both software
delivery performance and organizational performance: a team that can experiment ships features that add value to the organization, and ships
those features more frequently, because the team closest to the user is the one deciding what to build and how to build it.

## Summary

The capability is team experimentation: a development team's freedom to work on new ideas and test solutions with real users in pursuit of
business outcomes, rather than being handed a fixed specification to execute. DORA frames the story card as "a reminder of a conversation
between customers and the team," not a contract — the team keeps having that conversation throughout delivery, adjusting the specification
as it learns rather than only at the start.

Three abilities make the capability concrete: working on new ideas without outside permission, writing and changing specifications during
development, and changing stories and specifications without outside permission. All three describe the same shift — decision rights over
what to build and how move from outside the team to inside it.

## Why it matters

DORA's research ties team experimentation to higher software delivery performance and higher organizational performance: teams that can test
ideas with real users ship features that add value, and ship them more frequently. The mechanism is proximity — the team closest to the user
and the code is best placed to judge whether an idea works, and every hand-off to an outside approver adds latency without adding insight.
Without the ability to experiment, a team can only execute someone else's specification, and any defect in that specification surfaces only
after the fact, when it is most expensive to fix.

## How to apply

This platform realizes the capability by removing the outside gate a team would otherwise wait behind. Self-service
([ADR-DSGN-SELFSERV](../design/self-service.md)) lets a consumer provision and change managed infrastructure directly, through the CLI,
without filing a ticket to a central gatekeeper — the same freedom DORA measures as working on new ideas without permission from outside the
team. The thin platform ([ADR-DSGN-THINPLAT](../design/thin-platforms.md)) gives consumers a CLI surface where they edit configuration and
compose functions themselves, trusting them as the experts on their own implementation rather than routing every change through the platform
team. Agile's customer-collaboration value ([ADR-PROC-VALUES](../process/agile-values.md)) treats a story as an ongoing conversation to be
revised as understanding grows, not a contract executed as originally written — the same posture that lets specifications change during
development.

## Common pitfalls

- **Order-taking.** Treating technical staff as order-takers, or giving specific direction on how the work is done rather than what outcome
  it must reach, removes the judgment experimentation depends on.
- **No time to experiment.** Failing to provide the opportunities or time for a team to design and conduct experiments quietly forecloses
  the capability even where permission to experiment exists in principle.
- **Permission gates on specification changes.** Requiring outside sign-off before a story or specification can change during development
  re-creates the very bottleneck the capability removes, and slows the team's ability to respond to what it learns from real users.

## References

[^1]:
    DORA, _Team experimentation_ capability, <https://dora.dev/capabilities/team-experimentation/>. One of the lean product management
    capabilities that predict software delivery performance and organizational performance; not part of the DORA Core Model.

## Dora explains

Team experimentation sits in DORA's climate-for-learning category, outside the Core Model. It measures whether decision rights over what to
build and how sit with the team doing the work, and DORA treats it as part of lean product management: together with work visibility, small
batches, and customer feedback, it predicts both software delivery performance and organizational performance.

- **Catalogue entry:** [Team experimentation](../../references/dora/capabilities.md#team-experimentation)
- **Category:** [Climate for learning](../../references/dora/capabilities.md#climate-for-learning) — not in the Core Model.
- **Evidence:** the capability page cites no year; the lean product management findings it summarizes appear in the report pages of:
  - [2016 State of DevOps Report](../../references/dora/publications.md#2016-state-of-devops-report) — an experimental approach to product
    development (small batches, visibility of workflow, customer feedback) improves IT and organizational performance.
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — lean product management (small
    batches, customer feedback) drives organizational performance.
- **Predicts:** as one of the lean product management capabilities,
  [software delivery performance](../../references/dora/core-model.md#software-delivery-performance) and
  [organizational performance](../../references/dora/core-model.md#organizational-performance).
- **Related capabilities:**
  - [Generative organizational culture](../../references/dora/capabilities.md#generative-organizational-culture) — the culture research
    within which a team's freedom to experiment is measured.
  - [Learning culture](../../references/dora/capabilities.md#learning-culture) — a team must be able to learn from an experiment before it
    can be trusted to run the next one.
  - [Transformational leadership](../../references/dora/capabilities.md#transformational-leadership) — leaders supply the vision and
    intellectual stimulation that make room for a team to experiment.
  - [Customer feedback](../../references/dora/capabilities.md#customer-feedback) — testing solutions with real users is exactly how a team
    gathers the feedback experimentation is aimed at.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
