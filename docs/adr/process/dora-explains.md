---
catzc:
  immutable:
    with_body_sha: "084c203254f8"
    path: docs/adr/process/dora-explains.md
    folder: docs/adr/process
    name: dora-explains
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/process/agile-principles.md
      - docs/adr/process/agile-values.md
      - docs/adr/process/agile.md
      - docs/adr/process/build-quality-in.md
      - docs/adr/process/holding-the-line.md
      - docs/adr/process/inspect-and-adapt.md
      - docs/adr/process/lean.md
      - docs/adr/process/observe-work.md
      - docs/adr/process/process-terms.md
      - docs/adr/process/pull-work.md
      - docs/adr/process/queues-cost-money.md
      - docs/references/dora/capabilities.md#code-maintainability
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#continuous-integration
      - docs/references/dora/capabilities.md#customer-feedback
      - docs/references/dora/capabilities.md#deployment-automation
      - docs/references/dora/capabilities.md#flexible-infrastructure
      - docs/references/dora/capabilities.md#generative-organizational-culture
      - docs/references/dora/capabilities.md#learning-culture
      - docs/references/dora/capabilities.md#loosely-coupled-teams
      - docs/references/dora/capabilities.md#monitoring-and-observability
      - docs/references/dora/capabilities.md#team-experimentation
      - docs/references/dora/capabilities.md#teams-empowered-to-choose-tools
      - docs/references/dora/capabilities.md#test-automation
      - docs/references/dora/capabilities.md#trunk-based-development
      - docs/references/dora/capabilities.md#visual-management
      - docs/references/dora/capabilities.md#wip-limits
      - docs/references/dora/capabilities.md#work-visibility-in-value-stream
      - docs/references/dora/capabilities.md#working-in-small-batches
      - docs/references/dora/index.md
---

# DORA explanations — process

The `Dora explains` rationale for the ADRs in the `process/` domain, consolidated in one place. Each entry names its ADR and rule code, then
reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions live in
the ADRs themselves; this file carries only their DORA rationale.

## Agile

`Agile — defined by the manifesto, measured by responsiveness`

[ADR-PROC-AGILE](agile.md)

> DORA's research frames delivery performance as the capacity to make changes safely and quickly — the same responsiveness the manifesto
> describes. Agile as defined here is the cultural and process foundation the technical capabilities below make measurable.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — small batches keep the cost of change low,
  which is what agility means in practice.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the ability to release change on demand is
  responsiveness made concrete.
