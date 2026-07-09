# ADR: DORA — AI-accessible internal data

## Rules: ADR-DORA-AIDATA

### Rule ADR-DORA-AIDATA:1

AI-accessible internal data means securely connecting AI systems to an organization's own proprietary information — codebases, architectural
diagrams, wikis, documentation, style guides, operational metrics, and logs — so responses are context-aware rather than generic. Treat this
as context engineering, a discipline in its own right, not as a refinement of prompt wording.

- [Summary](#summary)

### Rule ADR-DORA-AIDATA:2

Internal-data access amplifies whatever AI adoption is already doing to individual effectiveness and code quality — for better when the
underlying data is good, for worse when it is not. The capability is a multiplier on the existing signal, not a source of new signal by
itself.

- [Why it matters](#why-it-matters)

### Rule ADR-DORA-AIDATA:3

Build the capability in phases: start with manual context engineering and a shared, version-controlled library of reusable context
templates; pilot automated retrieval (RAG or MCP) on a single high-impact use case before scaling; only then invest in secure internal APIs
that expose data systematically.

- [How to apply](#how-to-apply)

### Rule ADR-DORA-AIDATA:4

An AI connected to bad data produces bad answers — treat data quality, curation of gold-standard (not deprecated) examples, and deliberate
context retrieval as prerequisites, not cleanup work done after the fact.

- [Common pitfalls](#common-pitfalls)

### Rule ADR-DORA-AIDATA:5

Never grant an AI system blanket or shared-account access to internal data. Access travels through the same least-privilege, per-user
credentials a human would use, so an AI query can only ever reach what its requester could already see.

- [Common pitfalls](#common-pitfalls)

## Context

AI-accessible internal data sits downstream of the platform's other technical capabilities: it only pays off once the codebase, docs,
config, and operational data it draws on are themselves version-controlled, documented, and cleanly modeled. DORA frames it as the
discipline that turns a generic AI model into a specialized expert for a given organization by feeding it that organization's own
proprietary information instead of leaving it to answer from general training data alone.[^1]

DORA's research places this capability alongside AI adoption in the Core Model: adopting AI tools is necessary but not sufficient, and
giving those tools access to internal data is what converts adoption into measurable gains in individual effectiveness and code quality. The
same access, unmanaged, is also where AI-era risk concentrates — rapid generation without small batch sizes, silent replication of
deprecated patterns, and data exposure when access controls are not enforced.

## Summary

The capability is context engineering: securely connecting AI systems to an organization's codebases, documentation, wikis, style guides,
operational metrics, and logs so that responses are grounded in that organization's actual state rather than generic training data.

DORA's research finds that this access is a statistically significant multiplier — it amplifies the positive impact of AI adoption on
individual effectiveness and code quality. It converts tribal knowledge into instant, context-aware answers, enables automatic validation
against internal standards, and is what separates "using AI" from "getting value from AI".

## Why it matters

Access to internal data is what makes AI adoption pay off rather than merely occur. DORA's research shows the effect is a multiplier: teams
whose AI tools can reach internal data see materially better individual effectiveness and code quality than teams using the same AI tools
without that access. The same mechanism cuts both ways — because the AI answers from whatever it is given, the quality of the underlying
data determines the quality of the result, and ungoverned access is exactly where delivery instability, technical debt from copied
deprecated patterns, and data exposure originate.

## How to apply

Build the capability in three phases rather than attempting automated retrieval on day one.

In the foundational phase, engineers do context engineering manually — assembling the specific internal information (a relevant file, an
architecture doc, a style guide) an AI needs to answer a question accurately — and that assembled context is captured in a shared,
version-controlled library of reusable templates rather than re-created ad hoc each time. High-quality documentation is a primary driver of
successful AI adoption at this stage, which is also where it is cheapest to fix: `docs/references/` as the one authored source per folder,
linked out to `README.md` rather than duplicated ([ADR-REPO-README](../repository/generated-readmes.md)), keeps that documentation current
at no ongoing maintenance cost — an AI reading a generated README reads the same, never-stale content a person does.

In the pilot phase, automate retrieval for a single high-impact use case, choosing between a custom retrieval-augmented-generation (RAG)
pipeline for precise, up-to-date retrieval and a Model Context Protocol (MCP) integration that selects and feeds only relevant context
rather than raw documents. Either approach only has something worth retrieving because the codebase, configuration, pipelines, and governing
docs are comprehensively kept in version control in the first place ([ADR-PRIN-EAC](../principles/everything-as-code.md)) — an artifact that
exists only in a UI, a wiki, or someone's head is not retrievable by either pattern.

In the scale phase, secure leadership sponsorship, address foundational data-quality gaps, and build secure internal APIs that expose data
systematically rather than through one-off pipelines. A structured, non-secret-only address grammar over version-controlled config
([ADR-CONF-ADDRESSING](../configuration/config-value-addressing.md)) is the same shape this phase needs at the platform layer: a uniform,
fail-fast way to name and resolve exactly one piece of internal data, with secrets excluded by construction rather than filtered after the
fact.

## Common pitfalls

- **Poor-quality internal data.** An AI connected to bad data only produces bad answers; piloting against a single, well-understood data
  source and cleaning it (with AI assistance) before scaling avoids amplifying existing data problems.

- **Bad examples pollution.** Indexing deprecated projects or abandoned patterns teaches the AI to reproduce them; curate gold-standard
  repositories for indexing rather than the whole history.

- **Context rot and overloading.** Stuffing a large context window with loosely relevant material dilutes the signal and leads to
  hallucinations; retrieve specific relevant chunks (RAG or MCP-style context harvesting) instead of handing over raw documents wholesale.

- **Security shortcuts.** Running AI access through a "super user" or shared service account defeats access controls; resolve every query
  under the requesting user's own least-privilege credentials instead.

## References

[^1]:
    DORA, _AI-accessible internal data_ capability, <https://dora.dev/capabilities/ai-accessible-internal-data/>. Part of the DORA Core
    Model of capabilities that predict software delivery performance in the AI era.

## Dora explains

AI-accessible internal data is where DORA's AI-era findings meet its long-standing delivery metrics: an AI amplifies whatever data
discipline a team already has, so the capability's payoff rides entirely on capabilities DORA already measures — version control,
documentation quality, and access governance.

- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — bounds the delivery instability that rapid,
  context-fed AI generation can otherwise introduce.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — high-quality documentation is a primary driver of
  successful AI adoption and a direct source of the context this capability retrieves.
- [Version control](https://dora.dev/capabilities/version-control/) — an artifact is only retrievable by RAG or MCP if it is comprehensively
  kept in a version-controlled system in the first place.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
