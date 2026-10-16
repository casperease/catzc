---
catzc:
  immutable:
    with_body_sha: f9bb86787adb
    path: docs/adr/research/user-centric-focus.md
    folder: docs/adr/research
    name: user-centric-focus
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-DORA-USERFOCUS#{1-5}
    links:
      - docs/adr/automation/console-output-matters.md
      - docs/adr/automation/sensible-defaults.md
      - docs/adr/automation/zero-ceremony-poka-yoke.md
      - docs/references/dora/ai.md#ai-capabilities-model
      - docs/references/dora/ai.md#individual-effectiveness
      - docs/references/dora/ai.md#team-performance
      - docs/references/dora/capabilities.md#ai
      - docs/references/dora/capabilities.md#customer-feedback
      - docs/references/dora/capabilities.md#job-satisfaction
      - docs/references/dora/capabilities.md#monitoring-and-observability
      - docs/references/dora/capabilities.md#user-centric-focus
      - docs/references/dora/capabilities.md#working-in-small-batches
      - docs/references/dora/core-model.md#organizational-performance
      - docs/references/dora/core-model.md#well-being
      - docs/references/dora/index.md
      - docs/references/dora/publications.md#2023-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2024-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2025-dora-ai-capabilities-model
      - docs/references/dora/publications.md#2025-state-of-ai-assisted-software-development
      - "https://dora.dev/capabilities/user-centric-focus/"
---

# ADR: DORA — User-centric focus

## Rules: ADR-DORA-USERFOCUS

### Rule ADR-DORA-USERFOCUS:1

Judge software by its usefulness to the individual at the end of the value chain, not by the volume of code or features produced along the
way — understanding actual user needs and prioritizing user experience are explicit design goals, not an afterthought left to whoever
happens to talk to a customer.

- [Summary](#summary)

### Rule ADR-DORA-USERFOCUS:2

Treat AI as an amplifier of whatever focus already exists, not a substitute for it — a team without a user-centric practice that adopts AI
does not become user-centric by accident; it produces more low-value output, faster.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-USERFOCUS:3

Wire user feedback into planning as a low-latency loop, and let it actually change priorities — a channel that collects feedback but never
causes work to be reprioritized is a suggestion box, not a feedback loop.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-USERFOCUS:4

Put user-experience metrics (satisfaction, adoption, retention, task completion) on the same dashboard as technical delivery metrics, and
give engineers direct exposure to user research — observing real usage or reading raw feedback — rather than routing everything through a
distilled summary that loses signal.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-USERFOCUS:5

Measure and reward outcomes, not output — features shipped, story points closed, or commit volume are not evidence that value reached a
user, and treating them as such is the feature-factory failure mode this capability exists to prevent.

- [Common pitfalls](#common-pitfalls)

## Context

User-centric focus sits in the DORA AI Capabilities Model as a capability that predicts organizational performance rather than delivery
throughput directly: it is about whether the work a team does actually lands as value for the person using the software, not merely whether
it ships. DORA frames the underlying claim plainly: all software exists for human users, and its worth is determined by its usefulness to
the individual at the conclusion of the value chain.[^1]

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

This platform treats console output as its user interface ([ADR-AUTO-CONSOLE](../automation/console-output-matters.md)), because the person
running an automation function has no GUI or dashboard to fall back on — every decision about what a line of output says, and whether it
says anything at all, is a user-experience decision, not merely a logging concern. Sensible defaults
([ADR-AUTO-DEFAULT](../automation/sensible-defaults.md)) apply the same lens to the calling code itself: a function's parameter surface is
designed around what the caller most likely wants, so the caller's actual need drives the interface rather than the implementation's
internal shape. Zero-ceremony design ([ADR-AUTO-ZERO](../automation/zero-ceremony-poka-yoke.md)) extends this to the contributor experience
of the platform, judging every addition by whether it removes friction for the person using it rather than by whether it is convenient to
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
    DORA, _User-centric focus_ capability, <https://dora.dev/capabilities/user-centric-focus/>. Part of the DORA AI Capabilities Model of
    capabilities that amplify the benefits of AI adoption.

## Dora explains

User-centric focus is the capability that keeps DORA's delivery metrics pointed at something that matters: deploying frequently and
recovering quickly are only valuable if what gets deployed is what the user needed in the first place. DORA categorizes it with the AI
capabilities and the AI Capabilities Model, outside the Core Model, where it keeps AI-accelerated velocity pointed at valuable outcomes; it
also predicts higher organizational performance and job satisfaction in its own right.

- **Catalogue entry:** [User-centric focus](../../references/dora/capabilities.md#user-centric-focus)
- **Category:** [AI](../../references/dora/capabilities.md#ai) — not in the Core Model; a member of the
  [AI Capabilities Model](../../references/dora/ai.md#ai-capabilities-model).
- **Evidence:**
  - [2023 Accelerate State of DevOps Report](../../references/dora/publications.md#2023-accelerate-state-of-devops-report) — teams that
    focus on users have 40% higher organizational performance (repeated in 2024).
  - [2024 Accelerate State of DevOps Report](../../references/dora/publications.md#2024-accelerate-state-of-devops-report) — user-centricity
    drives product quality, and user-centred developers are more productive, more satisfied, and less likely to burn out.
  - [2025 State of AI-assisted Software Development](../../references/dora/publications.md#2025-state-of-ai-assisted-software-development) —
    finds that AI is mainly an amplifier of existing strengths and dysfunctions, and introduces the AI Capabilities Model.
  - [2025 DORA AI Capabilities Model](../../references/dora/publications.md#2025-dora-ai-capabilities-model) — gives implementation
    strategies, starter tactics, and ways to monitor progress for the capability.
- **Predicts:** higher [organizational performance](../../references/dora/core-model.md#organizational-performance) and
  [job satisfaction](../../references/dora/capabilities.md#job-satisfaction), part of
  [well-being](../../references/dora/core-model.md#well-being). With AI, a strong user focus amplifies
  [individual effectiveness](../../references/dora/ai.md#individual-effectiveness) and
  [team performance](../../references/dora/ai.md#team-performance); without one, AI adoption can harm team performance (the "feature
  factory" trap).
- **Related capabilities:**
  - [Customer feedback](../../references/dora/capabilities.md#customer-feedback) — the feedback channel this capability turns into
    reprioritized work.
  - [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — the batch size that lets user feedback
    actually change what ships next.
  - [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — the dashboards that make
    user-experience metrics visible alongside technical ones.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
