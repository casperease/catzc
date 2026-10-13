# docs/adr/research/healthy-data-ecosystems.md

`ADR: DORA — Healthy data ecosystems`

## Rules: ADR-DORA-DATAECO

### Rule ADR-DORA-DATAECO:1

A data ecosystem is healthy along three properties at once — high-quality, easily accessible, and unified — and all three matter together;
improving one while neglecting the others still leaves the ecosystem unhealthy.

- [Summary](#summary)

### Rule ADR-DORA-DATAECO:2

Data health is a moderator of AI's effect on performance, not an independent contributor: the same AI adoption compounds the strengths of a
healthy data ecosystem and compounds the dysfunctions of an unhealthy one, so data health decides which direction the amplification runs.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-DATAECO:3

Every critical data domain has a named owner or steward accountable for its accuracy, its metadata, and its access policy; data is treated
as a product with consumers, never as incidental exhaust from the applications that happen to produce it.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-DATAECO:4

Data quality is checked the way code is tested — with automated, continuous checks for accuracy, completeness, and timeliness — and every
critical dataset carries documentation and metadata alongside it, versioned as a code artifact rather than kept in a separate system that
drifts out of sync.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-DATAECO:5

Quality data is discoverable and accessible under governance, never locked away behind a single tool or team; a platform that makes data
hard to find or reach is indistinguishable, in effect, from data that does not exist.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-DATAECO:6

Data health work starts with a pilot on one high-value dataset or service and expands from a working example, rather than attempting to fix
an entire data estate at once.

- [Common pitfalls](#common-pitfalls)

## Context

Healthy data ecosystems belongs to DORA's AI-capability set, alongside AI-accessible internal data and a clear, communicated AI stance. DORA
defines it as internal data that is "high-quality, easily accessible, and unified" and calls it "a foundational capability that
significantly amplifies the positive influence of AI adoption on organizational performance."[^1]

It sits in the DORA AI Capabilities Model as a moderator rather than a standalone predictor of delivery performance: it does not push
performance up or down on its own so much as decide how much of AI's effect — in either direction — actually reaches the organization. DORA
frames AI itself as an amplifier, one that "magnifies the strengths of high-performing organizations and the dysfunctions of struggling
ones," and healthy data is the condition that determines which of those two outcomes an organization gets.

## Summary

The capability is a data ecosystem that is high-quality, easily accessible, and unified — three properties, not one, and DORA ties them
directly to generative AI's dependence on context: "the adage 'garbage in, garbage out' has never been more relevant. Generative AI tools
are only as effective as the context they are given."

DORA's implementation guidance names five practices: treat data as a product with a named owner rather than a by-product of applications;
prioritize a single source of truth per data domain over siloed copies; apply automated data quality frameworks the way code carries
automated tests; democratize access to quality data under governance instead of locking it away; and keep documentation and metadata
alongside the data itself, as a versioned artifact rather than a separate system of record.

## Why it matters

DORA's research finds that AI's positive effect on organizational performance depends on the health of the underlying data: "when data
health is high, AI's positive influence on organizational performance is significantly amplified." The same adoption in a fragmented or
low-quality data environment does not merely fail to help — DORA warns it "can accelerate the generation of incorrect or irrelevant
outputs," because AI tools are only as effective as the context and data they are given.

The mechanism is amplification, not simple addition: a healthy data ecosystem compounds the return on AI adoption, and an unhealthy one
compounds its cost. Treating data health as optional while investing in AI adoption risks paying for the acceleration of the wrong outcomes.

## How to apply

The templating data model resolves every Azure identity fact through one config layer, keyed by name and validated by its config type,
`AzureConfig` ([ADR-AZ-DATAMOD](../azure/azure-data-model.md)) — one source of truth per record rather than a fact duplicated, and free to
drift, across templates. Config-value addressing turns any committed config node into a citable, dereferenceable handle
(`global.<config>.<key>`, [ADR-CONF-ADDRESSING](../configuration/config-value-addressing.md)) instead of a copied literal, keeping the
documentation of "where a value comes from" next to the value rather than in a separate note. Module config loading's single reader and
typed validation ([ADR-CONF-LOADING](../configuration/module-config-loading.md)) give every named config exactly one cache and one automated
check — every shipped config has a C# config type ([ADR-CONF-LOADING#4](../configuration/module-config-loading.md#rule-adr-conf-loading4))
that validates it once on load — rather than ad hoc, per-caller checks that drift apart over time.

## Common pitfalls

- **The tool is the silo.** Letting a specific tool's storage format or API dictate the data architecture; the data ends up reachable only
  through that one tool, recreating the silo the practice was meant to eliminate.
- **Data as a by-product.** Treating data as incidental exhaust from applications rather than a product with an accountable owner; nobody is
  responsible for its accuracy or metadata, and it decays into a "data swamp" that confuses humans and AI alike.
- **Boiling the ocean.** Attempting to fix an entire data estate simultaneously instead of piloting the practice on one high-value dataset
  or service and expanding outward from a working example.

## References

[^1]:
    DORA, _Healthy data ecosystems_ capability, <https://dora.dev/capabilities/healthy-data-ecosystems/>. Part of the DORA AI Capabilities
    Model of capabilities that amplify the benefits of AI adoption.

## Dora explains

Healthy data ecosystems is one of the five capabilities DORA introduced with its AI Capabilities Model, outside the Core Model, and the page
calls it a prerequisite for AI adoption. It does not predict performance on its own; it moderates how far AI adoption's effect on
organizational performance reaches, and with fragmented data AI produces wrong answers faster.

- **Catalogue entry:** [Healthy data ecosystems](../../references/dora/capabilities.md#healthy-data-ecosystems)
- **Category:** [AI](../../references/dora/capabilities.md#ai) — not in the Core Model; a member of the
  [AI Capabilities Model](../../references/dora/ai.md#ai-capabilities-model).
- **Evidence:**
  - [2025 State of AI-assisted Software Development](../../references/dora/publications.md#2025-state-of-ai-assisted-software-development) —
    finds that AI is mainly an amplifier of existing strengths and dysfunctions, and introduces the AI Capabilities Model.
  - [2025 DORA AI Capabilities Model](../../references/dora/publications.md#2025-dora-ai-capabilities-model) — gives implementation
    strategies, starter tactics, and ways to monitor progress for the capability.
  - [2016 State of DevOps Report](../../references/dora/publications.md#2016-state-of-devops-report) and
    [2017 State of DevOps Report](../../references/dora/publications.md#2017-state-of-devops-report) — listed on the capability page as
    further reading.
- **Predicts:** significantly amplifies AI adoption's positive effect on
  [organizational performance](../../references/dora/ai.md#organizational-performance) (see also the Core Model's
  [organizational performance](../../references/dora/core-model.md#organizational-performance) outcome); it is the only outcome the model
  diagram connects it to.
- **Related capabilities:**
  - [AI-accessible internal data](../../references/dora/capabilities.md#ai-accessible-internal-data) — the access layer this capability's
    data must be discoverable through.
  - [Clear and communicated AI stance](../../references/dora/capabilities.md#clear-and-communicated-ai-stance) — the policy context that
    governs how AI is allowed to use the data.
  - [Version control](../../references/dora/capabilities.md#version-control) — versions data definitions and schemas the same way it
    versions code.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
