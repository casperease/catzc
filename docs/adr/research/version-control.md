---
catzc:
  derived:
    path: docs/adr/research/version-control.md
    kind: adr
    language: markdown
    track: docs
    body_sha: "018c90c9fb6e"
    defines:
      - ADR-DORA-VCS#{1-4}
    links:
      - docs/adr/design/server-remote-integration.md
      - docs/adr/flow/cd-discipline-and-promotion-flow.md
      - docs/adr/principles/everything-as-code.md
      - docs/adr/principles/one-living-version.md
      - docs/references/dora/ai.md#ai-capabilities-model
      - docs/references/dora/ai.md#individual-effectiveness
      - docs/references/dora/ai.md#team-performance
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#continuous-integration
      - docs/references/dora/capabilities.md#deployment-automation
      - docs/references/dora/capabilities.md#fast-flow
      - docs/references/dora/capabilities.md#trunk-based-development
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/core-model.md#fast-flow
      - docs/references/dora/core-model.md#software-delivery-performance
      - docs/references/dora/index.md
      - docs/references/dora/publications.md#2014-state-of-devops-report
      - docs/references/dora/publications.md#2017-state-of-devops-report
      - docs/references/dora/publications.md#2019-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2022-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2025-dora-ai-capabilities-model
      - docs/references/dora/publications.md#2025-state-of-ai-assisted-software-development
      - "https://dora.dev/capabilities/version-control/"
---

# ADR: DORA — Version control

## Rules: ADR-DORA-VCS

### Rule ADR-DORA-VCS:1

Everything required to reproduce a build, deployment, or environment lives in version control — application code, scripts, configuration,
infrastructure definitions, and pipeline definitions — not only the application source.

- [Summary](#summary)

### Rule ADR-DORA-VCS:2

Version control exists to serve two properties: reproducibility (any past state can be rebuilt from the recorded history) and traceability
(every change is attributable to an author, a time, and a reason).

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-VCS:3

Comprehensive versioning is the scope, not partial versioning — a system whose code is tracked but whose configuration or infrastructure is
not is only partly under version control, and the untracked part is where irreproducible drift accumulates.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-VCS:4

Inner-loop discipline is part of the capability — frequent, small commits with clear messages are what make the history a usable safety net;
large, infrequent commits and unmanaged merge conflicts erode it.

- [Common pitfalls](#common-pitfalls)

## Context

Version control is the most foundational of DORA's technical capabilities: continuous integration, continuous delivery, deployment
automation, and trunk-based development all assume it. DORA defines the capability as using a version control system for every production
artifact: application code, application and system configuration, and the scripts that build and configure environments. The systems
themselves — "Git, Subversion, and Mercurial" — "provide a logical means to organize files and coordinate their creation, controlled access,
updating, and deletion across teams and organizations".[^1]

It sits in the fast-flow group of the DORA Core Model, where comprehensive use predicts continuous delivery: teams that comprehensively
version their artifacts recover faster, audit more easily, and change more safely. In the AI era DORA frames it further as a safety net —
frequent commits bound the blast radius of fast, machine-assisted change, and prompts and model configuration become artifacts worth
versioning like any other.

## Summary

The capability is comprehensive version control: keeping in a version control system every artifact needed to build, test, deploy, and
operate the system. DORA highlights five benefits — disaster recovery, auditability, quality improvement, capacity management, and faster
defect response — all of which flow from a single, recoverable, attributable history of every change.

The requirement is not merely "use Git" but versioning the full set of artifacts: source, build and deployment scripts, application and
system configuration, container definitions, infrastructure-as-code, and (increasingly) AI prompts and configuration.

## Why it matters

DORA's research associates comprehensive version control with higher software delivery performance and faster recovery. The mechanism is
reproducibility and traceability: when any state can be rebuilt and every change is attributable, disaster recovery becomes a checkout,
auditing becomes reading history, and diagnosing a defect becomes bisecting a known sequence of changes rather than reconstructing what
happened. Without it, each of those becomes archaeology.

## How to apply

This platform realizes the capability by keeping every operational artifact in the repository
([ADR-PRIN-EAC](../principles/everything-as-code.md)) and carrying exactly one living version of each
([ADR-PRIN-ONELIVE](../principles/one-living-version.md)) with all history in git rather than in retained files. Trunk-based development and
short-lived branches ([ADR-FLOW-CD](../flow/cd-discipline-and-promotion-flow.md)) keep the inner-loop discipline this capability depends on,
and the audited server remote ([ADR-DSGN-REMOTE](../design/server-remote-integration.md)) is the single source of truth for what is on main.

## Common pitfalls

- **Limited scope.** Versioning application code while leaving configuration, infrastructure, or pipeline definitions outside version
  control — the untracked artifacts are exactly where irreproducible drift hides.
- **Neglecting inner-loop discipline.** Large, infrequent commits with vague messages turn the history into a liability rather than a safety
  net; the value is in small, frequent, well-described changes.
- **Unmanaged merge conflicts.** Long-lived branches that defer integration produce painful conflicts, discouraging the frequent commits the
  capability relies on.

## References

[^1]:
    DORA, _Version control_ capability, <https://dora.dev/capabilities/version-control/>. Part of the DORA Core Model of capabilities that
    predict software delivery performance.

## Dora explains

Version control is the base on which DORA's delivery capabilities rest. It is a fast-flow capability in the Core Model, where comprehensive
use predicts continuous delivery, and one of the seven capabilities of the AI Capabilities Model, where strong practice — frequent commits
and reliance on rollback — is the safety net that makes fast, AI-driven change safe to experiment with.

- **Catalogue entry:** [Version control](../../references/dora/capabilities.md#version-control)
- **Category:** [Fast flow](../../references/dora/capabilities.md#fast-flow) — Core Model v2.1.0:
  [fast flow](../../references/dora/core-model.md#fast-flow); also a member of the
  [AI Capabilities Model](../../references/dora/ai.md#ai-capabilities-model) as "Strong version control practices".
- **Evidence:**
  - [2014 State of DevOps Report](../../references/dora/publications.md#2014-state-of-devops-report) — version control and continuous
    delivery correlate with high IT performance.
  - [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — version control is one of the
    practices essential to continuous delivery.
  - [2019 Accelerate State of DevOps Report](../../references/dora/publications.md#2019-accelerate-state-of-devops-report) — cited on the
    capability page as evidence for the capability.
  - [2022 Accelerate State of DevOps Report](../../references/dora/publications.md#2022-accelerate-state-of-devops-report) — teams combining
    version control and continuous delivery are 2.5× more likely to have high delivery performance.
  - [2025 State of AI-assisted Software Development](../../references/dora/publications.md#2025-state-of-ai-assisted-software-development) —
    introduces the AI Capabilities Model, with strong version control practices as one of its seven capabilities.
  - [2025 DORA AI Capabilities Model](../../references/dora/publications.md#2025-dora-ai-capabilities-model) — implementation strategies and
    ways to monitor progress for each of the seven capabilities.
- **Predicts:** comprehensive use predicts [continuous delivery](../../references/dora/capabilities.md#continuous-delivery), and through it
  [software delivery performance](../../references/dora/core-model.md#software-delivery-performance). With AI, strong practice amplifies AI
  adoption's positive effect on [individual effectiveness](../../references/dora/ai.md#individual-effectiveness) and
  [team performance](../../references/dora/ai.md#team-performance).
- **Related capabilities:**
  - [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — integrates versioned changes continuously;
    impossible without version control.
  - [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — the branching discipline that keeps the
    history a usable safety net.
  - [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — automates deployment from versioned definitions.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
