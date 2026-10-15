---
catzc:
  derived:
    path: docs/adr/automation/dora-explains.md
    kind: adr
    body_sha: "3627036d4752"
    defines: []
    adrs: []
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/automation/avoid-deep-nesting.md
      - docs/adr/automation/bash/bash-test-artifacts.md
      - docs/adr/automation/caching.md
      - docs/adr/automation/console-output-matters.md
      - docs/adr/automation/consumer-overlay.md
      - docs/adr/automation/controlling-module-dependencies.md
      - docs/adr/automation/controlling-systemwide-deps.md
      - docs/adr/automation/cross-platform.md
      - docs/adr/automation/devbox-pipeline-parity.md
      - docs/adr/automation/dry-run.md
      - docs/adr/automation/effective-in-enterprises.md
      - docs/adr/automation/environment-variables.md
      - docs/adr/automation/execution-engines.md
      - docs/adr/automation/fail-fast-with-asserts.md
      - docs/adr/automation/go/go-test-artifacts.md
      - docs/adr/automation/idempotent-state-functions.md
      - docs/adr/automation/internal-asset-dependencies.md
      - docs/adr/automation/log-before-invoke.md
      - docs/adr/automation/managed-guids.md
      - docs/adr/automation/never-depend-on-pwd.md
      - docs/adr/automation/open-closed-architecture.md
      - docs/adr/automation/path-representation.md
      - docs/adr/automation/platform-bundle.md
      - docs/adr/automation/python/python-test-artifacts.md
      - docs/adr/automation/retry-as-last-resort.md
      - docs/adr/automation/sensible-defaults.md
      - docs/adr/automation/single-responsibility-functions.md
      - docs/adr/automation/spell-out-names.md
      - docs/adr/automation/test-automation.md
      - docs/adr/automation/tool-removal-lifecycle.md
      - docs/adr/automation/tracked-files-from-the-index.md
      - docs/adr/automation/use-proper-package-managers.md
      - docs/adr/automation/uv-python-handler.md
      - docs/adr/automation/zero-ceremony-poka-yoke.md
      - docs/references/dora/capabilities.md#code-maintainability
      - docs/references/dora/capabilities.md#continuous-delivery
      - docs/references/dora/capabilities.md#continuous-integration
      - docs/references/dora/capabilities.md#deployment-automation
      - docs/references/dora/capabilities.md#documentation-quality
      - docs/references/dora/capabilities.md#flexible-infrastructure
      - docs/references/dora/capabilities.md#learning-culture
      - docs/references/dora/capabilities.md#loosely-coupled-teams
      - docs/references/dora/capabilities.md#monitoring-and-observability
      - docs/references/dora/capabilities.md#pervasive-security
      - docs/references/dora/capabilities.md#platform-engineering
      - docs/references/dora/capabilities.md#teams-empowered-to-choose-tools
      - docs/references/dora/capabilities.md#test-automation
      - docs/references/dora/capabilities.md#version-control
      - docs/references/dora/index.md
---

# DORA explanations — automation

The `Dora explains` rationale for the ADRs in the `automation/` domain, consolidated in one place. Each entry names its ADR and rule code,
then reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions
live in the ADRs themselves; this file carries only their DORA rationale.

## Devbox / pipeline parity

`Devbox / pipeline parity — the automation track is a CLI that runs everywhere`

[ADR-AUTO-PARITY](devbox-pipeline-parity.md)

> DORA's research links continuous integration to faster deployment frequency and lower change failure rate. Devbox/pipeline parity ensures
> the same code path runs locally and in CI, eliminating "works on my machine" failures and accelerating feedback loops.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — parity ensures CI gates run early and faithfully.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — identical commands in both environments enable
  reliable, fast promotion.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — the CLI runs unchanged across devbox and CI
  environments.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Python via uv, user-space tools

`uv is the standard Python handler; tools install user-space`

[ADR-AUTO-UVPY](uv-python-handler.md)

> User-space Python provisioning via uv removes admin barriers, isolates tool dependencies, and ensures deterministic, reproducible
> versions. This enables self-service infrastructure provisioning while maintaining strict version control for CI/CD.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — user-space uv-managed Python enables
  provisioning without elevation and scales to organizations with strict access policies.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — locked Python versions ensure identical toolchains
  across devbox and CI; `devbox_version` relaxation applies only locally, keeping promotion deterministic.
- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — isolated tool environments and self-healing PATH make
  Python-based CLIs self-service and maintainable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Log before invoke

