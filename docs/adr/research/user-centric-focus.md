# ADR: DORA — User-centric focus

## Rules: ADR-DORAUCF

### Rule ADR-DORAUCF:1

Judge software by its usefulness to the individual at the end of the value chain, not by the volume of code or features produced along the
way — understanding actual user needs and prioritizing user experience are explicit design goals, not an afterthought left to whoever
happens to talk to a customer.

- [Summary](#summary)

### Rule ADR-DORAUCF:2

Treat AI as an amplifier of whatever focus already exists, not a substitute for it — a team without a user-centric practice that adopts AI
does not become user-centric by accident; it produces more low-value output, faster.

- [Why it matters](#why-it-matters)

### Rule ADR-DORAUCF:3

Wire user feedback into planning as a low-latency loop, and let it actually change priorities — a channel that collects feedback but never
causes work to be reprioritized is a suggestion box, not a feedback loop.

- [How to apply](#how-to-apply)

### Rule ADR-DORAUCF:4

Put user-experience metrics (satisfaction, adoption, retention, task completion) on the same dashboard as technical delivery metrics, and
give engineers direct exposure to user research — observing real usage or reading raw feedback — rather than routing everything through a
distilled summary that loses signal.

- [How to apply](#how-to-apply)

### Rule ADR-DORAUCF:5

Measure and reward outcomes, not output — features shipped, story points closed, or commit volume are not evidence that value reached a
user, and treating them as such is the feature-factory failure mode this capability exists to prevent.

- [Common pitfalls](#common-pitfalls)

## Context

User-centric focus sits in the DORA Core Model as a capability that predicts organizational performance rather than delivery throughput
directly: it is about whether the work a team does actually lands as value for the person using the software, not merely whether it ships.
DORA frames the underlying claim plainly: all software exists for human users, and its worth is determined by its usefulness to the
individual at the conclusion of the value chain.

In the AI era DORA sharpens this into a warning. AI does not introduce user-centricity on its own — it amplifies whatever focus a team
already has. A team that understands its users and prioritizes their experience gets more of that, faster, with AI's help. A team that does
not falls into a feature factory: AI accelerates the production of software that ships and measures well on internal activity metrics while
delivering little of what the user actually needed.

## Summary

The capability is a team's demonstrated understanding of user needs, its prioritization of user experience in what gets built, and its use
of user feedback to continuously reprioritize work. DORA reports that teams with this focus have 40% higher organizational performance than
teams without it.

The requirement is not a single user-research ritual but a continuous loop: needs are understood, experience is prioritized against that
understanding, feedback is gathered with low latency, and that feedback actually changes what the team works on next.

## Why it matters

DORA's research ties user-centric focus directly to organizational performance, and the AI era raises the stakes on it. AI is an amplifier:
magnifying an existing strength turns a user-centric team into one that ships more of what users actually need, faster; magnifying an
existing weakness turns a team without that focus into one that can "accelerate the production of low-value software, leading to high
activity but low impact." The mechanism is not that AI makes teams user-centric — it makes whichever pattern already exists more visible and
more consequential.

## How to apply

This platform treats console output as its user interface ([ADR-CONSOLE](../automation/powershell/console-output-matters.md)), because the
person running an automation function has no GUI or dashboard to fall back on — every decision about what a line of output says, and whether
it says anything at all, is a user-experience decision, not merely a logging concern. Sensible defaults
([ADR-DEFAULT](../automation/sensible-defaults.md)) apply the same lens to the calling code itself: a function's parameter surface is
designed around what the caller most likely wants, so the caller's actual need drives the interface rather than the implementation's
internal shape. Zero-ceremony design ([ADR-ZERO](../automation/zero-ceremony-poka-yoke.md)) extends this to the contributor experience of
the platform, judging every addition by whether it removes friction for the person using it rather than by whether it is convenient to
build.

## Common pitfalls

- **Feature factory mindset.** Measuring output — features shipped, story points, commits — instead of outcomes such as user satisfaction,
  retention, and task success rewards activity that AI can trivially inflate without adding value.
- **Resume-driven development.** Adopting a technology because it is interesting or advances a career rather than because it serves an
  actual user need.
- **Organizational silos.** Structures that keep developers away from end users and user research, leaving them to build from secondhand,
  distilled requirements instead of firsthand understanding.

## References

[^1]:
    DORA, _User-centric focus_ capability, <https://dora.dev/capabilities/user-centric-focus/>. Part of the DORA Core Model of capabilities
    that predict software delivery performance.

## Dora explains

User-centric focus is the capability that keeps DORA's delivery metrics pointed at something that matters: deploying frequently and
recovering quickly are only valuable if what gets deployed is what the user needed in the first place.

- [Customer feedback](https://dora.dev/capabilities/customer-feedback/) — the feedback channel this capability turns into reprioritized
  work.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — the batch size that lets user feedback actually
  change what ships next.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — the dashboards that make user-experience
  metrics visible alongside technical ones.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
