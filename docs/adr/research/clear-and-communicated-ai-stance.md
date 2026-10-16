---
catzc:
  derived:
    path: docs/adr/research/clear-and-communicated-ai-stance.md
    kind: adr
    language: markdown
    filekind: md
    track: docs
    body_sha: b477e777a6cd
    defines:
      - ADR-DORA-AISTANCE#{1-5}
    links:
      - docs/references/dora/ai.md#ai-capabilities-model
      - docs/references/dora/ai.md#individual-effectiveness
      - docs/references/dora/ai.md#organizational-performance
      - docs/references/dora/ai.md#product-performance
      - docs/references/dora/ai.md#reduced-friction
      - docs/references/dora/ai.md#software-delivery-throughput
      - docs/references/dora/capabilities.md#ai
      - docs/references/dora/capabilities.md#ai-accessible-internal-data
      - docs/references/dora/capabilities.md#clear-and-communicated-ai-stance
      - docs/references/dora/capabilities.md#generative-organizational-culture
      - docs/references/dora/capabilities.md#healthy-data-ecosystems
      - docs/references/dora/index.md
      - docs/references/dora/metrics.md#throughput
      - docs/references/dora/publications.md#2024-accelerate-state-of-devops-report
      - docs/references/dora/publications.md#2025-dora-ai-capabilities-model
      - docs/references/dora/publications.md#2025-impact-of-generative-ai-in-software-development
      - docs/references/dora/publications.md#2025-state-of-ai-assisted-software-development
      - "https://dora.dev/capabilities/clear-and-communicated-ai-stance/"
---

# ADR: DORA — Clear and communicated AI stance

## Rules: ADR-DORA-AISTANCE

### Rule ADR-DORA-AISTANCE:1

An AI stance is a living, actionable framework, not a static legal document — it tells developers how the organization expects them to use
AI, which tools are sanctioned, and how the organization supports that use.