`Log the exact command before every invocation`

[ADR-AUTO-PRELOG](log-before-invoke.md)

> DORA's research links comprehensive, automatic logging and rapid troubleshooting to deployment reliability and reduced incident response
> time. Logging the exact command before every invocation ensures the log contains the information needed to reproduce and diagnose failures
> without re-running.

- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — logging every command and its output
  provides the observability needed to diagnose failures in CI and production without re-running.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — exact command logs enable fast copy-paste reproduction
  and debugging, reducing time-to-diagnosis and pipeline iteration cycles.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — automatic logging through `Invoke-Executable` ensures
  consistency and prevents the "forgot to log" bugs in production.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Retry as a last resort

`Retry is a last resort — lowest level only, never in tests`

[ADR-AUTO-RETRY](retry-as-last-resort.md)

> Restricting retry to idempotent operations at the lowest level keeps test results trustworthy and failures visible. This discipline is
> essential for reliable CI and for surfacing degrading systems before they cascade.

- [Test automation](../../references/dora/capabilities.md#test-automation) — tests never retry, so flakiness surfaces immediately and must
  be fixed or moved behind an explicit tier.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — honest, fast failures prevent masking real
  defects and keep merge gates reliable.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — every retry is logged as a warning so
  degrading dependencies leave a visible breadcrumb.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Open/closed architecture

[ADR-AUTO-EXTEND](open-closed-architecture.md)

> Convention-driven discovery eliminates merge conflicts and hand-maintained registrations, letting teams extend the system without
> coordinating around shared infrastructure. This is foundational to scaling development velocity without bottlenecks.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — conventions make extension predictable and reduce
  special-case infrastructure.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — adding capability never requires touching shared
  bootstrap code.
- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — self-service extension through stable conventions.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Zero ceremony, hard to fail

[ADR-AUTO-ZERO](zero-ceremony-poka-yoke.md)

> Structural prevention of errors and zero-ceremony onboarding dramatically lower the barrier to contribution and enable faster iteration.
> This foundation — making the common path frictionless and the wrong path invisible — is what lets platforms scale.

- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — zero-ceremony platform design with structural error
  prevention enables self-service tooling and rapid adoption.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — auto-discovered conventions and mechanical
  enforcement keep code consistent as it grows, without relying on tribal knowledge or code review.
- [Learning culture](../../references/dora/capabilities.md#learning-culture) — low barrier to entry and immediate productive contribution
  encourage participation and faster skill development.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Never depend on `$PWD`

[ADR-AUTO-NOPWD](never-depend-on-pwd.md)

> Absolute path resolution is essential to making functions composable and reproducible across environments. This discipline enables
> consistent behavior in CI pipelines, scheduled tasks, and nested function calls—all prerequisites for reliable automation.

- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — scripts work in pipelines without
  working-directory preambles.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — functions behave identically in automated contexts
  regardless of caller location.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — predictable path resolution makes functions easier to
  reason about and compose.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Avoid deep nesting

`Avoid deep nesting in statements and expressions`

[ADR-AUTO-NONEST](avoid-deep-nesting.md)

> DORA's research links code clarity and structured logic to deployment frequency and reliability. Splitting nested expressions into named
> intermediate steps makes code more maintainable, easier to review, and simpler to diagnose when failures occur.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — splitting nested logic into named steps makes code
  easier to understand and review.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — clear, step-by-step code reduces the cognitive load
  for team members maintaining the codebase.
- [Test automation](../../references/dora/capabilities.md#test-automation) — splitting expressions enables assertions at each step,
  supporting fail-fast testing patterns.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Test automation

`Test automation — logic tests vs integrity tests, and how to isolate`

[ADR-AUTO-TEST](test-automation.md)

> Separating logic tests from integrity tests, isolating via seams and fixtures, and pushing rule-checks left into fast L0 tests keeps all
> tests hermetic and rapid. This layered approach to testing enables reliable, fast feedback without sacrificing coverage.

- [Test automation](../../references/dora/capabilities.md#test-automation) — logic tests isolated via seams run fast and deterministically;
  walking-skeleton integration tests prove distinct boundaries; integrity tests guard shipped assets.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — L0/L1 logic tests run on every change; L2 tool
  tests run in fast CI; L3 cloud tests are optional and self-skip when unavailable.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — single-responsibility test isolation and fast
  feedback make changes safe and error messages actionable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Cross-platform

`Must be cross-platform`

[ADR-AUTO-XPLAT](cross-platform.md)

> DORA's research links multi-platform software development to reliable deployment across diverse infrastructure. Writing platform-agnostic
> code and running the same code paths locally and in CI ensures bugs are caught early and deployments work uniformly across environments.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — platform-agnostic patterns and abstractions
  enable deployments across Windows, Linux, and macOS without rewriting.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — developers test CI code paths locally on any
  platform, catching platform-specific breakage before pipeline runs.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — platform concerns isolated to installers keep the
  rest of the codebase clear and prevent accidental platform-specific APIs.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Single-responsibility functions

[ADR-AUTO-ONEJOB](single-responsibility-functions.md)

> Single-responsibility functions are easier to test, reuse, and reason about. Clear separation of concerns makes error messages actionable,
> reduces testing complexity, and enables callers to compose steps toward their own goals.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — single-responsibility functions are easier to
  understand, test, and reuse; errors point directly at the actual problem.
- [Test automation](../../references/dora/capabilities.md#test-automation) — testability is simpler; test combinations grow linearly, not
  exponentially, and mocking external dependencies is straightforward.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — simple functions with no hidden side effects can be
  called in unexpected contexts without breaking assumptions.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Caching

`Caching — static reads and filesystem-derived information (the importer is the cache boundary)`

[ADR-AUTO-CACHE](caching.md)

> DORA's research links efficient, deterministic information retrieval to deployment frequency and reliability. Caching static reads and
> filesystem-derived information within session boundaries reduces waste and ensures every automation run sees a consistent, self-determined
> view of the repository.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — efficient caching of static config reads and filesystem
  scans enables fast, deterministic automation runs.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — consistent, cached repository views ensure
  deployment decisions are based on stable information within each session.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — clear cache boundaries and lazy-load patterns make it
  obvious when information is recomputed versus memoized.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Tracked files from the index

`Tracked files are read from the git index, in-process, through one seam`

[ADR-AUTO-TRACKED](tracked-files-from-the-index.md)

> DORA's research ties fast, reliable automated tests to delivery performance. Reading the tracked-file set from the git index in-process
> gives every gate one exact answer at the cost of a file read, so the gates that scope by tracked files run as fast, process-free tests
> instead of slow integration tests.

- [Test automation](../../references/dora/capabilities.md#test-automation) — tracked-file quality gates run without launching git, so they
  stay in the fast unit and integrity tiers.
- [Version control](../../references/dora/capabilities.md#version-control) — "tracked" means exactly what git's index holds, read the same
  way by every gate.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — one seam replaces per-caller git calls, each with its
  own parsing.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Sensible defaults

`Sensible defaults for all parameters`

[ADR-AUTO-DEFAULT](sensible-defaults.md)

> Smart defaults pulled from configuration enable self-service platform capabilities and reduce the friction of automation. Functions that
> work on zero arguments with sensible behavior lower adoption barriers and speed up iteration.

- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — sensible defaults make the platform self-discoverable
  and reduce the need for elaborate documentation.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — defaults pulled from config reduce call-site noise
  and eliminate scattered magic numbers.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — configuration-driven defaults ensure consistent
  behavior and make version/environment changes propagate uniformly.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Fail fast

`Fail fast with inline assertions`

[ADR-AUTO-FAILFAST](fail-fast-with-asserts.md)

> DORA's research links early failure detection and clear error messages to deployment reliability and reduced debugging time. Inline
> assertions at every assumption point catch problems before they propagate, enabling fast diagnosis and reducing the cost of failures
> caught in production.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — failing fast with inline assertions catches issues
  early, reducing the feedback loop and enabling faster, safer deployment decisions.
- [Test automation](../../references/dora/capabilities.md#test-automation) — assertions at every assumption replace mock-heavy tests,
  providing real validation in every execution including production edge cases.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — assertions serve as executable documentation, making
  preconditions explicit and preventing failures from propagating deep into code.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Idempotent state changes

`State-changing functions must be idempotent`

[ADR-AUTO-IDEM](idempotent-state-functions.md)

> DORA's research links idempotent state operations to reliable retry-safe automation and reduced operational risk. Functions that check
> before acting and produce identical results whether run once or multiple times enable safe re-execution and simplify error recovery in
> pipelines and manual operations.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — idempotent functions enable safe re-runs and pipeline
  retries without manual cleanup or state inspection before re-execution.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — check-before-act patterns prevent duplicates and
  corruption from partial failures, making deployments predictable and restart-safe.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — idempotent functions have clear, predictable
  behavior: same inputs always produce identical outcomes, reducing hidden state assumptions.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Proper package managers

`Use proper package managers`

[ADR-AUTO-PKGMGR](use-proper-package-managers.md)

> Using platform-native package managers with strong security models — hash verification, code review, no arbitrary script execution — is
> foundational to supply-chain security. Rejecting structurally weak alternatives keeps the toolchain's attack surface minimal.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — platform-native managers with hash verification prevent
  supply-chain attacks and arbitrary code execution during tool installation.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — platform-native managers (winget, brew,
  apt-get) provide consistent, trusted tool provisioning across operating systems.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — standard package managers reduce special-case
  installation logic and keep provisioning scripts clear and reviewable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Enterprise environments

`Effective in enterprise environments`

[ADR-AUTO-ENTERP](effective-in-enterprises.md)

> DORA's research links self-contained, network-independent automation to reliable deployments in diverse enterprise environments. Vendoring
> all dependencies and avoiding runtime access to external feeds ensures the system works behind firewalls and without privileged access.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — vendored dependencies and user-scope installers
  enable automation on machines without local admin or gallery access.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — vendoring dependencies and eliminating runtime
  network calls make the dependency set explicit and reproducible across all machines.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — eliminating external runtime dependencies enables
  reliable, self-provisioning automation in firewalled enterprise networks.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## System-wide dependencies

`Controlling system-wide dependencies`

[ADR-AUTO-DEPS](controlling-systemwide-deps.md)

> DORA's research links reliable, reproducible external tool provisioning to deployment frequency and platform independence. Locking tool
> versions in configuration and asserting them at runtime ensures consistent behavior across local and CI environments without requiring
> container runtimes.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — platform-aware installers support Windows,
  macOS, and Linux without Docker, driven by unified configuration.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — version-locked tools and predictable provisioning
  ensure CI pipelines can be self-provisioning and deterministic.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — configuration-driven tool versions and assertions
  make the toolchain's state clear and upgrades reviewable as config changes.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Tool lifecycle

`Install / Uninstall / Remove — the tool lifecycle and the destructive-eviction escalation`

[ADR-AUTO-REMOVE](tool-removal-lifecycle.md)

> Clean separation of managed removal from destructive eviction, with safe default behavior, makes provisioning reliable and auditable.
> Doubly guarded destructive operations prevent accidental data loss while enabling systematic cleanup when needed.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — uniform tool management across platforms, with
  clear remediation paths for off-config installs.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — idempotent, doubly guarded removal ensures machines
  converge predictably and safely to the configured state.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — clear verb contracts (Install/Uninstall/Remove) and
  safe-by-default guards make tool management auditable and reviewable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Module dependencies

`Controlling module dependencies`

[ADR-AUTO-DEPM](controlling-module-dependencies.md)

> DORA's research links clear dependency structures and acyclic, well-defined interfaces to team independence and deployment reliability.
> Declaring and enforcing the module dependency graph enables teams to work on isolated modules safely while preventing the layer inversions
> and cycles that slow systems.

- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — declared module dependencies enable teams to work
  independently on their modules without undeclared cross-layer calls.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — an acyclic dependency graph and explicit interface
  contracts make the system's structure clear and changes auditable.
- [Version control](../../references/dora/capabilities.md#version-control) — the entire dependency graph, internal and external, is
  versioned in config, making every build reproducible from the checkout.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Environment variables

`Environment variables are for external boundaries, not internal state`

[ADR-AUTO-ENVVAR](environment-variables.md)

> DORA's research links clear module boundaries and explicit state passing to maintainability and reduced coupling. Confining environment
> variables to external tool contracts prevents invisible coupling through global mutable state and keeps secrets out of process-wide
> pollution vectors.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — function parameters document inputs explicitly,
  eliminating hidden dependencies that make caller code unclear.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — environment variables are kept away from internal state
  and secrets, reducing process-wide visibility and leak risk.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — explicit function contracts through parameters
  replace invisible coupling via shared global mutable state.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Path representation

`Path representation — relative across boundaries, absolute only at the bind`

[ADR-AUTO-PATH](path-representation.md)

> Distinguishing communication form (relative, portable) from binding form (absolute, deterministic) eliminates a major class of path-based
> bugs and makes artifacts portable across machines and pipeline stages. This discipline is essential for reproducible, auditable
> deployments.

- [Version control](../../references/dora/capabilities.md#version-control) — relative paths in configs and artifacts are portable and
  committable.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — deterministic path resolution against known
  anchors, never $PWD, makes artifacts work identically across devbox and pipeline.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — centralized converters eliminate path-normalization
  bugs and hand-built Join-Path variants.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Managed GUIDs

`Managed GUIDs — every GUID literal is a registered, described identity`

[ADR-AUTO-GUIDS](managed-guids.md)

> DORA's research links explicit identity management and auditability to security, reliability, and compliance. Registering every GUID
> literal and describing its purpose makes identity boundaries explicit, prevents drift, and ensures external-facing and placeholder
> identities are visibly distinct.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — registering and categorizing every GUID literal prevents
  production identity leakage and makes unregistered identities detectable.
- [Version control](../../references/dora/capabilities.md#version-control) — the managed-GUID registry is version-controlled configuration,
  making every identity change a reviewed diff with full audit trail.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — named registry entries and self-describing minted
  GUIDs make code and fixtures legible, and dead entries are caught by liveness rules.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Platform bundle

`Platform bundle — the merged, versioned, installable Catzc build`

[ADR-AUTO-BUNDLE](platform-bundle.md)

> DORA's research links deployment automation, continuous delivery, and comprehensive version control to delivery performance. A
> relocatable, content-addressed platform bundle turns the toolset itself into a build-once, deploy-many artifact: reproducible from a
> commit, versioned by that commit, verifiable by hash and provenance, and installed by one command onto any root — so a consuming team runs
> exactly the platform a commit built, without a repository checkout.

- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — one command builds an immutable artifact and
  installs it onto any destination root.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the content-addressed, provenance-carrying bundle is
  reproducible from a commit and verifiable before use.
- [Version control](../../references/dora/capabilities.md#version-control) — the durable-SHA identity and `build.json` make the installed
  version an exact, traceable fact.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — the anchor split makes the platform
  relocatable, running the same from the repo or an install.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Consumer overlay

`Consumer overlay — a consumer changes a built bundle only through .catzc/`

[ADR-AUTO-OVERLAY](consumer-overlay.md)

> DORA's research links platform engineering and loosely coupled teams to delivery performance: a team does its own work on a shared
> platform without forking it or waiting on its owners. The overlay lets a consuming team change what a built bundle does from one committed
> folder in its own repository, checked as a whole before it applies, while the bundle itself stays the immutable artifact its commit built.

- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — a consumer adapts the platform through declared
  override points, never by editing or forking it.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — a consuming team changes configs, functions, and
  assets, and adds its own modules, without a change to the bundle.
- [Version control](../../references/dora/capabilities.md#version-control) — every change a consumer makes lives in its own repository as a
  reviewed diff.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the installed bundle is never edited, so a
  reinstall keeps its content hash and loses nothing.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Internal asset dependencies

`Internal asset dependencies — located through one helper, tested in both run modes`

[ADR-AUTO-ASSETDEP](internal-asset-dependencies.md)

> DORA links test automation and deployment automation to stable delivery. Locating every internal asset through one helper, and testing
> every such read against the real asset in both run modes, catches a lookup that only works in the source tree before it reaches an
> installed package.

- [Test automation](../../references/dora/capabilities.md#test-automation) — a real-asset test per dependency runs in both test runs.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the build's presence check guarantees every needed
  asset ships.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — the dependency inventory is derived from the code,
  never hand-kept.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Console output

`Console output matters`

[ADR-AUTO-CONSOLE](console-output-matters.md)

> DORA's research links monitoring and observability to deployment frequency and change failure rates—and console output is the automation's
> sole window into what is happening. Structured, meaningful logging that announces long operations, stays silent on success, and records
> every lasting change made to the session enables fast troubleshooting without re-running, reducing mean time to recovery.

- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — clear logging enables quick diagnosis
  of failures without re-running operations.
- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — output serves as the primary documentation of what
  happened and what failed.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — consistent output patterns make automation behavior
  easy to reason about and review.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Spell out names

`Spell out names — no invented abbreviations`

[ADR-AUTO-SPELL](spell-out-names.md)

> DORA research shows that consistent naming conventions improve code readability and enable reliable refactoring. Full, spelled-out
> identifiers are self-documenting, searchable by grep, and shared across the team, eliminating the translation cost of invented
> abbreviations.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — full names enable reliable search and refactoring.
- [Documentation quality](../../references/dora/capabilities.md#documentation-quality) — identifiers are self-documenting without
  translation.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Dry run

`An explicit dry-run parameter on every side-effecting function`

[ADR-AUTO-DRYRUN](dry-run.md)

> DORA research shows that explicit, observable return values improve test effectiveness and deployment safety. A dry run that returns the
> planned action lets tests verify plans without side effects, eliminating both hidden failures and test noise.

- [Test automation](../../references/dora/capabilities.md#test-automation) — capturable return values enable testable assertions without
  side effects.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — explicit dry-run prevents silent failures in
  automation.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — explicit parameters reduce hidden behavior and
  implicit magic.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Native C# types

`Native C# types — one combined assembly, namespace per module`

[ADR-AUTO-TYPES](BCL/native-csharp-types.md)

> DORA research links code maintainability and loosely coupled architecture to faster delivery and fewer defects. This ADR encodes the
> platform's models as native types with fixed shapes, versioned assemblies, and dependency-governed layering, reducing the cognitive load
> of loose dictionaries.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — fixed, discoverable type shapes and standardized
  namespace patterns.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — dependency graph governs cross-module type
  references and enforces layering.
- [Version control](../../references/dora/capabilities.md#version-control) — committed prebuilt assembly; everything-as-code principle
  enables reproducible builds.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Go test artifacts

`Go test artifacts — black-box tests of the engine, never shipped`

[ADR-AUTO-GO](go/go-test-artifacts.md)

> DORA research ties delivery performance to automated tests that run on every change and that developers trust. Black-box Go tests start
> the engine as a process, the way a user or a pipeline starts it, and run in the same test run as every other test, in both run modes, so
> the engine's behaviour as a whole is checked before a change merges.

- [Test automation](../../references/dora/capabilities.md#test-automation) — the engine is tested from outside, through the same harness,
  tiers, and report as its Pester tests.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the same tests run against the source and the build, so
  the artifact that ships is the one that was verified.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a generated workspace and one pinned Go version leave
  nothing Go-specific to keep in step by hand.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Python test artifacts

`Python test artifacts — black-box tests of the engine, never shipped`

[ADR-AUTO-PY](python/python-test-artifacts.md)

> DORA research ties delivery performance to automated tests that run on every change and that developers trust. Black-box Python tests
> start the engine as a process under the contract the Go tests follow, and run through the same bridge in the same test run, so a second
> language checks the engine's behaviour as a whole before a change merges, with nothing Python-specific to keep in step by hand.

- [Test automation](../../references/dora/capabilities.md#test-automation) — each Python test becomes one Pester test, under the same tiers,
  categories, and report as every other test.
- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — the same tests run against the repository and the
  build, so the artifact that ships is the one that was verified.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a generated uv workspace and one pinned Python
  version leave only the test files to commit.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Bash test artifacts

`Bash test artifacts — black-box tests of the engine through cats, run by a vendored bats`

[ADR-AUTO-BASH](bash/bash-test-artifacts.md)

> DORA research ties delivery performance to automated tests that developers trust and that run the software the way its users do. Bash
> tests load `importer.sh` and call catzc through the `cats` dispatcher, exactly as a Bash user does, under a pinned, vendored bats; every
> shell script the repository tracks takes the shell-script checks, so a Bash user's path into catzc is verified on every change.

- [Test automation](../../references/dora/capabilities.md#test-automation) — each `@test` becomes one Pester test in the same test run as
  the Go, Python, and Pester tests.
- [Continuous integration](../../references/dora/capabilities.md#continuous-integration) — a vendored, pinned runner means every run tests
  with the same bats and downloads nothing.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — ShellCheck, `zsh -n`, line endings, and the
  executable bit are checked on every tracked shell script.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Execution engines

`Execution engines — pwsh, bash and zsh, declared once`

[ADR-AUTO-ENGINE](execution-engines.md)

> DORA's research links flexible infrastructure and teams empowered to choose their tools to delivery performance. Declaring the three
> execution engines once, with everything that differs between them as properties of one model, lets a user work from pwsh, bash, or zsh
> while every black-box test runs once per engine, unchanged, so each shell's path into catzc is proven the same way.

- [Teams empowered to choose tools](../../references/dora/capabilities.md#teams-empowered-to-choose-tools) — a user reaches every catzc
  command from the shell they work in.
- [Test automation](../../references/dora/capabilities.md#test-automation) — one black-box test runs under all three engines, and a
  per-engine fixture table states each difference side by side.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — a flag, quote rule, or file name lives once in the
  engine model, never restated at a call site.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
