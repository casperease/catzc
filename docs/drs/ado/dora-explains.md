# DORA explanations — ado

The `Dora explains` rationale for the records in the `ado/` domain, consolidated in one place. Each entry names its record and rule code,
then reproduces that record's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions
live in the records themselves; this file carries only their DORA rationale.

## Dual authentication

`Dual authentication — ado pipeline system token vs. local Az token`

[ADR-ADO-AUTH](dual-authentication.md)

> DORA's research links explicit security controls and clear error handling to both high delivery performance and low change failure rates.
> This record's discipline of deterministic credential selection with mandatory org/tenant proof prevents silent auth failures and audit
> gaps that compromise both security and deployment reliability.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — explicit org/tenant verification prevents credentials
  from targeting the wrong organization.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — deterministic auth without fallback enables reliable
  pipeline execution.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — clear error messages surface the
  specific missing credential.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline variables

`Pipeline variable interface — setting ADO output variables from PowerShell`

[ADR-ADO-VAR](pipeline-variables.md)

> DORA's research links explicit validation and observability to reduced defects and faster incident resolution. This record's discipline of
> centralizing pipeline variable manipulation in a validated function makes variable usage greppable and testable, prevents silent failures
> from name-character rewrites and missing output flags, and enables secret masking to protect sensitive data in logs.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — centralized function makes variable usage greppable
  and testable.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — validation and logging make variable
  behavior auditable.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — proper variable scoping enables reliable step/job
  communication.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline naming and placement

[ADR-ADO-NAME](pipeline-naming-and-placement.md)

> DORA's research links code organization and consistency to faster review cycles and lower defect introduction rates. This record's
> semantic layout convention — type-prefixed ado pipelines in one flat directory and per-kind template folders — eliminates guesswork about
> structure, enables tooling and audits to be predictable, and keeps the `.ado/pipelines/` directory self-indexing and greppable without
> opening files.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — conventional layout keeps ado pipelines organized and
  instantly classifiable by type.
- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — the directory structure documents what each file is
  without opening it.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — consistent placement enables automated validation
  and tooling built on known patterns.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Custom templates

`Custom template discipline — when and how to use ADO templates`

[ADR-ADO-TEMPLATE](custom-template-discipline.md)

> DORA's research links code clarity to delivery speed and quality. Excessive template abstraction and parameter forwarding slow reviews,
> introduce maintenance costs, and obscure pipeline behavior. This record's discipline of keeping templates focused on pipeline concerns
> keeps the critical path clear.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — flat, reviewable pipeline code reduces cycle time.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — direct step references and shallow nesting keep ado
  pipelines readable.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — simpler ado pipelines require less
  review friction.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline runner pattern

`Pipeline runner pattern — how ado pipelines invoke automation`

[ADR-ADO-RUNNER](pipeline-runner-pattern.md)

> DORA's research links local reproducibility and test automation to faster problem diagnosis and reduced mean time to recovery. This
> record's runner pattern keeps pipeline steps locally reproducible and testable, centralizes bootstrap logic in one place, and separates
> orchestration (YAML) from automation (PowerShell), enabling consistent debugging and modification across contexts without scatter.

- [Test automation](../../references/dora/capabilities.md#test-automation) — commands are locally reproducible and testable without running
  a pipeline.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — single bootstrap point reduces deployment friction and
  scatter.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — separation of concerns keeps YAML declarative and
  PowerShell testable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Environment approvals

`Environment approvals — the promotion ladder's gates and records in Azure DevOps`

[ADR-ADO-APPROVAL](environment-approvals.md)

> DORA's research finds that lightweight, peer-reviewed change approval outperforms heavyweight external boards, and that deployment
> automation lowers change failure rates. This record keeps every approval check a reviewable config applied by one command, and certifies a
> production deploy from the engine's own deployment history rather than a record a pipeline could forge.

- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — approvers and checks are config,
  reviewed like code.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — one idempotent apply replaces portal settings.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — production ships only the bytes that stood on pre-prod.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline triggers

`Pipeline triggers — the ado path filters, build validation, schedules and parameters`

[ADR-ADO-TRIGGER](pipeline-triggers.md)

> DORA links continuous integration and version-controlled configuration to faster, more reliable delivery. Generating every ado trigger and
> build-validation filter from the one committed globset, and checking it for drift, starts a pipeline exactly when its unit changes, and
> keeping runtime parameters to INPUT and DEPLOY selection keeps configuration in version control.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — the pre-commit build validation and the `main`
  trigger select the same files, so the CI engine runs on every change to the unit.
- [Version control](../../references/dora/capabilities.md#version-control) — triggers derive from the committed globset and configuration
  enters as a commit, never as a run parameter.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — an INPUT pipeline's parameters land
  as a reviewable commit.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