- [Learning culture](../../references/dora/capabilities.md#learning-culture) — responding to change depends on a team that learns and
  adjusts rather than conforms.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Agile values

`Agile values — the four preferences of the manifesto`

[ADR-PROC-VALUES](agile-values.md)

> DORA's research consistently finds that team capability and culture, not tooling or documentation weight, predict delivery performance —
> the same ordering the four values assert.

- [Teams empowered to choose tools](../../references/dora/capabilities.md#teams-empowered-to-choose-tools) — putting people ahead of imposed
  tooling reflects individuals and interactions over processes and tools.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — small batches are what make responding to
  change over following a plan affordable.
- [Learning culture](../../references/dora/capabilities.md#learning-culture) — customer collaboration and change response both depend on a
  team that treats a plan as a hypothesis to revise.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Agile principles

`Agile principles — the twelve principles behind the manifesto`

[ADR-PRIN-PROCESS](agile-principles.md)

> DORA's technical and management capabilities are, in large part, measurable realisations of these principles — frequent delivery, low
> change-cost, team autonomy, and continuous improvement.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — the operational form of early, frequent
  delivery of working software.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — welcoming late change is only affordable when releasing
  is routine.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — self-organising teams that own their work reflect
  principles 5 and 11.
- [Learning culture](../../references/dora/capabilities.md#learning-culture) — regular reflection that tunes the team's behaviour is a
  learning culture in practice.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Process terms

`Process terms — the foundational vocabulary of flow`

[ADR-PROC-LEANTERMS](process-terms.md)

> DORA's delivery metrics are this vocabulary measured: deployment frequency and change lead time are throughput and lead time, and DORA's
> finding that small batches drive both is Little's Law reading out on real systems.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — batch size defined here is the lever DORA
  finds most strongly tied to short lead time.
- [Work in process limits](../../references/dora/capabilities.md#wip-limits) — limiting work-in-progress is Little's Law applied to the flow
  primitives above.
- [Visibility of work in the value stream](../../references/dora/capabilities.md#work-visibility-in-value-stream) — you cannot find the
  constraint in a value stream you cannot see.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the automated/manual distinction made concrete at
  the deployment step.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Lean

`Lean — the Toyota Production System, mapped to software by the Poppendiecks`

[ADR-PROC-LEAN](lean.md)

> DORA's research frames elite delivery as fast, stable flow — short lead times and small batches with quality held constant — which is lean
> flow discipline measured. The lean principles here are the practices those metrics reward.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — small batches are the core lean flow move and
  the strongest predictor of short lead time.
- [Work in process limits](../../references/dora/capabilities.md#wip-limits) — limiting work-in-progress is Little's Law applied: it lowers
  lead time directly.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — delivering fast and building quality in are the two
  pillars made continuous.
- [Learning culture](../../references/dora/capabilities.md#learning-culture) — creating knowledge and optimising the whole depend on a team
  that learns from the flow it can see.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Holding the line

`Holding the line — a gate that fails stops the flow until it is green`

[ADR-PROC-ANDON](holding-the-line.md)

> DORA finds that keeping the mainline releasable — fixing a broken build as the top priority — is a defining practice of high-performing
> teams, and that trunk-based development depends on it.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — a failing build stops the line and is fixed
  within minutes; that discipline is what CI measures.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — building only on a green mainline is what makes
  a shared trunk safe.
- [Test automation](../../references/dora/capabilities.md#test-automation) — automated quality gates are the cords that can stop the line
  the instant a defect appears.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Build quality in

`Build quality in — you cannot inspect it in at the end`

[ADR-PROC-BUILTIN](build-quality-in.md)

> DORA finds that automated testing and continuous integration — quality produced as part of the work — predict both higher throughput and
> higher stability, contradicting the assumption that quality trades against speed.

- [Test automation](../../references/dora/capabilities.md#test-automation) — automated tests build quality into every change instead of
  inspecting it in later.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — gates that run as the work is produced are how
  quality is built in continuously.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — correct-by-construction code, enforced structurally,
  is what keeps change cheap.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Observe the work

`Observe the work — make it visible, and go and see`

[ADR-PROC-OBSERVEWIP](observe-work.md)

> DORA finds that visibility of work across the value stream, visual management, and monitoring are capabilities that distinguish
> high-performing teams — seeing the work is a precondition for improving its flow.

- [Visibility of work in the value stream](../../references/dora/capabilities.md#work-visibility-in-value-stream) — a rendered end-to-end
  flow is exactly this capability.
- [Visual management](../../references/dora/capabilities.md#visual-management) — making state visible at a glance is the visual factory
  applied to delivery.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — going to see the real running
  artifact depends on real signals from it.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pull, don't push

`Pull work through the system — do not push it`

[ADR-PROC-PULLWORK](pull-work.md)

> DORA finds that working in small batches and limiting work in progress are among the strongest predictors of short lead time and stable
> delivery — the pull discipline measured directly.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — the core pull move and the strongest single
  lever on lead time.
- [Work in process limits](../../references/dora/capabilities.md#wip-limits) — a WIP cap is what turns pull and small batches into an
  enforced mechanism.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — pulling small increments to done on demand is
  continuous delivery in practice.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## The money is lost in the queues

`The money is lost in the queues — Little's Law and the cost of delay`

[ADR-PROC-QUEUECOST](queues-cost-money.md)

> DORA's flow metrics — lead time and deployment frequency — are queue measurements, and the practices that improve them are the ones that
> drain queues: small batches, low work-in-progress, and elastic infrastructure.

- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — small batches keep queue length and its cost
  of delay low.
- [Work in process limits](../../references/dora/capabilities.md#wip-limits) — capping work-in-progress is the Little's-Law lever on lead
  time.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — fast, parallel, cached quality gates shorten the
  feedback queue every change waits in.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — ephemeral, elastic compute is how machine time
  is spent to drain a human queue.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Inspect and adapt

`Inspect and adapt — kaizen built into the process`

[ADR-PROC-KAIZEN](inspect-and-adapt.md)

> DORA finds that a learning culture and deliberate experimentation are among the strongest cultural predictors of delivery performance —
> inspect-and-adapt, made continuous, is what those capabilities describe.

- [Learning culture](../../references/dora/capabilities.md#learning-culture) — treating the process as something to inspect and improve is a
  learning culture in practice.
- [Team experimentation](../../references/dora/capabilities.md#team-experimentation) — adapting from evidence means running and learning
  from small changes to how the team works.
- [Customer feedback](../../references/dora/capabilities.md#customer-feedback) — the outermost inspect-and-adapt loop closes on what the
  customer actually experiences.
- [Generative organizational culture](../../references/dora/capabilities.md#generative-organizational-culture) — a blameless,
  evidence-driven response to a stopped line is what lets the loop run at all.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
