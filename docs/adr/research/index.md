# DORA research — capability summaries

This area summarizes [DORA](https://dora.dev/research/) — the DevOps Research and Assessment program — as a set of ADR-style articles, one
per capability. Each article carries an `ADR-DORA<code>` rule domain so its findings can be cited like any other rule in this repository.
The articles summarize external research; the repository's own decisions live in the sibling areas (`principles/`, `process/`, `design/`,
and the rest — see the [ADR index](../index.md)).

## What DORA is

DORA is "the longest running academically rigorous research investigation of its kind" into software delivery and organizational
performance. It applies behavioural-science methodology to uncover the predictive pathways that connect ways of working, through software
delivery performance, to organizational goals and individual well-being.

## The DORA Core Model

DORA expresses its most firmly-established findings as the **DORA Core Model** — a collection of _capabilities_, _metrics_, and _outcomes_.
The model is a directed set of relationships: technical, process, and cultural **capabilities** drive **software delivery performance**,
which in turn drives **organizational outcomes** and **well-being**. The Core Model deliberately trails the leading edge of the research,
evolving conservatively so it is safe to use as a practitioner guide.

- **Capabilities** are the practices a team can adopt — version control, continuous delivery, a generative culture, and the rest catalogued
  below. They are the levers.
- **Metrics** are how delivery performance is measured — throughput (change lead time, deployment frequency) and stability (change fail
  rate, failed-deployment recovery time). Each capability article's "Dora explains" section ties the capability back to these metrics.
- **Outcomes** are what improved delivery performance produces — organizational performance and reduced burnout.

## The capabilities

The catalogue groups the capabilities four ways. Each links to its summary article and rule domain.

### AI-focused

- [Version control](version-control.md) — `ADR-DORA-VCS`
- [Working in small batches](working-in-small-batches.md) — `ADR-DORA-SMALLBATCH`
- [Platform engineering](platform-engineering.md) — `ADR-DORA-PLATFORM`
- [User-centric focus](user-centric-focus.md) — `ADR-DORA-USERFOCUS`
- [AI-accessible internal data](ai-accessible-internal-data.md) — `ADR-DORA-AIDATA`
- [Clear and communicated AI stance](clear-and-communicated-ai-stance.md) — `ADR-DORA-AISTANCE`
- [Healthy data ecosystems](healthy-data-ecosystems.md) — `ADR-DORA-DATAECO`

### Technical

- [Code maintainability](code-maintainability.md) — `ADR-DORA-MAINTAIN`
- [Continuous delivery](continuous-delivery.md) — `ADR-DORA-CD`
- [Continuous integration](continuous-integration.md) — `ADR-DORA-CI`
- [Database change management](database-change-management.md) — `ADR-DORA-DBCHANGE`
- [Deployment automation](deployment-automation.md) — `ADR-DORA-DEPLOY`
- [Documentation quality](documentation-quality.md) — `ADR-DORA-DOCS`
- [Flexible infrastructure](flexible-infrastructure.md) — `ADR-DORA-FLEXINFRA`
- [Loosely coupled teams](loosely-coupled-teams.md) — `ADR-DORA-LOOSETEAMS`
- [Monitoring and observability](monitoring-and-observability.md) — `ADR-DORA-OBSERV`
- [Pervasive security](pervasive-security.md) — `ADR-DORA-SECURITY`
- [Streamlining change approval](streamlining-change-approval.md) — `ADR-DORA-APPROVAL`
- [Test automation](test-automation.md) — `ADR-DORA-TESTAUTO`
- [Test data management](test-data-management.md) — `ADR-DORA-TESTDATA`
- [Trunk-based development](trunk-based-development.md) — `ADR-DORA-TRUNK`

### Process and measurement

- [Customer feedback](customer-feedback.md) — `ADR-DORA-FEEDBACK`
- [Monitoring systems to inform business decisions](monitoring-systems.md) — `ADR-DORA-MONITOR`
- [Proactive failure notification](proactive-failure-notification.md) — `ADR-DORA-FAILALERT`
- [Visibility of work in the value stream](work-visibility-in-value-stream.md) — `ADR-DORA-WORKVIS`
- [Visual management](visual-management.md) — `ADR-DORA-VISUAL`
- [Work in process limits](wip-limits.md) — `ADR-DORA-WIP`

### Organizational and cultural

- [Empowering teams to choose tools](teams-empowered-to-choose-tools.md) — `ADR-DORA-TOOLCHOICE`
- [Generative organizational culture](generative-organizational-culture.md) — `ADR-DORA-CULTURE`
- [Job satisfaction](job-satisfaction.md) — `ADR-DORA-JOBSAT`
- [Learning culture](learning-culture.md) — `ADR-DORA-LEARNING`
- [Team experimentation](team-experimentation.md) — `ADR-DORA-EXPERIMENT`
- [Transformational leadership](transformational-leadership.md) — `ADR-DORA-LEADERSHIP`
- [Well-being](well-being.md) — `ADR-DORA-WELLBEING`

## References

The authoritative source is the DORA research program at <https://dora.dev/research/> and the capability catalogue at
<https://dora.dev/capabilities/>. Each article cites the specific capability page it summarizes.
