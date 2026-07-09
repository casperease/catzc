# ADR: DORA — Proactive failure notification

## Rules: ADR-DORAPFN

### Rule ADR-DORAPFN:1

Generate a notification when a monitored value approaches a known failure threshold — not only after the system has already failed or after
a customer has already reported it.

- [Summary](#summary)

### Rule ADR-DORAPFN:2

Choose thresholds that predict impact, not thresholds that merely exist to be measured — identify the value level that begins to cause
user-facing impact, then trigger the alert some percentage before that value is reached, so there is room to act before harm occurs.

- [How to apply](#how-to-apply)

### Rule ADR-DORAPFN:3

Automate the response to any notification whose action is always the same or requires no action at all; reserve a notification that
interrupts a person for a condition that genuinely needs a person's judgment.

- [How to apply](#how-to-apply)

### Rule ADR-DORAPFN:4

Treat every post-incident review as a search for the leading indicator that could have predicted the incident, and add an alert for that
indicator when none exists yet.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAPFN:5

Guard against alert fatigue deliberately — exposing people to a large number of alarms desensitizes them to alarms, producing longer
response times or missed alarms, so an alert that does not predict actionable impact is a liability, not a safety margin.

- [Common pitfalls](#common-pitfalls)

## Context

Proactive failure notification is the practice of generating a notification when a monitored value approaches a known failure threshold,
rather than waiting for the system to fail outright or for a customer to notice and report it first. It is the alerting layer built on top
of monitoring and observability ([ADR-DORAMO](monitoring-and-observability.md)): the signals that monitoring collects only become proactive
once they are turned into a notification that fires before impact, not left as a number on a dashboard someone might happen to see.

DORA's research establishes proactive monitoring as a significant predictor of software delivery performance. The distinguishing factor is
who finds out first. An organization whose own alerting notices a degrading value before it fails can diagnose and solve the problem
quickly, on its own initiative. An organization that instead depends on a network operations center or the customers themselves to notice
and report a problem first experiences diminished delivery performance, because the report arrives only after harm has already happened and
only after passing through another party.

## Summary

The capability is generating an alert when a monitored value is heading toward a known failure threshold, before it crosses that threshold
and causes user-facing impact. It rests on defined alerting rules: each rule states the condition that triggers an alert and the
notification channel that carries it, and the value of the whole practice depends on choosing thresholds well — identify the value level
that begins to cause user-facing impact, then trigger the alert notification some percentage before that value is crossed, leaving room to
act before the impact occurs.

Two feedback loops keep the set of thresholds current. A post-incident review asks which indicator could have predicted the incident, and
adds an alert for it if none exists yet. And whenever a notification's response is always the same action, or requires no action at all,
that response is automated instead of left for a person to repeat by hand every time it fires.

## Why it matters

DORA's research ties proactive notification directly to software delivery performance. The mechanism is speed and ownership of discovery: a
team whose alerting notices a degrading value before it fails can diagnose and solve the problem quickly, because the people closest to the
system are the first to know something is wrong. A team that instead relies on an external party — a network operations center, or the
customers themselves — to notice and report a problem first is working from a position of diminished performance, because the report arrives
late and secondhand.

Post-incident review is where this feedback loop closes: determining, after an incident, which indicator could have predicted it turns every
incident into a candidate new alert, so the set of monitored thresholds keeps pace with the ways the system actually fails rather than
staying frozen at whatever was anticipated when it was first built.

## How to apply

This platform's alerting rules live in the retry policy: a retry is permitted only for a genuinely transient, external, idempotent failure,
and every retry is logged as a warning rather than allowed to pass silently
([ADR-RETRY](../automation/retry-as-last-resort.md#rule-adr-retry5)). That warning is the proactive notification — it fires while the
operation is still succeeding, before the retries are exhausted and the call fails outright, so a degrading dependency leaves a breadcrumb
ahead of the failure it predicts. The retry itself is the automated response DORA asks for when a notification's action is always the same —
retry the one idempotent call — and the warning is what a person reviewing the log sees if the same dependency keeps degrading across runs.
Console output reserves yellow strictly for conditions that need attention
([ADR-CONSOLE](../automation/powershell/console-output-matters.md#rule-adr-console7)), so that reserved channel keeps working as a
notification signal instead of being drowned out by decorative color used for everything else.

## Common pitfalls

- **Alert fatigue.** Exposing people to a large number of alarms desensitizes them to the alarms, producing longer response times or missed
  alarms — a flood of low-value alerts degrades response to every alert, including the one that matters.
- **Thresholds chosen for ease of measurement, not for predictive value.** An alert that fires on a value that does not actually foreshadow
  user-facing impact before it happens; a threshold only earns its place when it triggers before the value that causes visible harm, not
  merely when it triggers.
- **Waiting on an external report.** Relying on a network operations center or the customers themselves to notice a problem first, instead
  of a self-generated proactive notification that lets the team discover and act on its own initiative.
- **Leaving a repeatable response to a human.** A notification whose action is always the same, or requires no action at all, left for a
  person to handle by hand instead of automated — every unnecessary manual response competes for the attention the genuinely actionable
  alert needs.

## References

[^1]:
    DORA, _Proactive failure notification_ capability, <https://dora.dev/capabilities/proactive-failure-notification/>. Part of the DORA
    Core Model of capabilities that predict software delivery performance.

## Dora explains

Proactive failure notification is what turns the signals monitoring and observability collect into recovery: DORA ties it to faster
diagnosis, faster resolution, and higher software delivery performance, because the team that alerts on its own thresholds finds a problem
before a customer does.

- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — supplies the metrics, logs, and traces a
  threshold-based alert is defined over; this capability is what turns those signals into a notification a team acts on before impact.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — a team ships small changes with confidence only when it trusts
  a regression will be flagged before it reaches customers.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — an automated deployment pipeline is where "automate the
  response" applies most directly: a threshold breach can trigger an automatic rollback rather than waiting on a person.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
