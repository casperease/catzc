# DORA explanations — process

The `Dora explains` rationale for the ADRs in the `process/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Agile — defined by the manifesto, measured by responsiveness (`ADR-PROC-AGILE`)

DORA's research frames delivery performance as the capacity to make changes safely and quickly — the same responsiveness the manifesto
describes. Agile as defined here is the cultural and process foundation the technical capabilities below make measurable.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches keep the cost of change low, which is
  what agility means in practice.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the ability to release change on demand is responsiveness made
  concrete.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — responding to change depends on a team that learns and adjusts
  rather than conforms.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Agile values — the four preferences of the manifesto (`ADR-PROC-VALUES`)

DORA's research consistently finds that team capability and culture, not tooling or documentation weight, predict delivery performance — the
same ordering the four values assert.

- [Teams empowered to choose tools](https://dora.dev/capabilities/teams-empowered-to-choose-tools/) — putting people ahead of imposed
  tooling reflects individuals and interactions over processes and tools.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches are what make responding to change
  over following a plan affordable.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — customer collaboration and change response both depend on a team
  that treats a plan as a hypothesis to revise.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Agile principles — the twelve principles behind the manifesto (`ADR-PRIN-PROCESS`)

DORA's technical and management capabilities are, in large part, measurable realisations of these principles — frequent delivery, low
change-cost, team autonomy, and continuous improvement.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the operational form of early, frequent delivery of
  working software.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — welcoming late change is only affordable when releasing is
  routine.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — self-organising teams that own their work reflect
  principles 5 and 11.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — regular reflection that tunes the team's behaviour is a learning
  culture in practice.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Process terms — the foundational vocabulary of flow (`ADR-PROC-LEANTERMS`)

DORA's delivery metrics are this vocabulary measured: deployment frequency and change lead time are throughput and lead time, and DORA's
finding that small batches drive both is Little's Law reading out on real systems.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — batch size defined here is the lever DORA finds most
  strongly tied to short lead time.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — limiting work-in-progress is Little's Law applied to the flow
  primitives above.
- [Visibility of work in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — you cannot find the constraint
  in a value stream you cannot see.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — the automated/manual distinction made concrete at the
  deployment step.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Lean — the Toyota Production System, mapped to software by the Poppendiecks (`ADR-PROC-LEAN`)

DORA's research frames elite delivery as fast, stable flow — short lead times and small batches with quality held constant — which is lean
flow discipline measured. The lean principles here are the practices those metrics reward.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches are the core lean flow move and the
  strongest predictor of short lead time.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — limiting work-in-progress is Little's Law applied: it lowers lead
  time directly.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — delivering fast and building quality in are the two pillars
  made continuous.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — creating knowledge and optimising the whole depend on a team that
  learns from the flow it can see.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Holding the line — a failing gate stops the flow until it is green (`ADR-PROC-ANDON`)

DORA finds that keeping the mainline releasable — fixing a broken build as the top priority — is a defining practice of high-performing
teams, and that trunk-based development depends on it.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — a failing build stops the line and is fixed within
  minutes; that discipline is what CI measures.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — building only on a green mainline is what makes a
  shared trunk safe.
- [Test automation](https://dora.dev/capabilities/test-automation/) — automated gates are the cords that can stop the line the instant a
  defect appears.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Build quality in — you cannot inspect it in at the end (`ADR-PROC-BUILTIN`)

DORA finds that automated testing and continuous integration — quality produced as part of the work — predict both higher throughput and
higher stability, contradicting the assumption that quality trades against speed.

- [Test automation](https://dora.dev/capabilities/test-automation/) — automated tests build quality into every change instead of inspecting
  it in later.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — gates that run as the work is produced are how quality
  is built in continuously.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — correct-by-construction code, enforced structurally, is what
  keeps change cheap.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Observe the work — make it visible, and go and see (`ADR-PROC-OBSERVEWIP`)

DORA finds that visibility of work across the value stream, visual management, and monitoring are capabilities that distinguish
high-performing teams — seeing the work is a precondition for improving its flow.

- [Visibility of work in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — a rendered end-to-end flow is
  exactly this capability.
- [Visual management](https://dora.dev/capabilities/visual-management/) — making state visible at a glance is the visual factory applied to
  delivery.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — going to see the real running artifact
  depends on real signals from it.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pull work through the system — do not push it (`ADR-PROC-PULLWORK`)

DORA finds that working in small batches and limiting work in progress are among the strongest predictors of short lead time and stable
delivery — the pull discipline measured directly.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the core pull move and the strongest single lever on
  lead time.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — a WIP cap is what turns pull and small batches into an enforced
  mechanism.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — pulling small increments to done on demand is continuous
  delivery in practice.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## The money is lost in the queues — Little's Law and the cost of delay (`ADR-PROC-QUEUECOST`)

DORA's flow metrics — lead time and deployment frequency — are queue measurements, and the practices that improve them are the ones that
drain queues: small batches, low work-in-progress, and elastic infrastructure.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — small batches keep queue length and its cost of
  delay low.
- [Work in process limits](https://dora.dev/capabilities/wip-limits/) — capping work-in-progress is the Little's-Law lever on lead time.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — fast, parallel, cached gates shorten the feedback queue
  every change waits in.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — ephemeral, elastic compute is how machine time is
  spent to drain a human queue.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Inspect and adapt — kaizen built into the process (`ADR-PROC-KAIZEN`)

DORA finds that a learning culture and deliberate experimentation are among the strongest cultural predictors of delivery performance —
inspect-and-adapt, made continuous, is what those capabilities describe.

- [Learning culture](https://dora.dev/capabilities/learning-culture/) — treating the process as something to inspect and improve is a
  learning culture in practice.
- [Team experimentation](https://dora.dev/capabilities/team-experimentation/) — adapting from evidence means running and learning from small
  changes to how the team works.
- [Customer feedback](https://dora.dev/capabilities/customer-feedback/) — the outermost inspect-and-adapt loop closes on what the customer
  actually experiences.
- [Generative organizational culture](https://dora.dev/capabilities/generative-organizational-culture/) — a blameless, evidence-driven
  response to a stopped line is what lets the loop run at all.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
