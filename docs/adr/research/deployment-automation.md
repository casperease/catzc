---
catzc:
  derived:
    path: docs/adr/research/deployment-automation.md
    kind: adr
    language: markdown
    filetype: md
    track: docs
    body_sha: "179a9dc40c85"
    defines:
      - ADR-DORA-DEPLOY#{1-5}
    links:
      - docs/adr/automation/idempotent-state-functions.md
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/adr/flow/pipeline-runner-pattern.md
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#continuous-integration
      - docs/references/dora/capabilities.md#deployment-automation
      - docs/references/dora/capabilities.md#fast-flow
      - docs/references/dora/capabilities.md#streamlining-change-approval
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/core-model.md#fast-flow
      - docs/references/dora/core-model.md#software-delivery-performance
      - docs/references/dora/index.md
      - docs/references/dora/publications.md#2017-state-of-devops-report
      - "https://dora.dev/capabilities/deployment-automation/"
---

# ADR: DORA — Deployment automation

## Rules: ADR-DORA-DEPLOY

### Rule ADR-DORA-DEPLOY:1

Deployment automation means deploying to any environment, including production, with the push of a button — from a CI-generated package, the
deployment scripts and configuration that place it, and environment-specific information, with all three kept in version control.

- [Summary](#summary)

### Rule ADR-DORA-DEPLOY:2

The deployment process is identical across every environment, including production. Rehearsing the same automated steps in non-production is
what makes the production run trustworthy; a distinct "special" production procedure is untested by every non-production deploy that
preceded it.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-DEPLOY:3

Any credentialed person can deploy any artifact version to any environment on demand, fully automated, with no ticket-based or manual
approval delay built into the mechanism itself. Environment-specific configuration is kept separate from the deployable package so the same
tested artifact reaches every environment unchanged.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-DEPLOY:4

Automate deployable units that are themselves simple, idempotent, and order-independent. Automating a fragile, tightly coupled manual
process produces fragile automation — the target for automation is decoupled, independently deployable services, not a snapshot of today's
manual orchestration.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-DEPLOY:5

Give every deployment step an API- or configuration-driven interface. A step that still requires manual console interaction is a gap in the
automation, not an acceptable manual exception, and it is where developers and operators drift onto different, inconsistent deployment
methods.

- [Common pitfalls](#common-pitfalls)

## Context

Deployment automation is one of DORA's technical capabilities, and it sits downstream of version control and continuous integration: it
consumes the artifact CI produces and the scripts and configuration that version control holds, and it is what continuous delivery and
continuous deployment promote that artifact through. DORA defines it plainly as what "enables you to deploy your software to testing and
production environments with the push of a button."[^1]

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
([ADR-FLOW-CD-RUNNER](../flow/pipeline-runner-pattern.md)) — the same `RunCommand` a pipeline runs is the command a developer reproduces
locally, which is what keeps the deployment process identical across environments rather than diverging as it approaches production. The
CI-discipline and promotion-flow design carries one build-once, tagged artifact through non-production and into production without any stage
rebuilding it ([ADR-FLOW-CD](../flow/cd-discipline-and-promotion-flow.md)), so the artifact a later environment receives is byte-identical
to the one an earlier environment already exercised. State-changing deployment functions are required to be idempotent and safe to re-run
([ADR-AUTO-IDEM](../automation/idempotent-state-functions.md)), which is what keeps a retried or partially-failed deploy safe rather than
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

Deployment automation sits in the Core Model's fast-flow group as one of the technical capabilities that drive continuous delivery, and
through it software delivery performance. DORA also calls it essential for lowering deployment risk and for getting fast feedback: a
push-button, identically repeated deploy lets a team ship as often as it has changes ready without manual, error-prone steps in the way.

- **Catalogue entry:** [Deployment automation](../../references/dora/capabilities.md#deployment-automation)
- **Category:** [Fast flow](../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0:
  [fast flow](../../references/dora/core-model.md#fast-flow).
- **Evidence:** the capability page cites no year; the catalogue attributes the finding to one report page:
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — high performers automate much more of
    their configuration management, testing, deployments, and change approvals.
- **Predicts:** [continuous delivery](../../references/dora/capabilities.md#continuous-delivery), one of whose driving capabilities it is,
  and through it [software delivery performance](../../references/dora/core-model.md#software-delivery-performance); lower deployment risk
  and faster feedback.
- **Related capabilities:**
  - [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the practice that deployment automation makes
    achievable, by keeping the software always in a deployable state.
  - [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — supplies the versioned, tested package that
    deployment automation deploys.
  - [Version control](../../references/dora/capabilities.md#version-control) — holds the deployment scripts, configuration, and environment
    information the capability depends on.
  - [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — pairs with automated, on-demand
    deploys to remove ticket-based delay from the release path.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
