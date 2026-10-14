# docs/adr/flow/dora-explains.md

`DORA explanations — flow`

The `Dora explains` rationale for the ADRs in the `flow/` domain, consolidated in one place. Each entry names its ADR and rule code, then
reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions live in
the ADRs themselves; this file carries only their DORA rationale.

## CI discipline and promotion

`The CI discipline and the promotion flow — pipeline kinds keyed by the tagged artifact`

[ADR-FLOW-CD](cd-discipline-and-promotion-flow.md)

> DORA's research links continuous integration, continuous delivery, and deployment automation to faster, safer releases. Separating CI, CD,
> and DEPLOY as distinct pipeline kinds keyed by immutable artifacts enables fast feedback loops, reliable promotion, and clear governance
> boundaries.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — the 5-10 minute integration budget keeps the
  team's mainline continuously integrable.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — automated non-prod certification enables confidence
  before production promotion.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — build-once/deploy-many via immutable, tagged
  artifacts ensures production safety.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — clear CD/DEPLOY boundary separates
  automated validation from human governance.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline runner pattern

`Pipeline runner pattern — how pipelines invoke automation`

[ADR-FLOW-CD-RUNNER](pipeline-runner-pattern.md)

> DORA's research links local reproducibility and test automation to faster problem diagnosis and reduced mean time to recovery. This ADR's
> runner pattern keeps pipeline steps locally reproducible and testable, centralizes bootstrap logic in one place, and separates
> orchestration (YAML) from automation (PowerShell), enabling consistent debugging and modification across contexts without scatter.

- [Test automation](../../references/dora/capabilities.md#test-automation) — commands are locally reproducible and testable without running
  a pipeline.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — single bootstrap point reduces deployment friction and
  scatter.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — separation of concerns keeps YAML declarative and
  PowerShell testable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline detection

`Pipeline detection — how functions adapt to their execution context`

[ADR-FLOW-CD-DETECT](pipeline-detection.md)

> DORA's research links code maintainability and comprehensive testing to reduced defects and faster deployment cycles. Centralizing
> platform detection in a single function keeps context-dependent logic greppable, testable, and consistent, preventing silent
> cross-platform mismatches that surface only as cryptic failures deep in deployments.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — centralized detection keeps logic consistent across
  functions.
- [Test automation](../../references/dora/capabilities.md#test-automation) — the detection function is trivially testable and mocks are
  straightforward.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — consistent detection across Azure DevOps and
  GitHub Actions prevents platform-specific failures.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline types

`Pipeline types — the six kinds of ADO artifact, named`

[ADR-FLOW-CD-TYPE](pipeline-types.md)

> DORA's research distinguishes Continuous Delivery (production changes behind a manual gate) from Continuous Deployment (automated prod
> roll), and links explicit deployment governance to faster cycle times and lower failure rates. This ADR's taxonomy makes these
> distinctions explicit and nameable, preventing anti-patterns from hiding behind overloaded terminology and enabling each pipeline type to
> carry its proper governance contract and trigger model.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — CD pattern with explicit build-once-deploy-many and a
  manual production gate.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — DEPLOY and CDe have named, first-class deployment
  constructs.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — CI/CD both run post-commit on master, the
  single source of truth.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — the pre-commit gate keeps its fast-feedback
  budget because slow system tests run post-commit in CD, not in the pre-commit slot.
- [Test automation](../../references/dora/capabilities.md#test-automation) — test feedback in under ten minutes is the pre-commit gate's
  working budget.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — INPUT lands user input as a reviewed
  pull request, the lightweight peer-review approval the research favours over external approval boards.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Globset triggers

`Globset triggers — areas-of-control projected to native filters and reflected from git`

[ADR-FLOW-CD-GLOBS](durable-sha-globs.md)

> DORA's research links version-controlled configuration and deterministic deployment triggering to faster, more reliable deployments.
> Keeping area-of-control boundaries as one declarative source of truth — projected into native trigger filters and reflected from git
> history rather than frozen into committed per-set hashes — reduces deployment drift, keeps the mainline continuously integrable (no
> false-red from a stale marker), and makes CI trigger points reviewable as a first-class concern.

- [Version control](../../references/dora/capabilities.md#version-control) — area-of-control boundaries as one committed source of truth,
  the single configuration point.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — squash-safe, rename-correct triggering that never
  false-reds the mainline.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — one unit change is one `globs.yml` edit, its
  area of control computed, not argued.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
