---
catzc:
  derived:
    path: docs/adr/research/index.md
    kind: adr
    body_sha: "4479ff9ca781"
    links:
      - docs/adr/index.md
      - docs/adr/research/ai-accessible-internal-data.md
      - docs/adr/research/clear-and-communicated-ai-stance.md
      - docs/adr/research/code-maintainability.md
      - docs/adr/research/continuous-delivery.md
      - docs/adr/research/continuous-integration.md
      - docs/adr/research/customer-feedback.md
      - docs/adr/research/database-change-management.md
      - docs/adr/research/deployment-automation.md
      - docs/adr/research/documentation-quality.md
      - docs/adr/research/flexible-infrastructure.md
      - docs/adr/research/generative-organizational-culture.md
      - docs/adr/research/healthy-data-ecosystems.md
      - docs/adr/research/job-satisfaction.md
      - docs/adr/research/learning-culture.md
      - docs/adr/research/loosely-coupled-teams.md
      - docs/adr/research/monitoring-and-observability.md
      - docs/adr/research/monitoring-systems.md
      - docs/adr/research/pervasive-security.md
      - docs/adr/research/platform-engineering.md
      - docs/adr/research/proactive-failure-notification.md
      - docs/adr/research/streamlining-change-approval.md
      - docs/adr/research/team-experimentation.md
      - docs/adr/research/teams-empowered-to-choose-tools.md
      - docs/adr/research/test-automation.md
      - docs/adr/research/test-data-management.md
      - docs/adr/research/transformational-leadership.md
      - docs/adr/research/trunk-based-development.md
      - docs/adr/research/user-centric-focus.md
      - docs/adr/research/version-control.md
      - docs/adr/research/visual-management.md
      - docs/adr/research/well-being.md
      - docs/adr/research/wip-limits.md
      - docs/adr/research/work-visibility-in-value-stream.md
      - docs/adr/research/working-in-small-batches.md
      - docs/references/dora/ai.md#ai-capabilities-model
      - docs/references/dora/capabilities.md#how-the-site-categorizes-capabilities
      - docs/references/dora/capabilities.md#reliability-engineering
      - docs/references/dora/core-model.md
      - docs/references/dora/core-model.md#climate-for-learning
      - docs/references/dora/core-model.md#fast-feedback
      - docs/references/dora/core-model.md#fast-flow
      - docs/references/dora/core-model.md#organizational-performance
      - docs/references/dora/core-model.md#software-delivery-performance
      - docs/references/dora/core-model.md#well-being
      - docs/references/dora/index.md
      - docs/references/dora/index.md#research-program-and-methodology
      - docs/references/dora/metrics.md#instability
      - docs/references/dora/metrics.md#reliability
      - docs/references/dora/metrics.md#throughput
      - "https://dora.dev/capabilities/"
      - "https://dora.dev/research/"
---

# DORA research — capability summaries

This area summarizes [DORA](../../references/dora/index.md) — the research program behind the repository's delivery thinking — as a set of
ADR-style articles, one per capability. Each article carries an `ADR-DORA-<NAME>` rule domain so its findings can be cited like any other
rule in this repository. The articles summarize external research; the repository's own decisions live in the sibling areas (`principles/`,
`process/`, `design/`, and the rest — see the [ADR index](../index.md)).

The research corpus around these articles — the Core Model, the metrics, the full catalogue with each capability's evidence, the AI
Capabilities Model, and every publication — is the [DORA research reference](../../references/dora/index.md). Markdown anywhere in the
repository cites DORA through that reference's stable anchors.

## What DORA is

