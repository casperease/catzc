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

It sits in the DORA Core Model as one of the capabilities that predict both software delivery performance and organizational performance: a
team that can experiment ships features that add value to the organization, and ships those features more frequently, because the team
closest to the user is the one deciding what to build and how to build it.

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
    DORA, _Team experimentation_ capability, <https://dora.dev/capabilities/team-experimentation/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance and organizational performance.

## Dora explains

Team experimentation is one of DORA's cultural capabilities: it measures whether decision rights over what to build and how sit with the
team doing the work, which DORA ties to both delivery performance and organizational performance.

- [Generative organizational culture](https://dora.dev/capabilities/generative-organizational-culture/) — the culture research within which
  a team's freedom to experiment is measured.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — a team must be able to learn from an experiment before it can be
  trusted to run the next one.
- [Transformational leadership](https://dora.dev/capabilities/transformational-leadership/) — leaders supply the vision and intellectual
  stimulation that make room for a team to experiment.
- [Customer feedback](https://dora.dev/capabilities/customer-feedback/) — testing solutions with real users is exactly how a team gathers
  the feedback experimentation is aimed at.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
