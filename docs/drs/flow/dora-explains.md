# DORA explanations — flow

The `Dora explains` rationale for the decision records in the `flow/` domain, consolidated in one place. Each entry names its decision
record and rule code, then reproduces that record's tie to [DORA](../../references/dora/index.md) research and the domain-relevant
capability links. The decisions live in the decision records themselves; this file carries only their DORA rationale.

## CI discipline and promotion

`The CI discipline and the promotion flow — pipeline kinds keyed by the tagged artifact`

[FDR-CD](cd-discipline-and-promotion-flow.md)

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

[FDR-CD-RUNNER](pipeline-runner-pattern.md)

> DORA's research links local reproducibility and test automation to faster problem diagnosis and reduced mean time to recovery. This FDR's
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

[FDR-CD-DETECT](pipeline-detection.md)

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

[FDR-CD-TYPE](pipeline-types.md)

> DORA's research distinguishes Continuous Delivery (production changes behind a manual gate) from Continuous Deployment (automated prod
> roll), and links explicit deployment governance to faster cycle times and lower failure rates. This FDR's taxonomy makes these
> distinctions explicit and nameable, preventing anti-patterns from hiding behind overloaded terminology and enabling each pipeline type to
> carry its proper governance contract and trigger model.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — CD pattern with explicit build-once-deploy-many and a
  manual production gate.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — DEPLOY and CDe have named, first-class deployment
  constructs.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — CI/CD both run post-commit on master, the
  single source of truth.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — the pre-commit gate keeps its fast-feedback
  budget because slow system tests run post-commit in CD, not in the pre-commit stage.
- [Test automation](../../references/dora/capabilities.md#test-automation) — test feedback in under ten minutes is the pre-commit gate's
  working budget.
- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — INPUT lands user input as a reviewed
  pull request, the lightweight peer-review approval the research favours over external approval boards.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Globset triggers

`Globset triggers — areas-of-control projected to native filters and reflected from git`

[FDR-CD-GLOBS](durable-sha-globs.md)

> DORA's research links version-controlled configuration and deterministic deployment triggering to faster, more reliable deployments.
> Keeping area-of-control boundaries as one source of truth, declarative — projected into native trigger filters and reflected from git
> history rather than frozen into committed per-set hashes — reduces deployment drift, keeps the mainline continuously integrable (no
> false-red from a stale marker), and makes CI trigger points reviewable as a first-class concern.

- [Version control](../../references/dora/capabilities.md#version-control) — area-of-control boundaries as one committed source of truth,
  the single configuration point.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — squash-safe, rename-correct triggering that never
  false-reds the mainline.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — one unit change is one `globs.yml` edit, its
  area of control computed, not argued.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Pipeline concept

`Pipelines — the vendor-neutral CI/CD pipeline concept`

[FDR-CD-PIPELINE](pipeline-concept.md)

> DORA's research links deployment automation and code maintainability to faster, safer delivery. One vendor-neutral rule set for naming,
> typing and reading a pipeline keeps every delivery platform's pipelines reviewable from the file alone, and a token that lives for one
> request keeps the pipeline's credentials out of logs and later steps.

- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — a pipeline whose type and role read from its name
  and its flat YAML is automation a reviewer can trust.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one naming and extension convention across vendors
  keeps the pipeline files classifiable without opening them.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — a credential that never outlives its request cannot leak
  into a log or a later step.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Commit lifecycle

`The commit lifecycle — states, environment occupancy, and the stable sync point`

[FDR-CD-LIFE](commit-lifecycle.md)

> This model is a statement about how change flows into, through, and out of the mainline, which is the core of what DORA measures. A clear
> lifecycle — one direction, named rejection points, a distinction between rejected/retired/superseded, a single stable integration point
> that is not HEAD — is what lets a team keep the mainline continuously integrable and lets its consumers depend on it without inheriting
> its churn.

- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — the HEAD-vs-stable-sync-point rule and the
  one-directional ladder are how a trunk stays continuously integrable.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the promotion ladder and single-occupant environments
  are the delivery pipeline this capability governs.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — automatic discard at BVT/L3 and the out-of-band
  topic deploy are automated-deployment behaviours.
- [Version control](../../references/dora/capabilities.md#version-control) — "history is never rewritten; a discarded commit stays on the
  record" is a version-control discipline.
- [DORA research reference](../../references/dora/index.md).

## Manual queues

`The manual queues of the promotion ladder — authoring, two signatures, and an automated slot switch`

[FDR-CD-QUEUE](manual-queues.md)

> Lead time is dominated by waiting, and the waiting that hides best is a person who has not acted yet. Naming the three places a commit
> waits for a human, giving each a server and a store so its wait can be read, and keeping the production switch out of human hands turn the
> ladder's delay into a measured, improvable quantity instead of a feeling.

- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — two signatures in one registry,
  entered by a peer with access after an automated test, are the lightweight approval this capability describes.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the slot switch is automated and monitored, so the
  last climb adds no queue.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — the switch is watched while it runs,
  and the queues' waits are read from their stores.
- [DORA research reference](../../references/dora/index.md).

## Git topic flow

`The git topic flow — the sync point, one squashed commit, and the user at the keyboard`

[FDR-GIT](git-topic-flow.md)

> Trunk-based development lives or dies on how a short-lived branch meets the trunk. Syncing a topic from one named commit, landing it as a
> single squashed commit rebased onto the tip, and leaving every repository-changing act with its author keep the trunk a readable list of
> small changes that integrate cleanly and revert as units.

- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — a topic that syncs by rebase and lands as one
  commit is the short-lived branch this capability describes.
- [Working in small batches](../../references/dora/capabilities.md#working-in-small-batches) — one change, one commit makes the batch the
  unit the mainline records, judges and reverts.
- [Version control](../../references/dora/capabilities.md#version-control) — the topic is rewritten freely and the mainline never, so the
  shared record only grows.
- [DORA research reference](../../references/dora/index.md).
