# ADR: DORA — Monitoring and observability

## Rules: ADR-DORAMO

### Rule ADR-DORAMO:1

Monitoring and observability are two distinct capabilities and both are required — monitoring watches predefined metrics and logs for known
conditions, and observability lets a team explore properties and patterns that were never defined in advance. Neither substitutes for the
other.

- [Summary](#summary)

### Rule ADR-DORAMO:2

Build monitoring to serve as a leading indicator — it must surface a degradation before it becomes an outage, not only confirm an outage
after the fact, and installing a tool is not the goal; every developer proficient with it is.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAMO:3

Treat monitoring and alerting configuration as code — changes to it go through the same review and version control as application code, not
an unaudited side channel.

- [How to apply](#how-to-apply)

### Rule ADR-DORAMO:4

Alert on symptoms, not causes — build alerting around a visible or predicted user-facing symptom, never around an enumerated list of every
conceivable failure cause, and route each alert to a specific responsible party rather than a broad distribution list.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAMO:5

Never centralize monitoring ownership in one person or team, and keep alerts actionable — an alert that produces no action is a candidate
for removal, not a permanent fixture, because unactionable noise is what buries the alert that matters.

- [Common pitfalls](#common-pitfalls)

## Context

DORA distinguishes two related but separate technical solutions. Monitoring is "tooling or a technical solution that allows teams to watch
and understand the state of their systems," based on "gathering predefined sets of metrics or logs." Observability is "tooling or a
technical solution that allows teams to actively debug their system," based on "exploring properties and patterns not defined in advance." A
team needs both: monitoring answers the questions it already knew to ask, observability answers the ones it did not.

The capability sits in the DORA Core Model as a technical practice that supports continuous delivery — comprehensive monitoring and
observability "positively contributes to continuous delivery" by giving teams the signals they need to change software safely and recover
from failure quickly.

## Summary

The capability requires reporting on the overall health of systems, reporting on system state as experienced by customers, monitoring key
business and systems metrics, tooling to debug production systems, the capability to identify "unknown unknowns," and tools to trace and
diagnose infrastructure problems.

Two complementary monitoring styles cover this ground. Blackbox (synthetic) monitoring sends input to a system the way a customer would — an
HTTP call to a public API, an RPC call to an exposed endpoint, or a rendered web page — and validates the response, which can be as simple
as checking a status code. Whitebox monitoring reads the system's own internal signals, of which there are three kinds: metrics (numeric
measurements of internal state — counters, distributions, gauges), logs (append-only records of a single thread of work at a single point in
time), and traces (spans that follow one event or user action through a distributed system).

None of these signals exist without instrumentation — code added to the system for the sole purpose of exposing its inner state. Once
collected, signals from an application and from the systems underneath it are correlated to pin down a contributing factor across a shared
system, and the computation stage weighs cardinality (the number of distinct values a field can take) against dimensionality (how much
environmental metadata is recorded alongside each value), since combining high cardinality with high dimensionality drives up compute and
storage cost sharply. Monitoring configuration is critical enough that changes to it are tracked through review and approval, the same
discipline applied to code.

## Why it matters

The mechanism is early warning and fast diagnosis. Monitoring that only confirms an outage after customers have already noticed it is too
late to matter; monitoring that reports leading indicators of degradation lets a team act before the outage happens, and when something does
fail, the same signals cut the time to detect and the time to resolve. That combination is what shortens time-to-restore.

Tooling alone does not produce this outcome. "Installing a tool is not enough to achieve the objectives" — the benefit depends on empowering
every developer, not a specialist few, to be proficient with the monitoring in place, because that is what builds a culture of data-driven
decisions rather than guesswork. A team can also check whether its own monitoring practice is working: how often the monitoring
configuration itself changes, what fraction of alerts fire outside working hours (a high fraction signals both weak leading indicators and a
burnout risk), what fraction of alerts are acknowledged within an agreed deadline, and how many alerts turn out to need no action at all.
These are measures of the capability, not just of the systems it watches.

## How to apply

This platform gives its automation the same signals a monitored production system needs. Every external command is logged in full, resolved
form immediately before it runs ([ADR-PRELOG](../automation/log-before-invoke.md)), which is instrumentation applied to the automation's own
inner state — the exact command a step is about to take is exposed, not inferred after the fact. Console output is treated as the
automation's whitebox signal stream: it reports outcomes rather than step-by-step narration, stays silent when there is nothing to report,
and announces a slow operation before it blocks so silence is never mistaken for a hang
([ADR-CONSOLE](../automation/powershell/console-output-matters.md)) — the same symptom-first, low-noise discipline DORA asks of alerting.
Decisions about whether work is actually done rest on the real running artifact and its real signals — a green gate, a deployed environment,
a monitored metric — rather than on a proxy such as a task marked complete ([ADR-OBSERVE](../process/observe-work.md)), which is the "go and
see" instinct behind observability applied to the whole delivery flow, not only to production.

## Common pitfalls

- **Cause-based alerting.** Trying to enumerate every possible error condition and write an alert for each one, instead of symptom-based
  alerting that only fires when a user-facing symptom is visible or predicted to arise soon.
- **Centralized ownership.** A single monitoring person or dedicated team who is solely responsible for the system — monitoring works only
  when the teams that operate a system also own and understand its monitoring.
- **Diffused alert delivery.** Emailing alerts to an entire team through a distribution list, which quickly produces ignored alerts because
  no one individual feels responsible for acting on them.
- **Alert fatigue.** Too many alerts that are not actionable or produce no improvement when acted on, so the team starts missing the alerts
  that are genuinely meaningful.
- **Over-curated dashboards.** In a fast-changing system, time spent curating a dashboard produces a dashboard that is out of date before it
  is finished.
- **Conflating metric types.** Mixing product- or executive-facing metrics — user acquisition rate, revenue — into the same dashboards used
  for operational or service health, which muddies both.

## References

[^1]:
    DORA, _Monitoring and observability_ capability, <https://dora.dev/capabilities/monitoring-and-observability/>. Part of the DORA Core
    Model of capabilities that predict software delivery performance.

## Dora explains

Monitoring and observability are a core-model technical capability DORA ties directly to shorter time-to-restore and to safer, faster
delivery — a team cannot deploy with confidence or recover quickly from a failure it cannot see.

- [Proactive failure notification](https://dora.dev/capabilities/proactive-failure-notification/) — turns the signals monitoring and
  observability collect into alerts a team acts on before customers report the problem.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — depends on monitoring to confirm a change is safe and to
  detect a regression quickly if it is not.
- [Version control](https://dora.dev/capabilities/version-control/) — treating monitoring configuration as a reviewed, versioned artifact is
  comprehensive version control applied to observability itself.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
