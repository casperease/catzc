# ADR: DORA — Deployment automation

## Rules: ADR-DORADA

### Rule ADR-DORADA:1

Deployment automation means deploying to any environment, including production, with the push of a button — from a CI-generated package, the
deployment scripts and configuration that place it, and environment-specific information, with all three kept in version control.

- [Summary](#summary)

### Rule ADR-DORADA:2

The deployment process is identical across every environment, including production. Rehearsing the same automated steps in non-production is
what makes the production run trustworthy; a distinct "special" production procedure is untested by every non-production deploy that
preceded it.

- [How to apply](#how-to-apply)

### Rule ADR-DORADA:3

Any credentialed person can deploy any artifact version to any environment on demand, fully automated, with no ticket-based or manual
approval delay built into the mechanism itself. Environment-specific configuration is kept separate from the deployable package so the same
tested artifact reaches every environment unchanged.

- [How to apply](#how-to-apply)

### Rule ADR-DORADA:4

Automate deployable units that are themselves simple, idempotent, and order-independent. Automating a fragile, tightly coupled manual
process produces fragile automation — the target for automation is decoupled, independently deployable services, not a snapshot of today's
manual orchestration.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORADA:5

Give every deployment step an API- or configuration-driven interface. A step that still requires manual console interaction is a gap in the
automation, not an acceptable manual exception, and it is where developers and operators drift onto different, inconsistent deployment
methods.

- [Common pitfalls](#common-pitfalls)

## Context

Deployment automation is one of DORA's technical capabilities, and it sits downstream of version control and continuous integration: it
consumes the artifact CI produces and the scripts and configuration that version control holds, and it is what continuous delivery and
continuous deployment promote that artifact through. DORA defines it plainly as what "enables you to deploy your software to testing and
production environments with the push of a button."

The capability names three required inputs to a deployment — the CI-generated package, the deployment scripts and configuration, and
environment-specific information — and expects all three to live in version control so a deploy is reproducible rather than improvised.

## Summary

Deployment automation replaces manual, one-off deployment procedures with a repeatable, push-button process that runs the same way in every
environment. A deploy typically breaks down into a common sequence of steps: preparing the target environment, deploying the package,
running deployment-related tasks such as database migrations, applying configuration, and running a smoke test to confirm the deploy
succeeded.

The capability is comprehensive in scope, not partial: it covers testing environments as much as production, and it covers the scripts and
configuration that drive a deploy as much as the artifact being deployed.

## Why it matters

DORA's research finds automation valuable for two connected reasons: it lowers the risk of deploying to production, and it accelerates
feedback by making comprehensive testing possible immediately after a code change, rather than gated behind a slow or manual release
process. A team that must hand-run or manually sequence a deploy either tests less than it should to keep pace, or pays a growing tax in
lead time as the manual steps accumulate. Automating the deploy removes that trade-off: the same low-risk, repeatable process can run as
often as changes arrive, so testing and shipping stop competing with each other.

## How to apply

This platform's pipeline runner pattern gives every deployment step one entry point regardless of which environment it targets
([ADR-RUNNER](../pipelines/pipeline-runner-pattern.md)) — the same `RunCommand` a pipeline runs is the command a developer reproduces
locally, which is what keeps the deployment process identical across environments rather than diverging as it approaches production. The
CI-discipline and promotion-flow design carries one build-once, tagged artifact through non-production and into production without any stage
rebuilding it ([ADR-FLOW](../design/ci-discipline-and-promotion-flow.md)), so the artifact a later environment receives is byte-identical to
the one an earlier environment already exercised. State-changing deployment functions are required to be idempotent and safe to re-run
([ADR-IDEM](../automation/idempotent-state-functions.md)), which is what keeps a retried or partially-failed deploy safe rather than
compounding into duplicate or inconsistent state.

## Common pitfalls

- **Automating complexity instead of removing it.** Wrapping a fragile manual process in a script produces fragile automation. Deployable
  units should be simple, idempotent, and order-independent before they are automated, not after.

- **Tight coupling between components and services.** Dependencies that force one component's deploy to be orchestrated around another's
  defeat the goal of independently deployable services that require no cross-service orchestration to release.

- **Gaps left to manual console interaction.** A step that still requires a human to click through a console, rather than an API call or a
  configuration file, is an unautomated step hiding inside an otherwise automated pipeline.

- **Developers and operators using different deployment paths.** When the people who write the software and the people who run it deploy
  through different mechanisms, inconsistency and manual intervention creep back in at exactly the seam automation was meant to close.

## References

[^1]:
    DORA, _Deployment automation_ capability, <https://dora.dev/capabilities/deployment-automation/>. Part of the DORA Core Model of
    capabilities that predict software delivery performance.

## Dora explains

Deployment automation is one of the capabilities DORA's research ties directly to deployment frequency and change lead time: a push-button,
identically-repeated deploy is what lets a team ship as often as it has changes ready, and it lowers change failure rate by removing manual,
error-prone steps from the path to production.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the practice that deployment automation makes achievable, by
  keeping the software always in a deployable state.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — supplies the versioned, tested package that deployment
  automation deploys.
- [Version control](https://dora.dev/capabilities/version-control/) — holds the deployment scripts, configuration, and environment
  information the capability depends on.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — pairs with automated, on-demand deploys to
  remove ticket-based delay from the release path.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
