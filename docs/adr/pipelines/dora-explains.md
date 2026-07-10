# DORA explanations — pipelines

The `Dora explains` rationale for the ADRs in the `pipelines/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Dual authentication — pipeline system token vs. local Az token (`ADR-PIPE-AUTH`)

DORA's research links explicit security controls and clear error handling to both high delivery performance and low change failure rates.
This ADR's discipline of deterministic credential selection with mandatory org/tenant proof prevents silent auth failures and audit gaps
that compromise both security and deployment reliability.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — explicit org/tenant verification prevents credentials from
  targeting the wrong organization.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — deterministic auth without fallback enables reliable pipeline
  execution.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — clear error messages surface the specific
  missing credential.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pipeline variable interface — setting ADO output variables from PowerShell (`ADR-PIPE-VAR`)

DORA's research links explicit validation and observability to reduced defects and faster incident resolution. This ADR's discipline of
centralizing pipeline variable manipulation in a validated function makes variable usage greppable and testable, prevents silent failures
from name-character rewrites and missing output flags, and enables secret masking to protect sensitive data in logs.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — centralized function makes variable usage greppable and
  testable.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — validation and logging make variable
  behavior auditable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — proper variable scoping enables reliable step/job
  communication.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pipeline naming and placement (`ADR-PIPE-NAME`)

DORA's research links code organization and consistency to faster review cycles and lower defect introduction rates. This ADR's semantic
layout convention — type-prefixed pipelines in one flat directory and per-kind template folders — eliminates guesswork about structure,
enables tooling and audits to be predictable, and keeps the `pipelines/` directory self-indexing and greppable without opening files.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — conventional layout keeps pipelines organized and instantly
  classifiable by type.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — the directory structure documents what each file is
  without opening it.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — consistent placement enables automated validation and
  tooling built on known patterns.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Custom template discipline — when and how to use ADO templates (`ADR-PIPE-TEMPLATE`)

DORA's research links code clarity to delivery speed and quality. Excessive template abstraction and parameter forwarding slow reviews,
introduce maintenance costs, and obscure pipeline behavior. This ADR's discipline of keeping templates focused on pipeline concerns keeps
the critical path clear.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — flat, reviewable pipeline code reduces cycle time.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — direct step references and shallow nesting keep pipelines
  readable.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — simpler pipelines require less review
  friction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
