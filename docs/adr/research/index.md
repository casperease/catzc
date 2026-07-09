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

- [Version control](version-control.md) — `ADR-DORAVC`
- [Working in small batches](working-in-small-batches.md) — `ADR-DORASB`
- [Platform engineering](platform-engineering.md) — `ADR-DORAPE`
- [User-centric focus](user-centric-focus.md) — `ADR-DORAUCF`
- [AI-accessible internal data](ai-accessible-internal-data.md) — `ADR-DORAAID`
- [Clear and communicated AI stance](clear-and-communicated-ai-stance.md) — `ADR-DORAAIS`
- [Healthy data ecosystems](healthy-data-ecosystems.md) — `ADR-DORAHDE`

### Technical

- [Code maintainability](code-maintainability.md) — `ADR-DORACM`
- [Continuous delivery](continuous-delivery.md) — `ADR-DORACD`
- [Continuous integration](continuous-integration.md) — `ADR-DORACI`
- [Database change management](database-change-management.md) — `ADR-DORADCM`
- [Deployment automation](deployment-automation.md) — `ADR-DORADA`
- [Documentation quality](documentation-quality.md) — `ADR-DORADQ`
- [Flexible infrastructure](flexible-infrastructure.md) — `ADR-DORAFI`
- [Loosely coupled teams](loosely-coupled-teams.md) — `ADR-DORALCT`
- [Monitoring and observability](monitoring-and-observability.md) — `ADR-DORAMO`
- [Pervasive security](pervasive-security.md) — `ADR-DORAPS`
- [Streamlining change approval](streamlining-change-approval.md) — `ADR-DORASCA`
- [Test automation](test-automation.md) — `ADR-DORATA`
- [Test data management](test-data-management.md) — `ADR-DORATDM`
- [Trunk-based development](trunk-based-development.md) — `ADR-DORATBD`

### Process and measurement

- [Customer feedback](customer-feedback.md) — `ADR-DORACF`
- [Monitoring systems to inform business decisions](monitoring-systems.md) — `ADR-DORAMS`
- [Proactive failure notification](proactive-failure-notification.md) — `ADR-DORAPFN`
- [Visibility of work in the value stream](work-visibility-in-value-stream.md) — `ADR-DORAWV`
- [Visual management](visual-management.md) — `ADR-DORAVM`
- [Work in process limits](wip-limits.md) — `ADR-DORAWIP`

### Organizational and cultural

- [Empowering teams to choose tools](teams-empowered-to-choose-tools.md) — `ADR-DORAECT`
- [Generative organizational culture](generative-organizational-culture.md) — `ADR-DORAGOC`
- [Job satisfaction](job-satisfaction.md) — `ADR-DORAJS`
- [Learning culture](learning-culture.md) — `ADR-DORALC`
- [Team experimentation](team-experimentation.md) — `ADR-DORATE`
- [Transformational leadership](transformational-leadership.md) — `ADR-DORATL`
- [Well-being](well-being.md) — `ADR-DORAWB`

## References

The authoritative source is the DORA research program at <https://dora.dev/research/> and the capability catalogue at
<https://dora.dev/capabilities/>. Each article cites the specific capability page it summarizes.
