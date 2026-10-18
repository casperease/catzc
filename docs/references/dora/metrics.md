# DORA software delivery performance metrics

DORA measures the outcome of the software delivery process with **five software delivery performance metrics** in two families,
**throughput** and **instability** ([metrics guide](https://dora.dev/guides/dora-metrics/), updated 2026-01-05). The guide says DORA's
research shows these metrics predict better organizational performance and better well-being for team members.

The guide describes the metrics as both:

- **leading indicators** of organizational performance and employee well-being; and
- **lagging indicators** of the software development and delivery practices that produce them.

| Metric                                                              | Family      | Measures                                                                      |
| ------------------------------------------------------------------- | ----------- | ----------------------------------------------------------------------------- |
| [Change lead time](#change-lead-time)                               | Throughput  | Time from a change committed to version control to it running in production   |
| [Deployment frequency](#deployment-frequency)                       | Throughput  | How often changes are deployed                                                |
| [Failed deployment recovery time](#failed-deployment-recovery-time) | Throughput  | Time to recover from a deployment that fails and needs immediate intervention |
| [Change fail rate](#change-fail-rate)                               | Instability | Share of deployments that need immediate intervention                         |
| [Deployment rework rate](#deployment-rework-rate)                   | Instability | Share of deployments that are unplanned, made to fix a production incident    |

The metrics are meant to be applied **per application or service**, in that application's context. They work for any technology stack, but
blending them across very different teams or whole organizations is misleading ([metrics guide](https://dora.dev/guides/dora-metrics/)).

## Throughput

How many changes can move through the system to production in a period of time. Higher throughput means the system can move more changes to
production. DORA measures throughput with three metrics: [change lead time](#change-lead-time),
[deployment frequency](#deployment-frequency), and [failed deployment recovery time](#failed-deployment-recovery-time)
([metrics guide](https://dora.dev/guides/dora-metrics/)).

Failed deployment recovery time belongs to the throughput family in the current model. Through 2023, recovery time was counted as a
_stability_ measure: first as mean time to recover, then, after the 2023 rename, as failed deployment recovery time. See
[metric history](#metric-history).

## Instability

How well deployments go. When deployments go well, teams can push more changes with confidence, and users are less likely to hit problems
right after a deployment. DORA measures instability with two metrics: [change fail rate](#change-fail-rate) and
[deployment rework rate](#deployment-rework-rate) ([metrics guide](https://dora.dev/guides/dora-metrics/)).

Before 2024 this family was called **stability**. The Quick Check still reports a "stability" score that is derived from it
([FAQ](https://dora.dev/faq/)).

## Change lead time

- **Family:** [throughput](#throughput).
- **Definition:** the time a change takes to go from committed to version control to deployed in production.
- **Quick Check question:** for the primary application or service, how long it takes to go from code committed to code successfully running
  in production. The answer bands run from "less than one hour" to "more than six months".
- **Former names:** lead time for changes; deployment lead time (2015).
- **Source:** <https://dora.dev/guides/dora-metrics/>

## Deployment frequency

- **Family:** [throughput](#throughput).
- **Definition:** the number of deployments in a given period, or equivalently the time between deployments.
- **Quick Check question:** how often the organization deploys code to production or releases it to end users. The answer bands run from "on
  demand (multiple deploys per day)" to "less than once per six months".
- **Source:** <https://dora.dev/guides/dora-metrics/>

## Failed deployment recovery time

- **Family:** [throughput](#throughput).
- **Definition:** the time it takes to recover from a deployment that fails and needs immediate intervention.
- **Quick Check question:** how long it generally takes to restore service after a change to production results in degraded service and
  needs remediation (a hotfix, rollback, fix-forward, or patch). The answer bands run from "less than one hour" to "more than six months".
- **Former names:** mean time to recover (MTTR); time to restore service. It was renamed and redefined in 2023. The old definitions did not
  separate failures caused by a change from failures with external causes, such as a data-centre outage. The new definition covers only
  recovery from a change that impaired production ([metrics history](https://dora.dev/insights/dora-metrics-history/)).
- **Source:** <https://dora.dev/guides/dora-metrics/>

## Change fail rate

- **Family:** [instability](#instability).
- **Definition:** the ratio of deployments that need immediate intervention afterwards, usually a rollback or a hotfix.
- **Quick Check question:** roughly what percentage of changes to production result in degraded service and then need remediation.
- **Other names on the site:** change failure rate; change fail percentage (the Core Model diagram).
- **History:** in the first study (2014), change fail rate did not load onto the same statistical construct as the other measures, so the
  2014 definition of IT performance used only three metrics. From 2015 it was counted as a stability measure
  ([metrics history](https://dora.dev/insights/dora-metrics-history/)).
- **Source:** <https://dora.dev/guides/dora-metrics/>

## Deployment rework rate

- **Family:** [instability](#instability).
- **Definition:** the ratio of deployments that are unplanned and happen because of an incident in production.
- **Quick Check question:** roughly what percentage of deployments in the last six months were unplanned and made to address a user-facing
  bug.
- **History:** added in 2024. DORA saw change fail rate acting as a proxy for how much rework a team does, and introduced this metric to
  test that directly ([metrics history](https://dora.dev/insights/dora-metrics-history/)). The Quick Check added it in April 2026
  ([Quick Check updates](https://dora.dev/insights/quickcheck-updates/)).
- **Also called:** rework rate.
- **Source:** <https://dora.dev/guides/dora-metrics/>

## Reliability

Reliability is part of the performance column of the [Core Model](core-model.md#reliability), measured through service level objectives. It
is not a software delivery metric. It is a measure of **operational performance**
([metrics history](https://dora.dev/insights/dora-metrics-history/)):

- 2018 introduced **availability** as a measure of operational health and renamed the overall construct "software delivery and operational
  (SDO) performance".
- 2021 broadened availability into **reliability**, covering latency, performance, and scalability as well. The metrics history notes that
  the 2021 report wrongly called reliability the "fifth metric".
- 2022 found that high software delivery performance benefits organizational performance only when operational performance (reliability) is
  also high ([2022 archive](https://dora.dev/research/2022/)).

## Key insights

Paraphrased from the [metrics guide](https://dora.dev/guides/dora-metrics/):

- **Speed and stability are not a trade-off.** For most teams the metrics move together: top performers do well on all five, and low
  performers do poorly on all five.
- **Context matters.** Apply the metrics to one application or service at a time, in its own context.
- **Use them to improve, not to compete.** The guide's pitfalls are: setting a metric as a target (Goodhart's law), relying on one metric
  alone, using the industry as an excuse not to improve, comparing unlike applications, siloed ownership of the metrics, competing with
  other teams, and building measurement at the expense of improvement.
- **The usual first lever is batch size.** Smaller changes are easier to reason about, move faster through delivery, and are easier to
  recover from. See [working in small batches](capabilities.md#working-in-small-batches).

## Performance clusters

DORA groups survey respondents into performance clusters by cluster analysis. The number of clusters emerges from the data and is not set in
advance ([FAQ](https://dora.dev/faq/)):

| Period    | Clusters found                                                                                       |
| --------- | ---------------------------------------------------------------------------------------------------- |
| 2014–2017 | Three: low, medium, high                                                                             |
| 2018–2021 | Four: the **elite** cluster was introduced in 2018 ([2018 archive](https://dora.dev/research/2018/)) |
| 2022      | Three                                                                                                |
| 2023–2024 | Four                                                                                                 |

The 2025 report identifies "seven team profiles" ([report version check](https://dora.dev/vc/)). The site does not describe them beyond that
phrase.

Comparisons between clusters, as stated on the yearly archive pages:

| Year | Comparison    | Deployment frequency | Lead time     | Recovery      | Change fail rate | Source                                              |
| ---- | ------------- | -------------------- | ------------- | ------------- | ---------------- | --------------------------------------------------- |
| 2015 | High vs. low  | 30× more frequent    | 200× shorter  | 168× faster   | 60× fewer        | [2015](https://dora.dev/research/2015/)             |
| 2016 | High vs. low  | 200× more frequent   | 2,555× faster | 24× faster    | 3× lower         | [2016](https://dora.dev/research/2016/)             |
| 2018 | Elite vs. low | 46× more frequent    | 2,555× faster | 2,604× faster | 7× lower         | [2018](https://dora.dev/research/2018/dora-report/) |

In 2021, elite performers made up 26% of teams and had cut their lead times further ([2021 archive](https://dora.dev/research/2021/)).

The FAQ says the Quick Check compares a team with benchmarks derived from DORA's 2025 research ([FAQ](https://dora.dev/faq/)).

## Metric history

From [A history of DORA's software delivery metrics](https://dora.dev/insights/dora-metrics-history/):

| From | Change                                                                                                                    |
| ---- | ------------------------------------------------------------------------------------------------------------------------- |
| 2014 | "IT performance" defined by deployment frequency, lead time for changes, and MTTR; change fail rate studied but excluded  |
| 2015 | Two factors: throughput (deployment frequency, deployment lead time) and stability (MTTR, change fail rate)               |
| 2018 | Availability added as an operational measure; the construct becomes "software delivery and operational (SDO) performance" |
| 2021 | Availability broadened to reliability (an operational measure, not a fifth delivery metric)                               |
| 2023 | MTTR renamed and redefined as failed deployment recovery time                                                             |
| 2024 | Deployment rework rate added; five metrics in two factors: throughput (three metrics) and instability (two metrics)       |

The 2025 year-in-review says DORA "officially evolved" the four metrics into five in 2025
([2025 year in review](https://dora.dev/insights/dora-2025-year-in-review/)). The metrics history dates the change to the 2024 report.

## Sources

Retrieved 2026-10-13.

- <https://dora.dev/guides/dora-metrics/>
- <https://dora.dev/insights/dora-metrics-history/>
- <https://dora.dev/insights/quickcheck-updates/>
- <https://dora.dev/insights/dora-2025-year-in-review/>
- <https://dora.dev/faq/>
- <https://dora.dev/quickcheck/>
- <https://dora.dev/vc/>
- <https://dora.dev/research/2015/>
- <https://dora.dev/research/2016/>
- <https://dora.dev/research/2018/> and <https://dora.dev/research/2018/dora-report/>
- <https://dora.dev/research/2021/>
- <https://dora.dev/research/2022/>
- <https://github.com/dora-team/dora.dev/blob/main/svelte/quick-check/src/lib/data/metrics_details.json> (Quick Check question wording)
- <https://github.com/dora-team/dora.dev/blob/main/svelte/quick-check/src/lib/data/metrics_question_responses.json> (Quick Check answer
  bands)
