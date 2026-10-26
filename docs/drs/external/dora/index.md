# EDR: DORA — capability summaries

This area summarizes [DORA](../../../references/dora/index.md) — the research program behind the repository's delivery thinking — as a set
of external records, one per capability. Each article carries an `EDR-DORA-<NAME>` rule domain so its findings can be cited like any other
rule in this repository. The articles summarize external research; the repository's own decisions live in the sibling areas (`principles/`,
`process/`, `design/`, and the rest — see the [DRS index](../../index.md)).

The research corpus around these articles — the Core Model, the metrics, the full catalogue with each capability's evidence, the AI
Capabilities Model, and every publication — is the [DORA research reference](../../../references/dora/index.md). Markdown anywhere in the
repository cites DORA through that reference's stable anchors.

## What DORA is

DORA is a long-running research program into software delivery and organizational performance. It applies behavioural-science methodology to
survey data to trace the predictive pathways that connect ways of working, through software delivery performance, to organizational goals
and individual well-being ([research program and methodology](../../../references/dora/index.md#research-program-and-methodology)).

## The DORA Core Model

The [DORA Core Model](../../../references/dora/core-model.md) (version 2.1.0) is DORA's conservative distillation of its most replicated
findings: **capabilities** predict **performance**, and performance predicts **outcomes**.

- **Capabilities** are grouped by the benefit they give a team:
  [climate for learning](../../../references/dora/core-model.md#climate-for-learning),
  [fast flow](../../../references/dora/core-model.md#fast-flow), and [fast feedback](../../../references/dora/core-model.md#fast-feedback).
- **Performance** is [software delivery performance](../../../references/dora/core-model.md#software-delivery-performance) — measured by
  five metrics in two families, [throughput](../../../references/dora/metrics.md#throughput) and
  [instability](../../../references/dora/metrics.md#instability) — together with
  [reliability](../../../references/dora/metrics.md#reliability).
- **Outcomes** are [organizational performance](../../../references/dora/core-model.md#organizational-performance) and
  [well-being](../../../references/dora/core-model.md#well-being).

DORA also publishes a separate [AI Capabilities Model](../../../references/dora/ai.md#ai-capabilities-model), in which a set of capabilities
amplify the effect of AI adoption on outcomes. Each article's "Dora explains" section places its capability in these models and names the
publications its evidence comes from.

## The capabilities

The catalogue below follows the categories dora.dev itself assigns
([how the site categorizes capabilities](../../../references/dora/capabilities.md#how-the-site-categorizes-capabilities)). Each entry links
to its summary article and rule domain.

### AI

- [AI-accessible internal data](ai-accessible-internal-data.md) — `EDR-DORA-AIDATA`
- [Clear and communicated AI stance](clear-and-communicated-ai-stance.md) — `EDR-DORA-AISTANCE`
- [Healthy data ecosystems](healthy-data-ecosystems.md) — `EDR-DORA-DATAECO`
- [Platform engineering](platform-engineering.md) — `EDR-DORA-PLATFORM`
- [User-centric focus](user-centric-focus.md) — `EDR-DORA-USERFOCUS`

### Climate for learning

- [Code maintainability](code-maintainability.md) — `EDR-DORA-MAINTAIN`
- [Documentation quality](documentation-quality.md) — `EDR-DORA-DOCS`
- [Empowering teams to choose tools](teams-empowered-to-choose-tools.md) — `EDR-DORA-TOOLCHOICE`
- [Generative organizational culture](generative-organizational-culture.md) — `EDR-DORA-CULTURE`
- [Job satisfaction](job-satisfaction.md) — `EDR-DORA-JOBSAT`
- [Learning culture](learning-culture.md) — `EDR-DORA-LEARNING`
- [Team experimentation](team-experimentation.md) — `EDR-DORA-EXPERIMENT`
- [Transformational leadership](transformational-leadership.md) — `EDR-DORA-LEADERSHIP`
- [Well-being](well-being.md) — `EDR-DORA-WELLBEING`

### Fast flow

- [Continuous delivery](continuous-delivery.md) — `EDR-DORA-CD`
- [Database change management](database-change-management.md) — `EDR-DORA-DBCHANGE`
- [Deployment automation](deployment-automation.md) — `EDR-DORA-DEPLOY`
- [Flexible infrastructure](flexible-infrastructure.md) — `EDR-DORA-FLEXINFRA`
- [Loosely coupled teams](loosely-coupled-teams.md) — `EDR-DORA-LOOSETEAMS`
- [Streamlining change approval](streamlining-change-approval.md) — `EDR-DORA-APPROVAL`
- [Trunk-based development](trunk-based-development.md) — `EDR-DORA-TRUNK`
- [Version control](version-control.md) — `EDR-DORA-VCS`
- [Visual management](visual-management.md) — `EDR-DORA-VISUAL`
- [Work in process limits](wip-limits.md) — `EDR-DORA-WIP`
- [Working in small batches](working-in-small-batches.md) — `EDR-DORA-SMALLBATCH`

### Fast feedback

- [Continuous integration](continuous-integration.md) — `EDR-DORA-CI`
- [Customer feedback](customer-feedback.md) — `EDR-DORA-FEEDBACK`
- [Monitoring and observability](monitoring-and-observability.md) — `EDR-DORA-OBSERV`
- [Monitoring systems to inform business decisions](monitoring-systems.md) — `EDR-DORA-MONITOR`
- [Pervasive security](pervasive-security.md) — `EDR-DORA-SECURITY`
- [Proactive failure notification](proactive-failure-notification.md) — `EDR-DORA-FAILALERT`
- [Test automation](test-automation.md) — `EDR-DORA-TESTAUTO`
- [Test data management](test-data-management.md) — `EDR-DORA-TESTDATA`
- [Visibility of work in the value stream](work-visibility-in-value-stream.md) — `EDR-DORA-WORKVIS`

The Core Model's fast-feedback group also names [reliability engineering](../../../references/dora/capabilities.md#reliability-engineering),
which has no capability page on dora.dev and therefore no summary article here.

## References

The authoritative source is the DORA research program at <https://dora.dev/research/> and the capability catalogue at
<https://dora.dev/capabilities/>. Each article cites the specific capability page it summarizes.
