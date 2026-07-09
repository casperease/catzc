# ADR: DORA — Visual management

## Rules: ADR-DORAVM

### Rule ADR-DORAVM:1

Display key information about the team's process — in-progress work, build status, deployment pipeline state, production telemetry — in a
shared space every team member can reach, rather than leaving it in a private tool, a personal notebook, or someone's head.

- [Summary](#summary)

### Rule ADR-DORAVM:2

Treat visual management as one leg of a combination, not a standalone practice: a display raises delivery performance when it is paired with
WIP limits and with feeding production telemetry back into business decisions, not when it stands alone as a dashboard nobody acts on.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAVM:3

Choose what a display shows together with the team that reads it, and keep each display simple and actionable. A complex display, or one the
team was never consulted on, does not get read and does not get acted on.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAVM:4

Treat the display as a means, never the goal. A team that keeps a dashboard current but does not change its behaviour from what the
dashboard shows has confused maintaining the display with solving the problem the display exists to surface.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORAVM:5

Review every display on a cadence — in a retrospective, ask whether it still gives people the information they need, whether it is up to
date, and whether anyone is acting on it — and adjust, replace, or retire it as the team's context changes.

- [How to apply](#how-to-apply)

## Context

Visual management is a lean-manufacturing practice carried into software delivery: the state of the work is put on display in a shared space
rather than kept in status meetings, spreadsheets, or individual memory. DORA frames it as one of the technical capabilities that predicts
software delivery performance, sitting alongside the other flow-visibility capabilities in the DORA Core Model.

Teams practicing lean development use these displays to build a shared understanding of where the team stands on operational effectiveness,
and to help the team notice obstacles to higher performance before those obstacles are reported through some slower channel.

## Summary

Visual management means displaying key information about team processes in shared spaces where everyone can see it. Common forms include
card walls or Kanban boards showing in-progress work, dashboards with visual indicators such as CI systems showing build status as traffic
lights, burn-up or burn-down charts and cumulative flow diagrams projecting when a backlog will complete, deployment pipeline monitors
tracking which builds are deployable and where a pipeline stage failed, and production telemetry monitors showing request volume, latency,
error counts, and popular pages.

The point of the practice is not the display itself but the shared, at-a-glance understanding it produces — a team looking at the same
picture of its own operational effectiveness, able to spot an obstacle without waiting for a meeting to surface it.

## Why it matters

DORA's research finds that visual management, combined with WIP limits and with feeding production telemetry back into business decisions,
is associated with higher levels of delivery performance. The three practices compound: a card wall shows what is in flight, a WIP limit
constrains how much can be in flight at once, and production telemetry closes the loop by showing what actually happened once work reached
users. Visual management on its own, disconnected from limits on work in progress or from real production signals, is a weaker version of
the capability than the combination DORA associates with the effect.

## How to apply

DORA's implementation guidance names retrospective as the mechanism for keeping a display honest: periodically ask whether the displays are
giving the team the information it needs, whether the information is up to date, whether people are acting on it, and whether the display is
driving measurable improvement toward the team's goals. A negative answer to any of those questions is the signal to investigate, then
adjust, eliminate, or prototype a replacement display — the practice is iterative, not a one-time setup.

This platform realizes the capability in a few places already. The value-chain diagrams render every commit's delivery state by construction
— position is time, colour is the furthest state reached — so a reader decodes where a change is at a glance instead of reconstructing it
from git history ([ADR-VISUAL](../design/visual-design.md)). The broader principle of making the state of the work visible, and judging
progress from the real running artifact rather than a proxy, is stated directly as observe-the-work
([ADR-OBSERVE](../process/observe-work.md)). Console output is treated as the CLI automation's only user-facing display surface, and is held
to the same bar the DORA page sets for a good dashboard — signal over noise, current, and actionable — so a console session is itself a form
of visual management for a tool with no GUI ([ADR-CONSOLE](../automation/powershell/console-output-matters.md)).

## Common pitfalls

- **Choosing metrics without the team.** Selecting what a display shows unilaterally, rather than with the people who will read and act on
  it, produces a display the team does not trust and does not use.
- **Building a display that is too complex to read.** A dashboard packed with numbers but short on actionable information fails the same
  test a good display is meant to pass: can someone glance at it and know what to do next.
- **Letting a display go stale.** A team's context changes — its bottlenecks move, its goals shift — and a display that never evolves to
  match stops answering the question it was built to answer.
- **Treating the display as the goal.** Maintaining a dashboard is not the same as fixing the problem the dashboard exists to surface; a
  display that looks healthy while the underlying process does not improve has become the target instead of the measure.

## References

[^1]:
    DORA, _Visual management_ capability, <https://dora.dev/capabilities/visual-management/>. Part of the DORA Core Model of capabilities
    that predict software delivery performance.

## Dora explains

Visual management is DORA's name for making the state of the value stream visible at a glance, and DORA ties it directly to two other
capabilities it studies alongside it: limiting work in progress, and feeding real production signals back into decisions.

- [Work visibility in the value stream](https://dora.dev/capabilities/work-visibility-in-value-stream/) — the end-to-end visibility that a
  well-built display is one instrument of.
- [WIP limits](https://dora.dev/capabilities/wip-limits/) — the practice DORA names as compounding with visual management to raise delivery
  performance.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — the production telemetry that feeds the
  monitors visual management describes.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
