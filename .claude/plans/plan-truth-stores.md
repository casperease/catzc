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

## Open questions

- Q1: ADO is both a fact source and a store catzc writes to (`Sync-AdoEnvironmentApprovals`, `Sync-AdoBuildValidations`,
  `Register-AdoBuildValidation`, `Register-AdoPipeline`, `New-AdoPullRequest`, `Set-AdoPipelineVariable`), which breaks
  ADR-THES-STORES-FACTSOURCEREADONLY as written. Recommendation: split one platform into two roles. Its configuration (approvals, build
  validations, pipeline definitions, variables) is an adjacent store driven one way from the trunk, and its runtime state (runs, environment
  deployments, pull-request history) is a fact source that catzc only reads. The rule then says "a fact source's state", and a read of the
  configured controls verifies the projection. Alternatives: an explicit exception list in the rule, or moving the writers behind a
  junction.
- Q2: Where the truth stores of a responsibility domain are declared. Recommendation: one config entry per store (kind, URL, owning state
  machine), with defaults declared once on the config type. Configure, don't program. Alternative: prose only, with no registry.
- Q3: A truth-stores diagram. Recommendation: one diagram, made after Q1 because its answer decides whether ADO is drawn as one store or
  two: the responsibility domain as a box holding the repository; fact sources outside it, reached by read arrows; state machines beside
  their fact sources, reached by the two junction arrows, inbound and outbound. It goes in the product-thesis deck as one symbol-only slide,
  its words in the ADR, and replaces most of the ADR's Context for a first reader. Alternative: no diagram.

## Open steps

1. [ ] After Q1: reword ADR-THES-STORES-FACTSOURCEREADONLY and its Fact sources section in `docs/adr/thesis/truth-stores.md`, and the
       `fact source` entry in `pwsh/Catzc.Base.Docs/configs/glossary.yml`. Check: `Test-Glossary`, then `Test-Links` on the ADR.
2. [ ] After Q1: name the ADR rule in the help of each ADO writer, one file at a time. Check: that file's test under `Invoke-TestFile`.
3. [ ] After Q2: the truth-store config and its type, with one `Get-*` reader that emits the stores as data
       (ADR-THES-ONETRUTH-TRUTHISQUERYABLE). Check: its L0 Pester file.
4. [ ] The actionable-fact shape as a contract under `contracts/` (origin: store, address, read time; calls for: a change or a report), then
       one junction contract per direction, inbound and outbound. Check: `Test-Contracts`.
5. [ ] After Q1 and Q3: the truth-stores diagram as one new diagram for the user to approve (`drawio-diagram-waves`, a wave of one), then a
       slide file under `docs/explanation/thesis/product-thesis/` and its line in `deck.md`. Check: the rendered png read, then `Test-Links`
       on `deck.md`.
