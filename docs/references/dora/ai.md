# DORA and AI-assisted software development

Since 2024 DORA's research has centred on AI. The [AI section](https://dora.dev/ai/) summarizes that line of work as AI reshaping software
delivery and organizational performance. Its central finding, from the
[2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development) report, is that AI acts
mainly as an **amplifier**: it magnifies an organization's existing strengths and its existing dysfunctions. The biggest returns come from
attending to the underlying organizational system, not from the tools themselves
([2025 report page](https://dora.dev/research/2025/dora-report/)).

This file covers the DORA AI Capabilities Model and the sequence of AI publications. The five AI-only capabilities have catalogue entries in
[capabilities.md](capabilities.md#ai).

## AI Capabilities Model

The DORA AI Capabilities Model identifies **seven capabilities** that amplify the benefits of AI adoption. It was introduced in the 2025
State of AI-assisted Software Development report (September 2025). A companion report, the
[DORA AI Capabilities Model report](publications.md#2025-dora-ai-capabilities-model) (December 2025), gives implementation strategies,
starter tactics, and ways to monitor progress for each capability
([AI Capabilities Model report](https://dora.dev/ai/capabilities-model/report/)).

The model is drawn as an interaction, not a chain. **AI adoption × capability** feeds a set of outcomes: each capability changes how
strongly, and in which direction, AI adoption affects the outcomes it is connected to. The model sits beside the
[Core Model](core-model.md), not inside it. Core V2 left AI practices out because the research was not yet sufficient
([Core V2 discussion](https://github.com/dora-team/dora.dev/discussions/582)). Two capabilities, version control and working in small
batches, belong to both models.

### Capabilities

- **User-centric focus**
  - Capability entry: [user-centric-focus](capabilities.md#user-centric-focus)
  - One-line role (paraphrased from the model): Keeps AI-accelerated teams moving in the right direction
- **Strong version control practices**
  - Capability entry: [version-control](capabilities.md#version-control)
  - One-line role (paraphrased from the model): The safety net that makes experimenting with fast AI-driven change safe
- **AI-accessible internal data**
  - Capability entry: [ai-accessible-internal-data](capabilities.md#ai-accessible-internal-data)
  - One-line role (paraphrased from the model): Turns AI from a generic assistant into an expert on the organization's own context
- **Working in small batches**
  - Capability entry: [working-in-small-batches](capabilities.md#working-in-small-batches)
  - One-line role (paraphrased from the model): Counters large, unstable AI-generated changes so speed becomes product value
- **Clear + communicated AI stance**
  - Capability entry: [clear-and-communicated-ai-stance](capabilities.md#clear-and-communicated-ai-stance)
  - One-line role (paraphrased from the model): Removes ambiguity and gives the psychological safety to experiment
- **Quality internal platform**
  - Capability entry: [platform-engineering](capabilities.md#platform-engineering)
  - One-line role (paraphrased from the model): Provides automated, secure pathways that let AI's benefits scale
- **Healthy data ecosystems**
  - Capability entry: [healthy-data-ecosystems](capabilities.md#healthy-data-ecosystems)
  - One-line role (paraphrased from the model): High-quality, accessible, unified internal data that amplifies AI's benefits

### Outcomes

The model's outcomes are measured from the individual's point of view (definitions paraphrased from the model):

#### Team performance

How effective and collaborative the person's immediate team is perceived to be.

#### Code quality

The person's assessment of the quality of the code behind the main application or service they work on.

#### Individual effectiveness

The person's own sense of effectiveness and accomplishment at work.

#### Product performance

How successful and good the team's product or service is: whether it helps users do important tasks and keeps their information safe, and
how it performs on measures such as latency.

#### Reduced friction

Friction is whatever gets in the way of a person's work, so less friction is a positive outcome.

#### Software delivery throughput

The speed and efficiency of the delivery process. See [throughput](metrics.md#throughput).

#### Organizational performance

The organization's overall success, in terms such as profitability, market share, and customer satisfaction. See
[organizational performance](core-model.md#organizational-performance).

### Connections

Each cell marks an outcome that the model diagram connects to a capability. Read a mark as: this capability amplifies AI adoption's effect
on this outcome. There are 17 connections.

- **User-centric focus**
  - Team perf.: x
- **Strong version control practices**
  - Team perf.: x
  - Individual effectiveness: x
- **AI-accessible internal data**
  - Code quality: x
  - Individual effectiveness: x
  - Product perf.: x
- **Working in small batches**
  - Individual effectiveness: x
  - Product perf.: x
  - Reduced friction: x
- **Clear + communicated AI stance**
  - Individual effectiveness: x
  - Product perf.: x
  - Reduced friction: x
  - Throughput: x
  - Org. perf.: x
- **Quality internal platform**
  - Reduced friction: x
  - Org. perf.: x
- **Healthy data ecosystems**
  - Org. perf.: x

The capability pages word some of these effects in more detail:

- **Clear and communicated AI stance:** on friction, it turns AI's otherwise neutral effect into a decrease in friction.
- **Working in small batches:** on friction, it turns AI's neutral effect into a net positive.
- **User-centric focus:** the page also names individual effectiveness; with no user focus, AI can harm team performance.
- **Quality internal platform:** on a low-quality platform, AI's effect on organizational performance is negligible.

## AI research line

DORA's AI work as listed on the site, oldest first. Report details are in [publications.md](publications.md).

- **August 2024**
  - Publication: [2024 report AI preview](https://dora.dev/research/2024/ai-preview/)
  - Contribution: Reliance, where developers use AI, trust (24% trust AI-generated code a lot or a great deal)
- **October 2024**
  - Publication: [2024 Accelerate State of DevOps Report](publications.md#2024-accelerate-state-of-devops-report)
  - Contribution: AI boosts individual productivity, flow, and satisfaction but hurts delivery throughput and stability
- **March 2025**
  - Publication: [Impact of Generative AI in Software Development](publications.md#2025-impact-of-generative-ai-in-software-development)
  - Contribution: The "vacuum hypothesis", trust as a driver, adoption strategies for organizations
- **September 2025**
  - Publication: [2025 State of AI-assisted Software Development](publications.md#2025-state-of-ai-assisted-software-development)
  - Contribution: AI as amplifier; the AI Capabilities Model introduced
- **December 2025**
  - Publication: [DORA AI Capabilities Model report](publications.md#2025-dora-ai-capabilities-model)
  - Contribution: How to implement and measure the seven capabilities
- **April 2026**
  - Publication: [ROI of AI-assisted Software Development](publications.md#2026-roi-of-ai-assisted-software-development)
  - Contribution: A framework and calculator for the return on AI adoption

Supporting insight articles on the AI page cover trust in AI, concerns beyond accuracy (deskilling, job displacement, malicious use), the
value of development work, the "builder's mindset", AI as a tutor, managing AI dependency, and balancing AI tensions
([AI](https://dora.dev/ai/), [2025 year in review](https://dora.dev/insights/dora-2025-year-in-review/)). There is also a guide:
[How to enable your software delivery teams to innovate with generative AI](https://dora.dev/guides/how-to-innovate-with-generative-ai/).

## Sources

Retrieved 2026-10-13.

- <https://dora.dev/ai/>
- <https://dora.dev/ai/capabilities-model/report/>
- <https://dora.dev/ai/capabilities-model/questions/>
- <https://dora.dev/ai/gen-ai-report/report/>
- <https://dora.dev/ai/roi/report/>
- <https://dora.dev/research/2024/ai-preview/>
- <https://dora.dev/research/2024/dora-report/>
- <https://dora.dev/research/2025/dora-report/>
- <https://dora.dev/insights/dora-2025-year-in-review/>
- <https://dora.dev/capabilities/clear-and-communicated-ai-stance/>, <https://dora.dev/capabilities/working-in-small-batches/>,
  <https://dora.dev/capabilities/user-centric-focus/>, <https://dora.dev/capabilities/platform-engineering/>
- <https://github.com/dora-team/dora.dev/discussions/582> (Core V2 discussion)
- <https://github.com/dora-team/dora.dev/blob/main/svelte/ai-model/src/data.json> (model capabilities, outcomes, and connections, commit
  `b14ae08`)
- <https://dora.dev/ai/capabilities-model/model.js> (live model bundle, checked for the same 17 connections)