DORA is a long-running research program into software delivery and organizational performance. It applies behavioural-science methodology to
survey data to trace the predictive pathways that connect ways of working, through software delivery performance, to organizational goals
and individual well-being ([research program and methodology](../../references/dora/index.md#research-program-and-methodology)).

## The DORA Core Model

The [DORA Core Model](../../references/dora/core-model.md) (version 2.1.0) is DORA's conservative distillation of its most replicated
findings: **capabilities** predict **performance**, and performance predicts **outcomes**.

- **Capabilities** are grouped by the benefit they give a team:
  [climate for learning](../../references/dora/core-model.md#climate-for-learning),
  [fast flow](../../references/dora/core-model.md#fast-flow), and [fast feedback](../../references/dora/core-model.md#fast-feedback).
- **Performance** is [software delivery performance](../../references/dora/core-model.md#software-delivery-performance) — measured by five
  metrics in two families, [throughput](../../references/dora/metrics.md#throughput) and
  [instability](../../references/dora/metrics.md#instability) — together with [reliability](../../references/dora/metrics.md#reliability).
- **Outcomes** are [organizational performance](../../references/dora/core-model.md#organizational-performance) and
  [well-being](../../references/dora/core-model.md#well-being).

DORA also publishes a separate [AI Capabilities Model](../../references/dora/ai.md#ai-capabilities-model), in which a set of capabilities
amplify the effect of AI adoption on outcomes. Each article's "Dora explains" section places its capability in these models and names the
publications its evidence comes from.

## The capabilities

The catalogue below follows the categories dora.dev itself assigns
([how the site categorizes capabilities](../../references/dora/capabilities.md#how-the-site-categorizes-capabilities)). Each entry links to
its summary article and rule domain.

### AI

- [AI-accessible internal data](ai-accessible-internal-data.md) — `ADR-DORA-AIDATA`
- [Clear and communicated AI stance](clear-and-communicated-ai-stance.md) — `ADR-DORA-AISTANCE`
- [Healthy data ecosystems](healthy-data-ecosystems.md) — `ADR-DORA-DATAECO`
- [Platform engineering](platform-engineering.md) — `ADR-DORA-PLATFORM`
- [User-centric focus](user-centric-focus.md) — `ADR-DORA-USERFOCUS`

### Climate for learning

- [Code maintainability](code-maintainability.md) — `ADR-DORA-MAINTAIN`
- [Documentation quality](documentation-quality.md) — `ADR-DORA-DOCS`
- [Empowering teams to choose tools](teams-empowered-to-choose-tools.md) — `ADR-DORA-TOOLCHOICE`
- [Generative organizational culture](generative-organizational-culture.md) — `ADR-DORA-CULTURE`
- [Job satisfaction](job-satisfaction.md) — `ADR-DORA-JOBSAT`
- [Learning culture](learning-culture.md) — `ADR-DORA-LEARNING`
- [Team experimentation](team-experimentation.md) — `ADR-DORA-EXPERIMENT`
- [Transformational leadership](transformational-leadership.md) — `ADR-DORA-LEADERSHIP`
- [Well-being](well-being.md) — `ADR-DORA-WELLBEING`

### Fast flow

- [Continuous delivery](continuous-delivery.md) — `ADR-DORA-CD`
- [Database change management](database-change-management.md) — `ADR-DORA-DBCHANGE`
- [Deployment automation](deployment-automation.md) — `ADR-DORA-DEPLOY`
- [Flexible infrastructure](flexible-infrastructure.md) — `ADR-DORA-FLEXINFRA`
- [Loosely coupled teams](loosely-coupled-teams.md) — `ADR-DORA-LOOSETEAMS`
- [Streamlining change approval](streamlining-change-approval.md) — `ADR-DORA-APPROVAL`
- [Trunk-based development](trunk-based-development.md) — `ADR-DORA-TRUNK`
- [Version control](version-control.md) — `ADR-DORA-VCS`
- [Visual management](visual-management.md) — `ADR-DORA-VISUAL`
- [Work in process limits](wip-limits.md) — `ADR-DORA-WIP`
- [Working in small batches](working-in-small-batches.md) — `ADR-DORA-SMALLBATCH`

### Fast feedback

- [Continuous integration](continuous-integration.md) — `ADR-DORA-CI`
- [Customer feedback](customer-feedback.md) — `ADR-DORA-FEEDBACK`
- [Monitoring and observability](monitoring-and-observability.md) — `ADR-DORA-OBSERV`
- [Monitoring systems to inform business decisions](monitoring-systems.md) — `ADR-DORA-MONITOR`
- [Pervasive security](pervasive-security.md) — `ADR-DORA-SECURITY`
- [Proactive failure notification](proactive-failure-notification.md) — `ADR-DORA-FAILALERT`
- [Test automation](test-automation.md) — `ADR-DORA-TESTAUTO`
- [Test data management](test-data-management.md) — `ADR-DORA-TESTDATA`
- [Visibility of work in the value stream](work-visibility-in-value-stream.md) — `ADR-DORA-WORKVIS`

The Core Model's fast-feedback group also names [reliability engineering](../../references/dora/capabilities.md#reliability-engineering),
which has no capability page on dora.dev and therefore no summary article here.

## References

The authoritative source is the DORA research program at <https://dora.dev/research/> and the capability catalogue at
<https://dora.dev/capabilities/>. Each article cites the specific capability page it summarizes.
