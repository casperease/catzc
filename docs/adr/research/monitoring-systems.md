# ADR: DORA — Monitoring systems to inform business decisions

## Rules: ADR-DORAMS

### Rule ADR-DORAMS:1

Monitoring exists to inform decisions, not only to detect failure. Collecting data across development, testing, QA, and operations is the
first half of the capability; turning that data into a decision is the second, and neither half stands in for the other.

- [Summary](#summary)

### Rule ADR-DORAMS:2

Present monitoring data so it is relevant, timely, accurate, and easy to understand for the audience reading it, with enough context to say
whether a value is high or low, expected, about to change, or a departure from its historical trend — a raw number without that context is
not yet a decision input.

- [Summary](#summary)

### Rule ADR-DORAMS:3

Let production signals travel upstream. Insight gathered from operations — a deployment error, a customer usage pattern, a performance
regression — is a learning input for development and product management, not information that stops with the team that first saw it.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAMS:4

Monitor the full pipeline, not one or two convenient stations, and judge a change by its effect on the whole system rather than by whether
it improves the one service being watched.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAMS:5

Alert on approach to a threshold, not only on failure, and choose what to monitor deliberately — instrumenting everything produces more
noise than insight and buries the signal the capability exists to surface.

- [Common pitfalls](#common-pitfalls)

## Context

DORA defines monitoring as "the process of collecting, analyzing, and using information to track applications and infrastructure in order to
guide business decisions." The capability sits alongside monitoring and observability in DORA's technical practices, but it asks a different
question: observability and monitoring-and-observability are about seeing a system's internal state; this capability is about what an
organization does with what it sees — whether the data collected actually reaches the people who decide what to build, fix, or change next.

## Summary

The capability has two elements. The first is collecting data: monitoring solutions — homegrown or managed — give visibility across
development, testing, QA, and IT operations, with metrics chosen for the function and the business the system serves. The second is using
that data for decisions: the collected signals are transformed and visualized so they reach different audiences in a form each can act on,
presented so they are relevant, timely, accurate, and easy to understand, with context for whether a value is high or low, expected,
anticipated to change, or a departure from its historical trend.

DORA measures the capability directly by asking how much teams agree with two statements: that data from application performance monitoring
tools is used to make business decisions, and that data from infrastructure monitoring tools is used to make business decisions. A team can
collect extensive telemetry and still score low here if none of it changes a decision.

## Why it matters

Monitoring that only tracks systems provides insight and rapid feedback for early problem identification, which is valuable on its own —
catching a regression at build time is cheaper than catching it in production. But the capability's distinguishing benefit is knowledge
transfer: operational insight from production — a deployment error, a customer usage pattern, a performance regression under real load — is
exactly the input that upstream teams like development and product management need and otherwise lack. A team that monitors but never routes
what it learns back to the people who decide what to build next has the tooling for this capability without the outcome it exists to
produce.

## How to apply

This platform treats "go and see" the real running artifact, not a proxy, as the basis for every decision about whether work is done
([ADR-OBSERVE](../process/observe-work.md)) — a green gate, a deployed environment, a monitored metric outrank a task marked complete, which
is the same discipline this capability asks of business decisions: ground them in what the system is actually doing, not in an assumption
about it. Console output is the concrete channel that data travels through to reach the person who needs it: it reports outcomes rather than
step narration, stays silent when there is nothing to report, and announces a slow operation before it blocks, so the signal that reaches
the reader is relevant and timely rather than buried in noise ([ADR-CONSOLE](../automation/powershell/console-output-matters.md)) — the same
"relevant, timely, accurate, easy to understand" bar DORA sets for monitoring data aimed at a decision-maker rather than a machine.

## Common pitfalls

- **Reactive-only monitoring.** Alerting only once a system has already failed, instead of watching for the approach to a critical threshold
  and acting before the failure happens.
- **Limited scope.** Monitoring one or two convenient areas instead of the full pipeline, which leaves the rest of the system's behavior
  invisible to the decisions that depend on it.
- **Local optimization.** Improving one service's numbers without evaluating what that change costs or gains the broader system it sits
  inside.
- **Monitoring everything.** Instrumenting every available signal indiscriminately, which produces over-alerting and a volume of data no one
  can turn into a decision — the opposite of the capability's purpose.

## References

[^1]:
    DORA, _Monitoring systems to inform business decisions_ capability, <https://dora.dev/capabilities/monitoring-systems/>. Part of the
    DORA Core Model of capabilities that predict software delivery performance.

## Dora explains

DORA ties this capability to delivery and organizational performance through a mechanism distinct from watching systems for failure: it is
the loop that turns collected data into the decisions that shape what a team builds and changes next.

- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — the tooling and signals this capability
  turns into business decisions rather than only into alerts.
- [Proactive failure notification](https://dora.dev/capabilities/proactive-failure-notification/) — the same collected data, routed to
  surface a problem before a customer reports it.
- [Customer feedback](https://dora.dev/capabilities/customer-feedback/) — a parallel channel of decision-informing signal, gathered from
  users rather than from systems.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