- [Summary](#summary)

### Rule ADR-DORA-AISTANCE:2

A stance only works when a developer can answer four questions from it: whether AI use is expected, whether experimentation is supported,
which tools are permitted, and how the policy applies to their own role — ambiguity in any one of these pushes developers toward hiding
their AI use or avoiding it altogether.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-AISTANCE:3

Classify every tool and use case into one of three buckets — prohibited, permitted with guardrails, or allowed — and publish that
classification as a living document with a working feedback loop, not a policy issued once and left to go stale.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-AISTANCE:4

Revise the stance on a cadence that matches how fast AI tooling actually changes; treating it as fixed lets it fall behind, but revising it
faster than developers can absorb produces policy whiplash that is just as damaging.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-AISTANCE:5

Draft and own the stance with a cross-functional group — engineering, legal, security, IT, and product — so the result is practical for the
engineering work it governs, rather than a single department's policy applied to engineering from outside.

- [Common pitfalls](#common-pitfalls)

## Context

A clear and communicated AI stance is DORA's capability for how an organization tells its developers what is expected of them around AI:
which tools they may use, what guardrails apply, and what support exists when they try. DORA frames it as a "comprehensible, widely
socialized framework that tells developers: 'Here is how we expect you to use AI, here are the tools you can use, and here is how we support
you.'"[^1]

It sits among DORA's newer, AI-specific capabilities, alongside AI-accessible internal data and healthy data ecosystems: capabilities that
condition how much benefit an organization actually captures from AI adoption, as distinct from the core capabilities that predict delivery
performance generally. Without a clear stance, the same AI tooling produces inconsistent, anxious, or hidden usage instead of a consistent
lift in effectiveness.

## Summary

A clear and communicated AI stance moves an organization's AI policy out of static legal documents and into an actionable guide embedded in
day-to-day culture. It succeeds when a developer perceives four things from it: that AI use is **expected**, that the organization
**supports** experimentation, that **permitted** tools are clearly identified, and that the policy's **applicability** to their own role is
plain.

DORA's implementation guidance names five steps: secure executive sponsorship for the AI mission and adoption plan; form a cross-functional
working group spanning engineering, legal, security, IT, and product; adopt a three-bucket framework that sorts tools and use cases into
prohibited, permitted with guardrails, or allowed; publish the result as a living document in a searchable developer hub with an evolving
FAQ; and socialize it through launches such as town halls while keeping a feedback loop open so the policy can evolve.

## Why it matters

DORA research finds, with a high degree of certainty, that a clear and communicated AI stance amplifies AI's positive influence on both
individual effectiveness and organizational performance. A stance that meets the four perception criteria above turns AI from a source of
anxiety into a tool for reducing friction.

The failure mode it prevents is ambiguity: when developers cannot tell what is expected, permitted, or supported, they respond by hiding
their AI use — shadow AI — or by avoiding the tools entirely, forfeiting the benefit an organization intended to capture by adopting AI in
the first place.

## How to apply

Applying this capability means treating the AI stance itself as a product with an owner, not a one-off memo: executive sponsorship gives it
a mandate, a cross-functional working group keeps it grounded in what is actually practical for engineering work, the three-bucket framework
gives developers an unambiguous answer for any given tool, and a living document with an open feedback channel lets the policy keep pace
with how the tools and the organization's experience with them change.

## Common pitfalls

- **Treating the stance as a "one-time" policy.** AI tooling and practice change on a monthly cadence; a stance published once and left
  untouched drifts out of date and stops answering the questions developers actually have.

- **The "whiplash" effect.** Revising the policy so often, or so abruptly, that developers cannot keep up erodes the same trust that a clear
  stance is meant to build — change needs room to be absorbed, not just announced.

- **Myopic authorship.** A stance drafted by a single department — legal or security alone, for instance — in isolation from engineering
  tends to ignore practical engineering realities, producing rules developers cannot actually follow.

## References

[^1]:
    DORA, _Clear and communicated AI stance_ capability, <https://dora.dev/capabilities/clear-and-communicated-ai-stance/>. Part of DORA's
    AI-capabilities research on how organizations shape the effect of AI adoption on delivery performance.

## Dora explains

Clear and communicated AI stance is one of the five capabilities DORA introduced with its AI Capabilities Model, outside the Core Model, and
it is the most widely connected capability in that model: the diagram links it to five of the seven outcomes. Without a clear stance on
expected, permitted, and supported AI use, the same tooling produces hidden or avoided usage instead of a lift in individual and
organizational performance.

- **Catalogue entry:** [Clear and communicated AI stance](../../references/dora/capabilities.md#clear-and-communicated-ai-stance)
- **Category:** [AI](../../references/dora/capabilities.md#ai) — not in the Core Model; a member of the
  [AI Capabilities Model](../../references/dora/ai.md#ai-capabilities-model) as "Clear + communicated AI stance".
- **Evidence:**
  - [2025 State of AI-assisted Software Development](../../references/dora/publications.md#2025-state-of-ai-assisted-software-development) —
    finds that AI is mainly an amplifier of existing strengths and dysfunctions, and introduces the AI Capabilities Model.
  - [2025 DORA AI Capabilities Model](../../references/dora/publications.md#2025-dora-ai-capabilities-model) — gives implementation
    strategies, starter tactics, and ways to monitor progress for the capability.
  - [2025 Impact of Generative AI](../../references/dora/publications.md#2025-impact-of-generative-ai-in-software-development) — clear
    acceptable-use policies are associated with a 451% increase in team AI adoption.
  - [2024 Accelerate State of DevOps Report](../../references/dora/publications.md#2024-accelerate-state-of-devops-report) — its August 2024
    AI preview found mixed views of how transparent organizations are about AI.
- **Predicts:** amplifies AI's positive effect on [individual effectiveness](../../references/dora/ai.md#individual-effectiveness),
  [organizational performance](../../references/dora/ai.md#organizational-performance), and
  [software delivery throughput](../../references/dora/ai.md#software-delivery-throughput) (the
  [throughput](../../references/dora/metrics.md#throughput) family), and turns AI's otherwise neutral effect on friction into
  [reduced friction](../../references/dora/ai.md#reduced-friction). The model diagram adds
  [product performance](../../references/dora/ai.md#product-performance).
- **Related capabilities:**
  - [AI-accessible internal data](../../references/dora/capabilities.md#ai-accessible-internal-data) — a companion AI capability; a clear
    stance on how AI may use internal data is part of what the policy must communicate.
  - [Healthy data ecosystems](../../references/dora/capabilities.md#healthy-data-ecosystems) — the data-quality foundation an AI stance
    assumes when it tells developers which AI-assisted uses are safe to rely on.
  - [Generative organizational culture](../../references/dora/capabilities.md#generative-organizational-culture) — the culture of trust and
    information flow that determines whether a published stance is actually believed and followed.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
