# DORA explanations — flow

The `Dora explains` rationale for the ADRs in the `flow/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## The CI discipline and the promotion flow — domains keyed by the tagged artifact (`ADR-FLOW-CD`)

DORA's research links continuous integration, continuous delivery, and deployment automation to faster, safer releases. Separating CI, CD,
and DEPLOY as distinct domains keyed by immutable artifacts enables fast feedback loops, reliable promotion, and clear governance
boundaries.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — the 5-10 minute integration budget keeps the team's
  mainline continuously integrable.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — automated non-prod certification enables confidence before
  production promotion.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — build-once/deploy-many via immutable, tagged artifacts
  ensures production safety.
- [Streamlining change approval](https://dora.dev/capabilities/streamlining-change-approval/) — clear CD/DEPLOY boundary separates automated
  validation from human governance.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pipeline runner pattern — how pipelines invoke automation (`ADR-FLOW-CD-RUNNER`)

DORA's research links local reproducibility and test automation to faster problem diagnosis and reduced mean time to recovery. This ADR's
runner pattern keeps pipeline steps locally reproducible and testable, centralizes bootstrap logic in one place, and separates orchestration
(YAML) from automation (PowerShell), enabling consistent debugging and modification across contexts without scatter.

- [Test automation](https://dora.dev/capabilities/test-automation/) — commands are locally reproducible and testable without running a
  pipeline.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — single bootstrap point reduces deployment friction and
  scatter.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — separation of concerns keeps YAML declarative and PowerShell
  testable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pipeline detection — how functions adapt to their execution context (`ADR-FLOW-CD-DETECT`)

DORA's research links code maintainability and comprehensive testing to reduced defects and faster deployment cycles. Centralizing platform
detection in a single function keeps context-dependent logic greppable, testable, and consistent, preventing silent cross-platform
mismatches that surface only as cryptic failures deep in deployments.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — centralized detection keeps logic consistent across
  functions.
- [Test automation](https://dora.dev/capabilities/test-automation/) — the detection function is trivially testable and mocks are
  straightforward.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — consistent detection across Azure DevOps and GitHub
  Actions prevents platform-specific failures.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pipeline types — the six kinds of ADO artifact, named (`ADR-FLOW-CD-TYPE`)

DORA's research distinguishes Continuous Delivery (human-gated production changes) from Continuous Deployment (automated prod roll), and
links explicit deployment governance to faster cycle times and lower failure rates. This ADR's taxonomy makes these distinctions explicit
and nameable, preventing anti-patterns from hiding behind overloaded terminology and enabling each pipeline type to carry its proper
governance contract and trigger model.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — CD pattern with explicit build-once-deploy-many and
  human-gated production.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — DEPLOY and CDe have named, first-class deployment
  constructs.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — CI/CD both run post-commit on master, the single
  source of truth.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Globset triggers — areas-of-control projected to native filters and reflected from git (`ADR-FLOW-CD-GLOBS`)

DORA's research links version-controlled configuration and deterministic deployment triggering to faster, more reliable deployments. Keeping
area-of-control boundaries as one declarative source of truth — projected into native trigger filters and reflected from git history rather
than frozen into committed per-set hashes — reduces deployment drift, keeps the mainline continuously integrable (no false-red from a stale
marker), and makes CI trigger points reviewable as a first-class concern.

- [Version control](https://dora.dev/capabilities/version-control/) — area-of-control boundaries as one committed source of truth, the
  single configuration point.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — squash-safe, rename-correct triggering that never
  false-reds the mainline.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — one unit change is one `globs.yml` edit, its area of
  control computed, not argued.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
