# ADR: DORA — Job satisfaction

## Rules: ADR-DORAJS

### Rule ADR-DORAJS:1

Job satisfaction is treated as the product of challenging, meaningful work and the room to exercise skill and judgment — not as a proxy for
compensation. Employees rate meaningful work as being about as important as salary, so work design carries as much weight as pay.

- [Summary](#summary)

### Rule ADR-DORAJS:2

Empowerment includes the tools people use to do their work. Teams that can choose their own tools do better at continuous delivery, so
mandating a fixed toolset from a central authority works against the capability rather than for it.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAJS:3

Job satisfaction sits upstream of performance, not downstream of it: satisfied people produce better work, better work lifts software
delivery performance, and delivery performance lifts organizational performance. Treat it as a leading driver to invest in, not a perk to
hand out once performance is already high.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAJS:4

Never infer job satisfaction from system telemetry. There is no reliable proxy for it in commit logs, ticket counts, or deployment metrics —
it is measured by asking people directly, and it stays a perceptual measure even where every other DORA capability has a system-data signal.

- [How to apply](#how-to-apply)

### Rule ADR-DORAJS:5

Treat reluctance to answer job-satisfaction questions honestly as a finding in itself, not as missing data to work around. When people will
not say how they feel about the work, that reluctance points at an organizational problem worth investigating on its own.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAJS:6

Budget real time and resources for people to adjust during a technology or process change. A transformation that changes tools or ways of
working without giving people time to build the new skills spends the change against job satisfaction rather than for it.

- [Common pitfalls](#common-pitfalls)

## Context

Job satisfaction is one of DORA's cultural and people capabilities, sitting in the DORA Core Model alongside the technical and process
capabilities as a predictor of organizational performance. DORA defines it as "doing work that's challenging and meaningful, and being
empowered to exercise skills and judgment."

Unlike most capabilities in the model, job satisfaction has no reliable proxy in system data — it cannot be read off a dashboard the way
deployment frequency or change lead time can. DORA measures it through direct employee feedback, which makes it as much a management
discipline as an engineering one: providing the right tools, assigning meaningful work, and giving people time to adapt when the
organization changes around them.

## Summary

The capability is job satisfaction: people doing work that is challenging and meaningful, with the autonomy to bring their own skill and
judgment to it. DORA frames this as a virtuous cycle — engaged people produce better work, better work drives higher software delivery
performance, and that performance compounds into organizational performance, competitive advantage, and continued innovation.

Two concrete levers recur in DORA's guidance: giving people the tools and resources they need, including the freedom to choose those tools,
and assigning work that draws on their expertise rather than work that is merely busywork. Employees weigh meaningful work about as heavily
as salary, which is why this capability sits in the model as a driver of performance rather than as a downstream reward for it.

## Why it matters

DORA's research places job satisfaction upstream in the causal chain, not downstream: satisfaction is not what a team gets after it performs
well, it is part of what makes strong performance possible in the first place. Engaged people do better work, better work improves software
delivery performance, and improved delivery performance feeds organizational performance, supporting the continuous improvement and learning
that further innovation depends on.

The mechanism runs through two things a team's environment controls directly — the tools available to do the work, and the meaning of the
work itself. Teams that can decide which tools they use do better at continuous delivery, so tool choice is not a side issue to job
satisfaction but one of its direct inputs. Meaningful work matters just as much: research shows people value it comparably to salary, so
treating it as a nice-to-have rather than a design input for how work gets assigned discards a real lever on performance.

## How to apply

This platform treats zero-ceremony automation as a job-satisfaction lever, not only an engineering-efficiency one
([ADR-ZERO](../automation/zero-ceremony-poka-yoke.md)): removing boilerplate, registration, and ceremony from adding a function or module
leaves people's time and judgment for the work that is actually challenging, rather than for fighting the platform. Self-service
([ADR-SELFSERV](../design/self-service.md)) gives consumers the autonomy DORA's definition calls for — provisioning and changing managed
infrastructure themselves, through the CLI, without a ticket queue standing between judgment and action. Vendoring every dependency and
assuming no local admin ([ADR-ENTERP](../automation/effective-in-enterprises.md)) keeps tool access itself from becoming a source of
friction — a team blocked from installing the tools it needs cannot exercise the tool-choice autonomy this capability depends on.

None of these substitutes for asking people directly how satisfied they are with their work — no system-data proxy exists for that — but
they remove some of the concrete, structural sources of dissatisfaction: ceremony that wastes skilled time, gatekeeping that removes
autonomy, and tooling friction that blocks the tools a team would otherwise choose.

## Common pitfalls

- **Withholding the tools people need.** Not providing the tools and resources required to do the work well — including denying teams a say
  in which tools they use — removes one of the concrete levers this capability depends on.
- **Assigning work without meaning.** Work that does not draw on a person's skill or judgment scores poorly on job satisfaction even when it
  is technically well organized; meaningful work is not an afterthought to how tasks get assigned.
- **Underestimating adjustment time.** Technology and process transformations that change tools or ways of working without budgeting real
  time for people to build new skills and adapt spend the change against job satisfaction instead of for it.

## References

[^1]:
    DORA, _Job satisfaction_ capability, <https://dora.dev/capabilities/job-satisfaction/>. Listed as a core model capability that predicts
    organizational performance, measured through direct employee feedback rather than system data.

## Dora explains

Job satisfaction is one of the people-side capabilities in DORA's Core Model — it does not show up in deployment frequency or lead-time
numbers directly, but DORA's research treats it as part of what makes those numbers achievable, since satisfied, empowered people are the
ones who sustain the technical practices the other capabilities describe.

- [Teams empowered to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — the tool-choice autonomy DORA ties
  directly to job satisfaction and to continuous delivery performance.
- [Test automation](https://dora.dev/capabilities/test-automation/) — a technical practice job satisfaction sustains by giving people the
  time and confidence to do challenging work well.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — one of the delivery practices that engaged, empowered
  teams are positioned to sustain.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — automation that removes rote toil, leaving room for the
  challenging, meaningful work this capability describes.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
