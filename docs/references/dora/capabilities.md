# DORA capability catalogue

dora.dev publishes 34 capability pages under [/capabilities/](https://dora.dev/capabilities/). This file has one entry per page, plus one
Core Model capability that has no page. Each entry heading produces an anchor equal to the dora.dev slug, so `capabilities.md#<dora-slug>`
always resolves. See [how to cross-reference](index.md#how-to-cross-reference).

## How the site categorizes capabilities

The catalogue page itself is an alphabetical grid. Each card can carry two tags: `core` (links to the Core Model) and `AI` (links to the AI
Capabilities Model). The page shows no category headings. Every capability page does, however, declare a **category** in the site's source,
and the [Core Model](core-model.md) uses the same names for its capability groups. There are four categories:

| Category                                      | Meaning on the site                                                              | Count |
| --------------------------------------------- | -------------------------------------------------------------------------------- | ----- |
| [AI](#ai)                                     | Capabilities introduced with the AI Capabilities Model (December 2025)           | 5     |
| [Climate for learning](#climate-for-learning) | Culture, leadership, people, and knowledge capabilities                          | 9     |
| [Fast flow](#fast-flow)                       | Capabilities that let changes move to production quickly and safely              | 11    |
| [Fast feedback](#fast-feedback)               | Capabilities that return rapid, actionable signal on changes, systems, and users | 9     |

This file groups entries by those four categories. That is the only grouping the site defines for all 34 pages. Two capabilities,
[version control](#version-control) and [working in small batches](#working-in-small-batches), carry the `AI` tag but are categorized as
fast flow. Their `AI` tag records that they are also members of the AI Capabilities Model.

Each entry gives:

- **Page**: the dora.dev URL, plus the site's full title where it differs from the heading.
- **Category, tags, models**: the site category, the catalogue tags, and membership of the Core Model v2.1.0 and the
  [AI Capabilities Model](ai.md#ai-capabilities-model).
- **Definition**: a one-line paraphrase.
- **Predicts or drives**: what the page (or a linked DORA report page) says the capability predicts, drives, or amplifies.
- **Evidence**: the report years the site attributes the finding to, linked to [publications.md](publications.md). "On page" means the
  capability page cites that year; "report page" means the report's own archive page names the capability.
- **Repo ADR**: the repository's summary ADR and its rule code.

## Summary

| Capability                                                              | Category             | Tags     | Core Model           | Repo ADR                                                                     |
| ----------------------------------------------------------------------- | -------------------- | -------- | -------------------- | ---------------------------------------------------------------------------- |
| [AI-accessible internal data](#ai-accessible-internal-data)             | AI                   | AI       | not in Core          | [ADR-DORA-AIDATA](../../adr/research/ai-accessible-internal-data.md)         |
| [Clear and communicated AI stance](#clear-and-communicated-ai-stance)   | AI                   | AI       | not in Core          | [ADR-DORA-AISTANCE](../../adr/research/clear-and-communicated-ai-stance.md)  |
| [Healthy data ecosystems](#healthy-data-ecosystems)                     | AI                   | AI       | not in Core          | [ADR-DORA-DATAECO](../../adr/research/healthy-data-ecosystems.md)            |
| [Platform engineering](#platform-engineering)                           | AI                   | AI       | not in Core          | [ADR-DORA-PLATFORM](../../adr/research/platform-engineering.md)              |
| [User-centric focus](#user-centric-focus)                               | AI                   | AI       | not in Core          | [ADR-DORA-USERFOCUS](../../adr/research/user-centric-focus.md)               |
| [Code maintainability](#code-maintainability)                           | Climate for learning | core     | climate for learning | [ADR-DORA-MAINTAIN](../../adr/research/code-maintainability.md)              |
| [Documentation quality](#documentation-quality)                         | Climate for learning | core     | climate for learning | [ADR-DORA-DOCS](../../adr/research/documentation-quality.md)                 |
| [Generative organizational culture](#generative-organizational-culture) | Climate for learning | core     | climate for learning | [ADR-DORA-CULTURE](../../adr/research/generative-organizational-culture.md)  |
| [Job satisfaction](#job-satisfaction)                                   | Climate for learning | core     | outcome (well-being) | [ADR-DORA-JOBSAT](../../adr/research/job-satisfaction.md)                    |
| [Learning culture](#learning-culture)                                   | Climate for learning | none     | not in Core          | [ADR-DORA-LEARNING](../../adr/research/learning-culture.md)                  |
| [Team experimentation](#team-experimentation)                           | Climate for learning | none     | not in Core          | [ADR-DORA-EXPERIMENT](../../adr/research/team-experimentation.md)            |
| [Teams empowered to choose tools](#teams-empowered-to-choose-tools)     | Climate for learning | core     | climate for learning | [ADR-DORA-TOOLCHOICE](../../adr/research/teams-empowered-to-choose-tools.md) |
| [Transformational leadership](#transformational-leadership)             | Climate for learning | none     | not in Core          | [ADR-DORA-LEADERSHIP](../../adr/research/transformational-leadership.md)     |
| [Well-being](#well-being)                                               | Climate for learning | core     | outcome              | [ADR-DORA-WELLBEING](../../adr/research/well-being.md)                       |
| [Continuous delivery](#continuous-delivery)                             | Fast flow            | core     | fast flow            | [ADR-DORA-CD](../../adr/research/continuous-delivery.md)                     |
| [Database change management](#database-change-management)               | Fast flow            | core     | fast flow            | [ADR-DORA-DBCHANGE](../../adr/research/database-change-management.md)        |
| [Deployment automation](#deployment-automation)                         | Fast flow            | core     | fast flow            | [ADR-DORA-DEPLOY](../../adr/research/deployment-automation.md)               |
| [Flexible infrastructure](#flexible-infrastructure)                     | Fast flow            | core     | fast flow            | [ADR-DORA-FLEXINFRA](../../adr/research/flexible-infrastructure.md)          |
| [Loosely coupled teams](#loosely-coupled-teams)                         | Fast flow            | core     | fast flow            | [ADR-DORA-LOOSETEAMS](../../adr/research/loosely-coupled-teams.md)           |
| [Streamlining change approval](#streamlining-change-approval)           | Fast flow            | core     | fast flow            | [ADR-DORA-APPROVAL](../../adr/research/streamlining-change-approval.md)      |
| [Trunk-based development](#trunk-based-development)                     | Fast flow            | none     | removed in V2        | [ADR-DORA-TRUNK](../../adr/research/trunk-based-development.md)              |
| [Version control](#version-control)                                     | Fast flow            | core, AI | fast flow            | [ADR-DORA-VCS](../../adr/research/version-control.md)                        |
| [Visual management](#visual-management)                                 | Fast flow            | none     | not in Core          | [ADR-DORA-VISUAL](../../adr/research/visual-management.md)                   |
| [WIP limits](#wip-limits)                                               | Fast flow            | none     | not in Core          | [ADR-DORA-WIP](../../adr/research/wip-limits.md)                             |
| [Working in small batches](#working-in-small-batches)                   | Fast flow            | core, AI | fast flow            | [ADR-DORA-SMALLBATCH](../../adr/research/working-in-small-batches.md)        |
| [Continuous integration](#continuous-integration)                       | Fast feedback        | core     | fast feedback        | [ADR-DORA-CI](../../adr/research/continuous-integration.md)                  |
| [Customer feedback](#customer-feedback)                                 | Fast feedback        | none     | not in Core          | [ADR-DORA-FEEDBACK](../../adr/research/customer-feedback.md)                 |
| [Monitoring and observability](#monitoring-and-observability)           | Fast feedback        | core     | fast feedback        | [ADR-DORA-OBSERV](../../adr/research/monitoring-and-observability.md)        |
| [Monitoring systems](#monitoring-systems)                               | Fast feedback        | none     | not in Core          | [ADR-DORA-MONITOR](../../adr/research/monitoring-systems.md)                 |
| [Pervasive security](#pervasive-security)                               | Fast feedback        | core     | fast feedback        | [ADR-DORA-SECURITY](../../adr/research/pervasive-security.md)                |
| [Proactive failure notification](#proactive-failure-notification)       | Fast feedback        | none     | not in Core          | [ADR-DORA-FAILALERT](../../adr/research/proactive-failure-notification.md)   |
| [Test automation](#test-automation)                                     | Fast feedback        | core     | fast feedback        | [ADR-DORA-TESTAUTO](../../adr/research/test-automation.md)                   |
| [Test data management](#test-data-management)                           | Fast feedback        | core     | fast feedback        | [ADR-DORA-TESTDATA](../../adr/research/test-data-management.md)              |
| [Work visibility in value stream](#work-visibility-in-value-stream)     | Fast feedback        | none     | not in Core          | [ADR-DORA-WORKVIS](../../adr/research/work-visibility-in-value-stream.md)    |
| [Reliability engineering](#reliability-engineering)                     | (no page)            | (none)   | fast feedback        | none                                                                         |

## AI

The five capabilities DORA introduced in December 2025 alongside the AI Capabilities Model. Each is defined by how it changes AI adoption's
effect on outcomes. See [ai.md](ai.md) for the model's connections.

### AI-accessible internal data

- **Page:** <https://dora.dev/capabilities/ai-accessible-internal-data/>
- **Category, tags, models:** AI · `AI` · AI Capabilities Model.
- **Definition:** securely connecting AI tools to the organization's own code, documentation, and operational data so their answers are
  context-aware. The page calls the practice "context engineering".
- **Predicts or drives:** amplifies AI adoption's positive effect on individual effectiveness and code quality. In the model diagram it is
  also connected to product performance. The page lists its risks as delivery instability when small batches are neglected, copied
  deprecated patterns, and data exposure.
- **Evidence:** [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) and
  [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page).
- **Repo ADR:** [ADR-DORA-AIDATA](../../adr/research/ai-accessible-internal-data.md)

### Clear and communicated AI stance

- **Page:** <https://dora.dev/capabilities/clear-and-communicated-ai-stance/>
- **Category, tags, models:** AI · `AI` · AI Capabilities Model ("Clear + communicated AI stance").
- **Definition:** an official, widely understood organizational position on how developers may use AI: which tools are allowed, which data
  is safe to use, and that experimentation is supported.
- **Predicts or drives:** amplifies AI's positive effect on individual effectiveness, organizational performance, and software delivery
  throughput. It also turns AI's otherwise neutral effect on friction into a reduction in friction. The model diagram adds product
  performance.
- **Evidence:** [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) and
  [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page). Earlier work:
  [2025 Impact of Generative AI](publications.md#2025-impact-of-generative-ai-in-software-development) found clear acceptable-use policies
  associated with a 451% increase in AI adoption (report page), and the
  [2024 AI preview](publications.md#2024-accelerate-state-of-devops-report) found mixed views of organizational transparency about AI.
- **Repo ADR:** [ADR-DORA-AISTANCE](../../adr/research/clear-and-communicated-ai-stance.md)

### Healthy data ecosystems

- **Page:** <https://dora.dev/capabilities/healthy-data-ecosystems/>
- **Category, tags, models:** AI · `AI` · AI Capabilities Model.
- **Definition:** internal data that is high-quality, trustworthy, unified, and easy for both people and tools to reach, treated as a
  product rather than a by-product. The page calls it a prerequisite for AI adoption.
- **Predicts or drives:** significantly amplifies AI adoption's positive effect on organizational performance. With fragmented data, AI
  produces wrong answers faster.
- **Evidence:** [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) and
  [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page). The page also lists the
  [2016](publications.md#2016-state-of-devops-report) and [2017](publications.md#2017-state-of-devops-report) reports as further reading.
- **Repo ADR:** [ADR-DORA-DATAECO](../../adr/research/healthy-data-ecosystems.md)

### Platform engineering

- **Page:** <https://dora.dev/capabilities/platform-engineering/>
- **Category, tags, models:** AI · `AI` · AI Capabilities Model ("Quality internal platform").
- **Definition:** designing and building self-service toolchains and workflows, usually delivered as an internal developer platform that
  covers an application's whole operational lifecycle.
- **Predicts or drives:** platform quality gates AI's value. With a high-quality platform, AI adoption's effect on organizational
  performance is strong and positive; with a low-quality one, it is negligible. Platforms improve productivity and organizational
  performance but can lower throughput and change stability if not managed carefully. The model diagram connects it to reduced friction and
  organizational performance.
- **Evidence:** [2024](publications.md#2024-accelerate-state-of-devops-report): 89% of respondents use an internal developer platform;
  platform users see an 8% decrease in throughput; productivity rises 5% when users can finish tasks without an enabling team (infographic).
  [2025](publications.md#2025-state-of-ai-assisted-software-development): 90% of organizations use a platform and 76% have dedicated
  platform teams, and "clear feedback on the outcome of my tasks" is the platform trait most correlated with a positive experience (on
  page). [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page).
- **Repo ADR:** [ADR-DORA-PLATFORM](../../adr/research/platform-engineering.md)

### User-centric focus

- **Page:** <https://dora.dev/capabilities/user-centric-focus/>
- **Category, tags, models:** AI · `AI` · AI Capabilities Model.
- **Definition:** how far teams prioritize the needs, feedback, and experience of the people who use their software. It keeps AI-accelerated
  velocity pointed at valuable outcomes.
- **Predicts or drives:** higher organizational performance and job satisfaction. With AI, a strong user focus amplifies effectiveness and
  team performance; without one, AI adoption can harm team performance (the "feature factory" trap). The model diagram connects it to team
  performance.
- **Evidence:** [2023](publications.md#2023-accelerate-state-of-devops-report): 40% higher organizational performance (report page; repeated
  in 2024). [2024](publications.md#2024-accelerate-state-of-devops-report): more productive, more satisfied, and less burnout (report page).
  [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) and
  [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page).
- **Repo ADR:** [ADR-DORA-USERFOCUS](../../adr/research/user-centric-focus.md)

## Climate for learning

Culture, leadership, people, and knowledge. In the Core Model the group contains code maintainability, documentation quality, empowering
teams to choose tools, and generative culture. The site's category field also places job satisfaction, learning culture, team
experimentation, transformational leadership, and well-being here.

### Code maintainability

- **Page:** <https://dora.dev/capabilities/code-maintainability/>
- **Category, tags, models:** climate for learning · `core` · Core Model (climate for learning).
- **Definition:** systems and tools that make it easy to change code other teams own, find examples, reuse code, and add or upgrade
  dependencies without breaking things.
- **Predicts or drives:** contributes to [continuous delivery](#continuous-delivery), one of the technical practices that predict it.
- **Evidence:** [2019](publications.md#2019-accelerate-state-of-devops-report) (on page).
- **Repo ADR:** [ADR-DORA-MAINTAIN](../../adr/research/code-maintainability.md)

### Documentation quality

- **Page:** <https://dora.dev/capabilities/documentation-quality/>
- **Category, tags, models:** climate for learning · `core` · Core Model (climate for learning).
- **Definition:** accurate, well-organized, user-centred internal documentation, kept up by practices such as documenting critical use
  cases, owning and updating docs, and recognizing documentation work.
- **Predicts or drives:** linked to organizational performance, and it amplifies how much every technical capability lifts organizational
  performance. Lift figures from the 2022 data, below versus above average documentation quality: trunk-based development 36% versus 1525%,
  continuous integration 34% versus 750%, continuous delivery 63% versus 656%, supply-chain security 37% versus 451%, SRE 79% versus 343%,
  loosely coupled teams 46% versus 313%, version control 27% versus 278% (on page). It also drives the implementation of technical
  practices.
- **Evidence:** [2021](publications.md#2021-accelerate-state-of-devops-report) (first measured; on page and report page),
  [2022](publications.md#2022-accelerate-state-of-devops-report) (on page), [2023](publications.md#2023-accelerate-state-of-devops-report)
  (report page), [2024](publications.md#2024-accelerate-state-of-devops-report) (a 25% increase in AI adoption is associated with a 7.5%
  rise in documentation quality; infographic).
- **Repo ADR:** [ADR-DORA-DOCS](../../adr/research/documentation-quality.md)

### Generative organizational culture

- **Page:** <https://dora.dev/capabilities/generative-organizational-culture/>
- **Category, tags, models:** climate for learning · `core` · Core Model (climate for learning, labelled "Generative culture").
- **Definition:** a high-trust, performance-oriented culture with good information flow, measured with Ron Westrum's typology (pathological,
  bureaucratic, generative).
- **Predicts or drives:** software delivery performance, organizational performance, and lower burnout. Psychological safety predicts
  delivery performance, organizational performance, and productivity.
- **Evidence:** [2014](publications.md#2014-state-of-devops-report) (culture a strong predictor; report page),
  [2018](publications.md#2018-accelerate-state-of-devops-report) (report page),
  [2019](publications.md#2019-accelerate-state-of-devops-report) (psychological safety; on page),
  [2021](publications.md#2021-accelerate-state-of-devops-report) (mitigates burnout; report page),
  [2022](publications.md#2022-accelerate-state-of-devops-report) (high-trust, low-blame cultures and security practices; report page),
  [2023](publications.md#2023-accelerate-state-of-devops-report) (30% higher organizational performance; report page). The Quick Check names
  it one of three capabilities worth assessing first.
- **Repo ADR:** [ADR-DORA-CULTURE](../../adr/research/generative-organizational-culture.md)

### Job satisfaction

- **Page:** <https://dora.dev/capabilities/job-satisfaction/>
- **Category, tags, models:** climate for learning · `core` · Core Model (an **outcome** under well-being, not a capability).
- **Definition:** doing challenging, meaningful work and being trusted to use one's skills and judgment.
- **Predicts or drives:** organizational performance. The page describes a virtuous circle: better work produces higher delivery
  performance, which produces higher organizational performance. [Continuous delivery](#continuous-delivery) and
  [teams empowered to choose tools](#teams-empowered-to-choose-tools) feed it.
- **Evidence:** [2014](publications.md#2014-state-of-devops-report) (the number one predictor of organizational performance; report page),
  [2024](publications.md#2024-accelerate-state-of-devops-report) (AI adoption and transformational leadership raise it; report page),
  [2025 Impact of Generative AI](publications.md#2025-impact-of-generative-ai-in-software-development) (heavy AI users report higher job
  satisfaction; report page).
- **Repo ADR:** [ADR-DORA-JOBSAT](../../adr/research/job-satisfaction.md)

### Learning culture

- **Page:** <https://dora.dev/capabilities/learning-culture/>
- **Category, tags, models:** climate for learning · no tags · not in Core, although the Core group is named "climate for learning".
- **Definition:** how much an organization values learning: whether it treats learning as essential to progress and as an investment rather
  than a cost.
- **Predicts or drives:** software delivery performance (higher deployment frequency; shorter lead time, time to restore, and lower change
  fail rate), strong team culture, and organizational performance.
- **Evidence:** the page cites no report year.
- **Repo ADR:** [ADR-DORA-LEARNING](../../adr/research/learning-culture.md)

### Team experimentation

- **Page:** <https://dora.dev/capabilities/team-experimentation/>
- **Category, tags, models:** climate for learning · no tags · not in Core.
- **Definition:** teams able to work on new ideas, and to write and change specifications and stories during development, without permission
  from outside the team.
- **Predicts or drives:** part of lean product management. Together with work visibility, small batches, and customer feedback, it predicts
  software delivery performance and organizational performance.
- **Evidence:** the page cites no year. The lean product management findings it summarizes appear in
  [2016](publications.md#2016-state-of-devops-report) (an experimental approach to product development) and
  [2017](publications.md#2017-state-of-devops-report) (report pages).
- **Repo ADR:** [ADR-DORA-EXPERIMENT](../../adr/research/team-experimentation.md)

### Teams empowered to choose tools

- **Page:** <https://dora.dev/capabilities/teams-empowered-to-choose-tools/> (site title: "Empowering teams to choose tools")
- **Category, tags, models:** climate for learning · `core` · Core Model (climate for learning).
- **Definition:** teams make informed choices about the tools and technologies they use for their work.
- **Predicts or drives:** better continuous delivery, higher software delivery performance, and higher job satisfaction.
- **Evidence:** [2017](publications.md#2017-state-of-devops-report) (on page).
- **Repo ADR:** [ADR-DORA-TOOLCHOICE](../../adr/research/teams-empowered-to-choose-tools.md)

### Transformational leadership

- **Page:** <https://dora.dev/capabilities/transformational-leadership/>
- **Category, tags, models:** climate for learning · no tags · not in Core.
- **Definition:** leadership showing five characteristics: vision, inspirational communication, intellectual stimulation, supportive
  leadership, and personal recognition.
- **Predicts or drives:** software delivery and organizational performance **indirectly**, by enabling teams to adopt technical and lean
  product management practices. On its own it is not enough: teams with leaders in the top 10% were not the very highest performers.
- **Evidence:** [2017](publications.md#2017-state-of-devops-report) (pp. 12–19; on page and report page),
  [2018](publications.md#2018-accelerate-state-of-devops-report) (leadership and autonomy; report page),
  [2024](publications.md#2024-accelerate-state-of-devops-report) (productivity, organizational performance, job satisfaction, less burnout;
  report page).
- **Repo ADR:** [ADR-DORA-LEADERSHIP](../../adr/research/transformational-leadership.md)

### Well-being

- **Page:** <https://dora.dev/capabilities/well-being/>
- **Category, tags, models:** climate for learning · `core` · Core Model (an **outcome**, not a capability).
- **Definition:** individuals' happiness and job satisfaction, studied through deployment pain, rework, and burnout.
- **Predicts or drives:** organizational performance and job tenure. The page reports that continuous delivery practices reduce deployment
  pain and predict less unplanned work and rework.
- **Evidence:** [2015](publications.md#2015-state-of-devops-report) (deployment pain and burnout; report page),
  [2016](publications.md#2016-state-of-devops-report) (high performers spend 49% of their time on new work and 21% on rework, against 38%
  and 27% for low performers; on page), [2018](publications.md#2018-accelerate-state-of-devops-report) (value-add time; on page),
  [2021](publications.md#2021-accelerate-state-of-devops-report), [2022](publications.md#2022-accelerate-state-of-devops-report),
  [2023](publications.md#2023-accelerate-state-of-devops-report), and [2024](publications.md#2024-accelerate-state-of-devops-report)
  (burnout findings; report pages).
- **Repo ADR:** [ADR-DORA-WELLBEING](../../adr/research/well-being.md)

## Fast flow

Capabilities that move changes to production quickly and safely. All eight Core Model fast-flow capabilities are here, plus trunk-based
development (removed from Core in V2), visual management, and WIP limits.

### Continuous delivery

- **Page:** <https://dora.dev/capabilities/continuous-delivery/>
- **Category, tags, models:** fast flow · `core` · Core Model (fast flow).
- **Definition:** being able to deploy to production on demand at any point, with fast feedback on quality and deployability that the whole
  team sees and acts on first.
- **Predicts or drives:** higher software delivery performance and availability, less rework and unplanned work, less deployment pain, less
  burnout, higher job satisfaction, and better culture. The page lists 14 capabilities that drive it, including test automation, deployment
  automation, trunk-based development, pervasive security, loosely coupled teams, CI, version control, monitoring, database change
  management, and code maintainability.
- **Evidence:** [2016](publications.md#2016-state-of-devops-report) and [2018](publications.md#2018-accelerate-state-of-devops-report)
  (rework; on page); [2014](publications.md#2014-state-of-devops-report), [2015](publications.md#2015-state-of-devops-report),
  [2017](publications.md#2017-state-of-devops-report), [2019](publications.md#2019-accelerate-state-of-devops-report), and
  [2022](publications.md#2022-accelerate-state-of-devops-report) (teams combining version control and CD are 2.5× more likely to have high
  delivery performance) (report pages).
- **Repo ADR:** [ADR-DORA-CD](../../adr/research/continuous-delivery.md)

### Database change management

- **Page:** <https://dora.dev/capabilities/database-change-management/>
- **Category, tags, models:** fast flow · `core` · Core Model (fast flow).
- **Definition:** handling database changes so they do not slow delivery: scripts in version control managed like application changes,
  visible to everyone, and discussed with the people who run the production database.
- **Predicts or drives:** contributes to continuous delivery, and through it to software delivery performance and availability.
- **Evidence:** [2018](publications.md#2018-accelerate-state-of-devops-report) (report page). The capability page cites no year.
- **Repo ADR:** [ADR-DORA-DBCHANGE](../../adr/research/database-change-management.md)

### Deployment automation

- **Page:** <https://dora.dev/capabilities/deployment-automation/>
- **Category, tags, models:** fast flow · `core` · Core Model (fast flow).
- **Definition:** how far deployments to test and production are fully automated, with no manual steps.
- **Predicts or drives:** one of the technical capabilities that drive continuous delivery (stated on the
  [continuous delivery](https://dora.dev/capabilities/continuous-delivery/) page). The page also calls it essential for lowering deployment
  risk and getting fast feedback.
- **Evidence:** [2017](publications.md#2017-state-of-devops-report) (high performers automate far more of their deployments; report page).
  The capability page cites no year.
- **Repo ADR:** [ADR-DORA-DEPLOY](../../adr/research/deployment-automation.md)

### Flexible infrastructure

- **Page:** <https://dora.dev/capabilities/flexible-infrastructure/> (the old path `/capabilities/cloud-infrastructure/` redirects here)
- **Category, tags, models:** fast flow · `core` · Core Model (fast flow).
- **Definition:** infrastructure with the five NIST cloud characteristics: on-demand self-service, broad network access, resource pooling,
  rapid elasticity, and measured service.
- **Predicts or drives:** continuous delivery, software delivery performance, availability, cost visibility, and organizational performance.
  Moving to the cloud without adopting its flexibility ("lift and shift") makes performance worse.
- **Evidence:** [2018](publications.md#2018-accelerate-state-of-devops-report) (23× more likely to be elite; report page);
  [2019](publications.md#2019-accelerate-state-of-devops-report) (29% of cloud adopters meet all five characteristics; 2.6× more likely to
  estimate costs accurately; on page); [2021](publications.md#2021-accelerate-state-of-devops-report) and
  [2022](publications.md#2022-accelerate-state-of-devops-report) (report pages);
  [2023](publications.md#2023-accelerate-state-of-devops-report) (30% higher organizational performance; on page);
  [2024](publications.md#2024-accelerate-state-of-devops-report) (a data centre may be better than an untransformed cloud; on page).
- **Repo ADR:** [ADR-DORA-FLEXINFRA](../../adr/research/flexible-infrastructure.md)

### Loosely coupled teams

- **Page:** <https://dora.dev/capabilities/loosely-coupled-teams/>
- **Category, tags, models:** fast flow · `core` · Core Model (fast flow).
- **Definition:** a team structure and architecture that let teams test and deploy on demand without coordinating with other services or
  teams.
- **Predicts or drives:** predicts continuous delivery and, through it, software delivery performance.
- **Evidence:** [2017](publications.md#2017-state-of-devops-report), [2021](publications.md#2021-accelerate-state-of-devops-report),
  [2022](publications.md#2022-accelerate-state-of-devops-report), and [2023](publications.md#2023-accelerate-state-of-devops-report) (on
  page and report pages). The Quick Check names it one of three capabilities worth assessing first.
- **Repo ADR:** [ADR-DORA-LOOSETEAMS](../../adr/research/loosely-coupled-teams.md)

### Streamlining change approval

- **Page:** <https://dora.dev/capabilities/streamlining-change-approval/>
- **Category, tags, models:** fast flow · `core` · Core Model (fast flow).
- **Definition:** replacing approval by an external body (a change advisory board or senior manager) with peer review during development,
  backed by automated detection of bad changes.
- **Predicts or drives:** heavyweight external approval hurts software delivery performance, and the data shows no evidence that it lowers
  change fail rates. A clearly understood approval process raises performance.
- **Evidence:** [2019](publications.md#2019-accelerate-state-of-devops-report) (on page and report page);
  [2017](publications.md#2017-state-of-devops-report) (high performers automate change approvals; report page).
- **Repo ADR:** [ADR-DORA-APPROVAL](../../adr/research/streamlining-change-approval.md)

### Trunk-based development

- **Page:** <https://dora.dev/capabilities/trunk-based-development/>
- **Category, tags, models:** fast flow · no tags · **not in Core** (removed in Core V2, with working in small batches taking its place, per
  the [Core V2 discussion](https://github.com/dora-team/dora.dev/discussions/582)).
- **Definition:** few active branches, branches that live less than a day before merging to trunk, and no code-freeze or stabilization
  periods.
- **Predicts or drives:** higher software delivery and operational performance (speed, stability, availability) for teams with three or
  fewer active branches, at least daily merges to trunk, and no code freezes or integration phases. The CI page calls it predictive of
  delivery performance.
- **Evidence:** [2016](publications.md#2016-state-of-devops-report) and [2017](publications.md#2017-state-of-devops-report) (on page);
  [2022](publications.md#2022-accelerate-state-of-devops-report) (documentation lift table, via documentation quality).
- **Repo ADR:** [ADR-DORA-TRUNK](../../adr/research/trunk-based-development.md)

### Version control

- **Page:** <https://dora.dev/capabilities/version-control/>
- **Category, tags, models:** fast flow · `core`, `AI` · Core Model (fast flow) and AI Capabilities Model ("Strong version control
  practices").
- **Definition:** using a version control system for every production artifact: application code, application and system configuration, and
  the scripts that build and configure environments.
- **Predicts or drives:** comprehensive use predicts continuous delivery. With AI, strong practice (frequent commits and reliance on
  rollback) amplifies AI's positive effect on individual effectiveness and team performance.
- **Evidence:** [2014](publications.md#2014-state-of-devops-report) and [2019](publications.md#2019-accelerate-state-of-devops-report) (on
  page); [2017](publications.md#2017-state-of-devops-report) (report page); [2022](publications.md#2022-accelerate-state-of-devops-report)
  (combined with CD, 2.5× more likely to be a high performer; on page and report page);
  [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) and
  [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page).
- **Repo ADR:** [ADR-DORA-VCS](../../adr/research/version-control.md)

### Visual management

- **Page:** <https://dora.dev/capabilities/visual-management/>
- **Category, tags, models:** fast flow · no tags · not in Core.
- **Definition:** shared visual displays that give everyone a common picture of where the team stands and how to improve.
- **Predicts or drives:** combined with [WIP limits](#wip-limits) and production feedback used for business decisions, it contributes to
  higher delivery performance.
- **Evidence:** [2015](publications.md#2015-state-of-devops-report) (on page).
- **Repo ADR:** [ADR-DORA-VISUAL](../../adr/research/visual-management.md)

### WIP limits

- **Page:** <https://dora.dev/capabilities/wip-limits/> (site title: "Work in process limits")
- **Category, tags, models:** fast flow · no tags · not in Core.
- **Definition:** prioritizing work and capping how many things are in progress at once, so a few high-priority items get finished.
- **Predicts or drives:** improvements in software delivery performance, especially when combined with
  [visual management](#visual-management) and feedback loops from [monitoring](#monitoring-systems).
- **Evidence:** the page cites no year. The visual management page attributes the combined finding to
  [2015](publications.md#2015-state-of-devops-report).
- **Repo ADR:** [ADR-DORA-WIP](../../adr/research/wip-limits.md)

### Working in small batches

- **Page:** <https://dora.dev/capabilities/working-in-small-batches/>
- **Category, tags, models:** fast flow · `core`, `AI` · Core Model (fast flow) and AI Capabilities Model.
- **Definition:** breaking changes into small units that can be tested and evaluated quickly, which shortens lead time and feedback loops.
- **Predicts or drives:** as part of lean product management, software delivery performance and organizational performance. With AI, it
  amplifies AI's positive effect on product performance, turns AI's neutral effect on friction positive, and counters AI-driven instability.
  The metrics guide names it the usual first lever for all five metrics.
- **Evidence:** [2016](publications.md#2016-state-of-devops-report), [2017](publications.md#2017-state-of-devops-report), and
  [2023](publications.md#2023-accelerate-state-of-devops-report) (listed on page);
  [2024](publications.md#2024-accelerate-state-of-devops-report) (small batches still crucial under AI; report page);
  [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) and
  [2025 AI Capabilities Model](publications.md#2025-dora-ai-capabilities-model) (on page).
- **Repo ADR:** [ADR-DORA-SMALLBATCH](../../adr/research/working-in-small-batches.md)

## Fast feedback

Capabilities that return rapid signal on changes, running systems, and users. The five Core Model fast-feedback capabilities that have pages
are here, plus customer feedback, monitoring systems, proactive failure notification, work visibility, and the page-less reliability
engineering entry.

### Continuous integration

- **Page:** <https://dora.dev/capabilities/continuous-integration/>
- **Category, tags, models:** fast feedback · `core` · Core Model (fast feedback).
- **Definition:** developers check code in regularly, each check-in triggers quick tests that catch regressions, those regressions are fixed
  at once, and the process produces the canonical builds that get deployed.
- **Predicts or drives:** higher deployment frequency, more stable systems, and higher-quality software. Merging to trunk at least daily and
  fixing a broken build before other work are both predictive of delivery performance.
- **Evidence:** [2015](publications.md#2015-state-of-devops-report) (daily merges; on page),
  [2014](publications.md#2014-state-of-devops-report) and [2016](publications.md#2016-state-of-devops-report) (on page);
  [2017](publications.md#2017-state-of-devops-report) (report page); [2022](publications.md#2022-accelerate-state-of-devops-report)
  (supply-chain security controls help only where CI is established; report page);
  [2023](publications.md#2023-accelerate-state-of-devops-report) (report page);
  [2025 Impact of Generative AI](publications.md#2025-impact-of-generative-ai-in-software-development) (catches AI-introduced errors; report
  page). The Quick Check names it one of three capabilities worth assessing first.
- **Repo ADR:** [ADR-DORA-CI](../../adr/research/continuous-integration.md)

### Customer feedback

- **Page:** <https://dora.dev/capabilities/customer-feedback/>
- **Category, tags, models:** fast feedback · no tags · not in Core.
- **Definition:** gathering customer feedback and using it in product and feature design.
- **Predicts or drives:** together with the other lean product management capabilities, software delivery performance (speed, stability,
  availability) and organizational performance (profitability, market share, productivity). Customer engagement also strengthens people's
  identification with organizational goals.
- **Evidence:** [2016](publications.md#2016-state-of-devops-report) (on page), [2017](publications.md#2017-state-of-devops-report) (report
  page), [2019](publications.md#2019-accelerate-state-of-devops-report) (on page).
- **Repo ADR:** [ADR-DORA-FEEDBACK](../../adr/research/customer-feedback.md)

### Monitoring and observability

- **Page:** <https://dora.dev/capabilities/monitoring-and-observability/>
- **Category, tags, models:** fast feedback · `core` · Core Model (fast feedback).
- **Definition:** tooling that shows a system's health, covering predefined metrics (including the state users experience) and interactive
  debugging of emerging behaviour.
- **Predicts or drives:** contributes to continuous delivery. The page frames time to restore as the key outcome measure of an outage.
- **Evidence:** [2018](publications.md#2018-accelerate-state-of-devops-report) (on page and report page).
- **Repo ADR:** [ADR-DORA-OBSERV](../../adr/research/monitoring-and-observability.md)

### Monitoring systems

- **Page:** <https://dora.dev/capabilities/monitoring-systems/> (site title: "Monitoring systems to inform business decisions")
- **Category, tags, models:** fast feedback · no tags · not in Core.
- **Definition:** collecting, analysing, and using data about applications and infrastructure to guide business decisions, and feeding
  operational knowledge back to development and product teams.
- **Predicts or drives:** the page states no research finding of its own. The [WIP limits](#wip-limits) and
  [visual management](#visual-management) pages cite monitoring feedback as part of their combined effect.
- **Evidence:** none on page. The related combined finding is attributed to [2015](publications.md#2015-state-of-devops-report).
- **Repo ADR:** [ADR-DORA-MONITOR](../../adr/research/monitoring-systems.md)

### Pervasive security

- **Page:** <https://dora.dev/capabilities/pervasive-security/>
- **Category, tags, models:** fast feedback · `core` · Core Model (fast feedback).
- **Definition:** building security into design and testing throughout the lifecycle, through security reviews, involving InfoSec in design
  and demos, pre-approved libraries, and automated security tests.
- **Predicts or drives:** higher software delivery performance and more secure systems, with far less time spent remediating security
  issues.
- **Evidence:** [2016](publications.md#2016-state-of-devops-report) (high performers spend 50% less time on remediation; on page);
  [2018](publications.md#2018-accelerate-state-of-devops-report) and [2021](publications.md#2021-accelerate-state-of-devops-report) (report
  pages); [2022](publications.md#2022-accelerate-state-of-devops-report) (culture is the biggest predictor of security practices;
  high-security teams are 1.6× more likely to have high organizational performance; low-security teams have 1.4× higher odds of high
  burnout; report page).
- **Repo ADR:** [ADR-DORA-SECURITY](../../adr/research/pervasive-security.md)

### Proactive failure notification

- **Page:** <https://dora.dev/capabilities/proactive-failure-notification/>
- **Category, tags, models:** fast feedback · no tags · not in Core.
- **Definition:** alerting when monitored values approach known failure thresholds, rather than after a failure or when customers report it.
- **Predicts or drives:** proactive monitoring is a significant predictor of software delivery performance, and it lets teams diagnose and
  fix problems quickly.
- **Evidence:** [2014](publications.md#2014-state-of-devops-report) (on page).
- **Repo ADR:** [ADR-DORA-FAILALERT](../../adr/research/proactive-failure-notification.md)

### Test automation

- **Page:** <https://dora.dev/capabilities/test-automation/>
- **Category, tags, models:** fast feedback · `core` · Core Model (fast feedback).
- **Definition:** testing throughout the lifecycle rather than after "dev complete", with developers and testers working together,
  test-driven development, and test feedback in under ten minutes.
- **Predicts or drives:** better software stability, less burnout, and less deployment pain. Developer-owned test suites drive performance.
- **Evidence:** [2014](publications.md#2014-state-of-devops-report), [2016](publications.md#2016-state-of-devops-report),
  [2018](publications.md#2018-accelerate-state-of-devops-report), and [2019](publications.md#2019-accelerate-state-of-devops-report) (listed
  on page); [2017](publications.md#2017-state-of-devops-report) and [2021](publications.md#2021-accelerate-state-of-devops-report) (report
  pages); [2024](publications.md#2024-accelerate-state-of-devops-report) and
  [2025 Impact of Generative AI](publications.md#2025-impact-of-generative-ai-in-software-development) (robust testing as an AI safeguard;
  report pages).
- **Repo ADR:** [ADR-DORA-TESTAUTO](../../adr/research/test-automation.md)

### Test data management

- **Page:** <https://dora.dev/capabilities/test-data-management/>
- **Category, tags, models:** fast feedback · `core` · Core Model (fast feedback).
- **Definition:** having enough test data, available on demand, so that data never limits which tests can run, while keeping the amount of
  data tests need to a minimum.
- **Predicts or drives:** contributes to [test automation](#test-automation) and [continuous integration](#continuous-integration), and is
  listed among the drivers of continuous delivery.
- **Evidence:** the page cites no year.
- **Repo ADR:** [ADR-DORA-TESTDATA](../../adr/research/test-data-management.md)

### Work visibility in value stream

- **Page:** <https://dora.dev/capabilities/work-visibility-in-value-stream/> (site title: "Visibility of work in the value stream")
- **Category, tags, models:** fast feedback · no tags · not in Core.
- **Definition:** teams understand, and can see, how work flows from the business to customers, including the status of products and
  features.
- **Predicts or drives:** as part of lean product management, both software delivery performance and organizational performance.
- **Evidence:** the page cites no year. The [2016](publications.md#2016-state-of-devops-report) report page names visibility into the
  workflow as part of an experimental approach.
- **Repo ADR:** [ADR-DORA-WORKVIS](../../adr/research/work-visibility-in-value-stream.md)

### Reliability engineering

- **Page:** none. The entry exists only in the Core Model v2.1.0 diagram, under fast feedback.
- **Category, tags, models:** Core Model (fast feedback). It has no catalogue page, tags, or category field.
- **Definition (from the diagram):** designing, building, and running systems that withstand failure rather than only trying to prevent it.
  Principles include accepting failure, continuous improvement, fault tolerance, data integrity, load balancing, replication, autoscaling,
  and automated recovery.
- **Predicts or drives:** the diagram gives no specific claim. Related finding: reliability practices strongly predict organizational
  performance ([2022](publications.md#2022-accelerate-state-of-devops-report), report page).
- **Repo ADR:** none.

## Sources

Retrieved 2026-10-13.

- <https://dora.dev/capabilities/> and each of the 34 capability pages linked above
- <https://dora.dev/research/> (Core Model diagram)
- <https://dora.dev/guides/dora-metrics/>
- <https://dora.dev/insights/quickcheck-updates/>
- The yearly report pages listed in [publications.md](publications.md#sources)
- <https://github.com/dora-team/dora.dev/discussions/582> (Core V2 discussion)
- <https://github.com/dora-team/dora.dev/tree/main/hugo/content/capabilities> (capability `category`, `core`, and `ai` fields, commit
  `b14ae08`)
- <https://github.com/dora-team/dora.dev/blob/main/hugo/themes/dora-2025/layouts/capabilities/section.html> (how the catalogue renders tags)
- <https://github.com/dora-team/dora.dev/blob/main/svelte/core-v2/src/lib/core_data.json> (Core Model group membership)
