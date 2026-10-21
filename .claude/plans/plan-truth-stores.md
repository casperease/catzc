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

1. [ ] Reword ADR-THES-STORES-FACTSOURCEREADONLY and its Fact sources section in `docs/adr/thesis/truth-stores.md` as decided, and the
       `fact source` and `adjacent store` entries in `pwsh/Catzc.Base.Docs/configs/glossary.yml`. Check: `Test-Glossary`, then `Test-Links`
       on the ADR.
2. [ ] `docs/adr/thesis/one-source-of-truth.md`: restate line 105 so ADO configuration is an adjacent store whose history is the trunk that
       drives it. Check: `Test-AdrCodes`, `Test-Links` on the page.
3. [ ] Name the adjacent-store rule in the help of each of the five ADO writers, one file at a time. Check: that file's test under
       `Invoke-TestFile`.
4. [ ] The truth-store config and its type, with one `Get-*` reader that emits the stores as data (ADR-THES-ONETRUTH-TRUTHISQUERYABLE).
       Check: its L0 Pester file.
5. [ ] The actionable-fact shape as a contract under `contracts/` (origin: store, address, read time; calls for: a change or a report), then
       one junction contract per direction, inbound and outbound. Check: `Test-Contracts`.
6. [ ] After steps 1-2: the truth-stores diagram as one sample in `out/diagrams/dark-sample/` (`drawio-diagram-waves`, a wave of one).
       Check: the user approves the sample.
7. [ ] On approval: a slide file under `docs/explanation/thesis/product-thesis/`, its caption carrying the rule codes, and its line in
       `deck.md`. Check: the rendered png read, then `Test-Links` on `deck.md`.
