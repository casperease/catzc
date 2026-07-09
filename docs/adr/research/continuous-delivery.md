# ADR: DORA — Continuous delivery

## Rules: ADR-DORACD

### Rule ADR-DORACD:1

Continuous delivery means the software stays releasable on demand throughout its lifecycle, not that every change deploys automatically —
treat "deployable at any time" as the property to sustain and leave the decision to deploy as a separate, later question.

- [Summary](#summary)

### Rule ADR-DORACD:2

Deployability is the default state to protect, not an event to schedule: prioritize fixing whatever makes the system non-deployable over new
feature work, and keep fast quality feedback available to everyone building toward the release, not only to a release team.

- [Why it matters](#why-it-matters)

### Rule ADR-DORACD:3

Treat continuous delivery as comprehensive in scope — it applies to distributed systems, infrastructure changes, database changes, firmware,
and mobile releases alike, not only to the application code path that is easiest to automate.

- [Summary](#summary)

### Rule ADR-DORACD:4

Never mistake running the existing deployment process more often for continuous delivery. Raising deployment frequency without improving the
underlying test automation, architecture, and process first raises the failure rate and the team's burnout, not its performance.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORACD:5

Adopting deployment-pipeline tooling does not substitute for the technical practices and process change it is meant to carry — comprehensive
test automation, loosely coupled architecture, and trunk-based development are the capabilities that make the pipeline trustworthy.

- [How to apply](#how-to-apply)

## Context

Continuous delivery sits in the DORA Core Model as one of the technical capabilities that predicts software delivery performance. DORA
defines it as "the ability to release changes of all kinds — including new features, configuration changes, bug fixes, and experiments —
into production, or into the hands of users, safely, quickly, and sustainably". A team practicing it well can make production changes during
normal business hours, with no user-visible downtime and no need for anyone to work outside regular hours to ship.

DORA names fourteen technical capabilities that drive continuous delivery: test automation, deployment automation, trunk-based development,
pervasive security, loosely coupled teams and architecture, teams empowered to choose their own tools, continuous integration, continuous
testing, version control, test data management, monitoring and observability, proactive failure notification, database change management,
and code maintainability. Continuous delivery is the composite outcome of these capabilities working together, not a single practice or tool
layered on top of them.

## Summary

The capability is on-demand release capability: the software is deployable throughout its lifecycle, and the team can choose to deploy it at
any time without that being a risky, special event. DORA is explicit that this is not continuous deployment — continuous deployment releases
every change automatically as soon as it passes the pipeline, while continuous delivery keeps the system always in a releasable state and
treats the decision to actually release as separate and deliberate.

Teams that practice it well can answer yes to a small set of questions: is the software deployable throughout its lifecycle; does the team
prioritize keeping it deployable over building new features; is fast quality feedback available to everyone; is fixing non-deployability the
highest priority when it happens; and can the team deploy to production on demand, at any time. The scope is comprehensive — application
code, infrastructure, database changes, firmware, and mobile releases are all included, not only the parts of the system that are easiest to
automate.

## Why it matters

DORA's research ties continuous delivery to higher performance across the four key delivery metrics and to higher availability at the same
time — directly countering the assumption that shipping faster trades away reliability. High-performing teams that practice continuous
delivery well achieve better reliability and availability than teams that ship less often, not worse.

The research also links continuous delivery to lower rework and unplanned work, reduced deployment pain, and better outcomes for the people
doing the work: lower burnout, higher job satisfaction, and a healthier organizational culture. The mechanism is that a system kept
continuously deployable removes the friction and dread around releases — deployment stops being a disruptive event and becomes a routine,
low-risk action any time it is needed.

## How to apply

This platform's pipeline design realizes the delivery/deployment distinction DORA draws directly:
[ci-discipline-and-promotion-flow](../design/ci-discipline-and-promotion-flow.md) (ADR-FLOW) names Continuous Delivery (CD) as the automated
promotion of a build-once, tagged artifact through non-prod, left ready for production but handed to a separately governed DEPLOY step for
the human-owned production cutover — and names Continuous Deployment (CDe) as the same flow with that last step internalized and automated.
Keeping deployability as the property CD protects, and the production decision as a distinct governance question, is exactly the "deployable
on demand, deploy is a separate choice" framing this capability describes.

[pipeline-types](../pipelines/pipeline-types.md) (ADR-PIPETYPE) is the taxonomy underneath: one CI engine shared by CI and CD
(ADR-PIPETYPE:3), a bounded pre-commit budget so slow verification is pushed into the deploy path rather than skipped (ADR-PIPETYPE:4), and
a DEPLOY pipeline that never rebuilds, only promotes a pinned, already-verified artifact (ADR-PIPETYPE:8–ADR-PIPETYPE:10). That build-once
discipline is what keeps a continuously delivered system's non-prod certification meaningful when it reaches production.

## Common pitfalls

- **Deploying more often without changing the process.** Teams mistake continuous delivery for running their existing, manual-heavy
  deployment process on a tighter schedule. Without the supporting test automation and architecture, higher frequency alone raises the
  change failure rate and burns out the team doing the releases.
- **Tooling without practice change.** Adopting deployment-pipeline tooling or patterns while skipping the underlying technical practices —
  comprehensive test automation, loosely coupled services, trunk-based development — does not produce the expected gains; the tooling only
  pays off once the practices it depends on are in place.
- **Underestimating the transition dip.** Teams starting from a low base often see efficiency drop before it improves, as new test and
  process requirements surface technical debt that automation alone cannot fix. Recovering requires process redesign, architectural
  improvement, and skills development alongside the automation, not automation on its own.
- **Skipping value stream mapping.** Without mapping each stage a change passes through — testing, security review, change management,
  release — and measuring elapsed time, value-add time, and percent complete and accurate, bottlenecks stay invisible until they show up as
  missed releases.

## References

[^1]:
    DORA, _Continuous delivery_ capability, <https://dora.dev/capabilities/continuous-delivery/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Continuous delivery is one of DORA's clearest links between technical practice and the four key metrics: teams that keep their software
releasable on demand see shorter lead times, lower change failure rates, faster recovery, and higher deployment frequency together, not as a
trade-off between speed and stability.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — the fast, frequent integration into one mainline that
  continuous delivery builds its releasable state on top of.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — the automated, repeatable deploy mechanism continuous
  delivery relies on to make releasing routine rather than risky.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — the branching discipline that keeps the mainline in
  the always-deployable state this capability requires.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — architecture that lets services deploy independently,
  identified by DORA as one of the strongest predictors of successful continuous delivery.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
