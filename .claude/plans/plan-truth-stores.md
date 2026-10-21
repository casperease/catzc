---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      docs/adr/thesis/truth-stores.md,
      docs/adr/thesis/one-source-of-truth.md,
      pwsh/Catzc.Base.Docs/configs/glossary.yml,
      pwsh/Catzc.Azure.DevOps,
      contracts,
      docs/explanation/thesis/product-thesis,
    ]
---

# Truth stores: repositories, fact sources and state machines, synchronised into actionable facts

ADR-THES-STORES names the three kinds of truth store (version-controlled repository, fact source, state machine), the responsibility domain
a repository holds, the junctions where catzc meets a state machine, and synchronising truth stores into actionable facts as the core of the
problem catzc solves. ADR-THES-ONETRUTH-ONESTOREDECIDES is scoped to the responsibility domain. The tooling does not yet follow the ADR.

## Why its value is high

The thesis states what catzc is for. Until the tooling classifies the stores it touches and emits facts with their origin, the ADR is prose
with no check behind it, and the ADO writers below contradict it.

## Decided (the user, 2026-10-21, decision round)

- **ADO is two roles.** Its configuration (approvals, build validations with their branch policies, pipeline definitions, variables) is an
  adjacent store driven one way from the trunk; its runtime state (runs, environment deployments, pull-request history) is a fact source
  catzc only reads. ADR-THES-STORES-FACTSOURCEREADONLY says "a fact source's state", the ADR's branch-policy example moves to the adjacent
  store, and `docs/adr/thesis/one-source-of-truth.md:105` ("Catzc has no adjacent store"; an adjacent store keeps its own history) is
  restated. The writers: `Sync-AdoEnvironmentApprovals`, `Sync-AdoBuildValidations`, `Register-AdoBuildValidation`, `Register-AdoPipeline`,
  `New-AdoPullRequest`; `Set-AdoPipelineVariable` only emits `##vso` logging and is no writer.
- **One config entry per truth store** (kind, URL, owning state machine), defaults declared once on the config type.
- **One truth-stores diagram, a sample first**: the responsibility domain as a box holding the repository; fact sources outside it, reached
  by read arrows; state machines beside them, reached by the inbound and outbound junction arrows; ADO drawn as two stores. On approval it
  is one slide in the product-thesis deck whose caption carries the rule codes (the deck's About rule), and the ADR's Context keeps its
  text.

## Open steps

8. [ ] The user approved the sample `out/diagrams/dark-sample/.assets/truth-stores/` (2026-10-21): a slide file under
       `docs/explanation/thesis/product-thesis/`, its caption carrying the rule codes, and its line in `deck.md`. Check: the rendered png
       read, then `Test-Links` on `deck.md`.
