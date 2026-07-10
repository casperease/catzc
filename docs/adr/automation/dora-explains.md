# DORA explanations — automation

The `Dora explains` rationale for the ADRs in the `automation/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Devbox / pipeline parity — the automation track is a CLI that runs everywhere (`ADR-AUTO-PARITY`)

DORA's research links continuous integration to faster deployment frequency and lower change failure rate. Devbox/pipeline parity ensures
the same code path runs locally and in CI, eliminating "works on my machine" failures and accelerating feedback loops.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — parity ensures CI gates run early and faithfully.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — identical commands in both environments enable reliable,
  fast promotion.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — the CLI runs unchanged across devbox and CI
  environments.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## uv is the standard Python handler; tools install user-space (`ADR-AUTO-UVPY`)

User-space Python provisioning via uv removes admin barriers, isolates tool dependencies, and ensures deterministic, reproducible versions.
This enables self-service infrastructure provisioning while maintaining strict version control for CI/CD.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — user-space uv-managed Python enables provisioning
  without elevation and scales to organizations with strict access policies.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — locked Python versions ensure identical toolchains across
  devbox and CI; `devbox_version` relaxation applies only locally, keeping promotion deterministic.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — isolated tool environments and self-healing PATH make
  Python-based CLIs self-service and maintainable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Log the exact command before every invocation (`ADR-AUTO-PRELOG`)

DORA's research links comprehensive, automatic logging and rapid troubleshooting to deployment reliability and reduced incident response
time. Logging the exact command before every invocation ensures the log contains the information needed to reproduce and diagnose failures
without re-running.

- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — logging every command and its output
  provides the observability needed to diagnose failures in CI and production without re-running.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — exact command logs enable fast copy-paste reproduction and
  debugging, reducing time-to-diagnosis and pipeline iteration cycles.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — automatic logging through `Invoke-Executable` ensures
  consistency and prevents the "forgot to log" bugs in production.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Retry is a last resort — lowest level only, never in tests (`ADR-AUTO-RETRY`)

Restricting retry to idempotent operations at the lowest level keeps test results trustworthy and failures visible. This discipline is
essential for reliable CI and for surfacing degrading systems before they cascade.

- [Test automation](https://dora.dev/capabilities/test-automation/) — tests never retry, so flakiness surfaces immediately and must be fixed
  or gated behind an explicit tier.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — honest, fast failures prevent masking real defects and
  keep merge gates reliable.
- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — every retry is logged as a warning so
  degrading dependencies leave a visible breadcrumb.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Open/closed architecture (`ADR-AUTO-EXTEND`)

Convention-driven discovery eliminates merge conflicts and hand-maintained registrations, letting teams extend the system without
coordinating around shared infrastructure. This is foundational to scaling development velocity without bottlenecks.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — conventions make extension predictable and reduce
  special-case infrastructure.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — adding capability never requires touching shared bootstrap
  code.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — self-service extension through stable conventions.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Zero ceremony, hard to fail (`ADR-AUTO-ZERO`)

Structural prevention of errors and zero-ceremony onboarding dramatically lower the barrier to contribution and enable faster iteration.
This foundation — making the common path frictionless and the wrong path invisible — is what lets platforms scale.

- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — zero-ceremony platform design with structural error
  prevention enables self-service tooling and rapid adoption.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — auto-discovered conventions and mechanical enforcement keep
  code consistent as it grows, without relying on tribal knowledge or code review.
- [Learning culture](https://dora.dev/capabilities/learning-culture/) — low barrier to entry and immediate productive contribution encourage
  participation and faster skill development.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Never depend on `$PWD` (`ADR-AUTO-NOPWD`)

Absolute path resolution is essential to making functions composable and reproducible across environments. This discipline enables
consistent behavior in CI pipelines, scheduled tasks, and nested function calls—all prerequisites for reliable automation.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — scripts work in pipelines without working-directory
  preambles.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — functions behave identically in automated contexts
  regardless of caller location.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — predictable path resolution makes functions easier to reason
  about and compose.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Avoid deep nesting in statements and expressions (`ADR-AUTO-NONEST`)

DORA's research links code clarity and structured logic to deployment frequency and reliability. Splitting nested expressions into named
intermediate steps makes code more maintainable, easier to review, and simpler to diagnose when failures occur.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — splitting nested logic into named steps makes code easier to
  understand and review.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — clear, step-by-step code reduces the cognitive load for
  team members maintaining the codebase.
- [Test automation](https://dora.dev/capabilities/test-automation/) — splitting expressions enables assertions at each step, supporting
  fail-fast testing patterns.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Test automation — logic tests vs integrity tests, and how to isolate (`ADR-AUTO-TEST`)

Separating logic tests from integrity tests, isolating via seams and fixtures, and pushing rule-checks left into fast L0 gates keeps the
test suite hermetic and rapid. This layered approach to testing enables reliable, fast feedback without sacrificing coverage.

- [Test automation](https://dora.dev/capabilities/test-automation/) — logic tests isolated via seams run fast and deterministically;
  walking-skeleton integration tests prove distinct boundaries; integrity tests guard shipped assets.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — L0/L1 logic tests run on every change; L2 tool tests run
  in fast CI; L3 cloud tests are optional and self-skip when unavailable.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — single-responsibility test isolation and fast feedback make
  changes safe and error messages actionable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Must be cross-platform (`ADR-AUTO-XPLAT`)

DORA's research links multi-platform software development to reliable deployment across diverse infrastructure. Writing platform-agnostic
code and running the same code paths locally and in CI ensures bugs are caught early and deployments work uniformly across environments.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — platform-agnostic patterns and abstractions enable
  deployments across Windows, Linux, and macOS without rewriting.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — developers test CI code paths locally on any platform,
  catching platform-specific breakage before pipeline runs.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — platform concerns isolated to installers keep the rest of
  the codebase clear and prevent accidental platform-specific APIs.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Single-responsibility functions (`ADR-AUTO-ONEJOB`)

Single-responsibility functions are easier to test, reuse, and reason about. Clear separation of concerns makes error messages actionable,
reduces testing complexity, and enables callers to compose steps toward their own goals.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — single-responsibility functions are easier to understand,
  test, and reuse; errors point directly at the actual problem.
- [Test automation](https://dora.dev/capabilities/test-automation/) — testability is simpler; test combinations grow linearly, not
  exponentially, and mocking external dependencies is straightforward.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — simple functions with no hidden side effects can be called
  in unexpected contexts without breaking assumptions.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Caching — static reads and filesystem-derived information (the importer is the cache boundary) (`ADR-AUTO-CACHE`)

DORA's research links efficient, deterministic information retrieval to deployment frequency and reliability. Caching static reads and
filesystem-derived information within session boundaries reduces waste and ensures every automation run sees a consistent, self-determined
view of the repository.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — efficient caching of static config reads and filesystem scans
  enables fast, deterministic automation runs.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — consistent, cached repository views ensure deployment
  decisions are based on stable information within each session.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — clear cache boundaries and lazy-load patterns make it
  obvious when information is recomputed versus memoized.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Sensible defaults for all parameters (`ADR-AUTO-DEFAULT`)

Smart defaults pulled from configuration enable self-service platform capabilities and reduce the friction of automation. Functions that
work on zero arguments with sensible behavior lower adoption barriers and speed up iteration.

- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — sensible defaults make the platform self-discoverable and
  reduce the need for elaborate documentation.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — defaults pulled from config reduce call-site noise and
  eliminate scattered magic numbers.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — configuration-driven defaults ensure consistent behavior
  and make version/environment changes propagate uniformly.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Fail fast with inline assertions (`ADR-AUTO-FAILFAST`)

DORA's research links early failure detection and clear error messages to deployment reliability and reduced debugging time. Inline
assertions at every assumption point catch problems before they propagate, enabling fast diagnosis and reducing the cost of failures caught
in production.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — failing fast with inline assertions catches issues early,
  reducing the feedback loop and enabling faster, safer deployment decisions.
- [Test automation](https://dora.dev/capabilities/test-automation/) — assertions at every assumption replace mock-heavy tests, providing
  real validation in every execution including production edge cases.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — assertions serve as executable documentation, making
  preconditions explicit and preventing failures from propagating deep into code.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## State-changing functions must be idempotent (`ADR-AUTO-IDEM`)

DORA's research links idempotent state operations to reliable retry-safe automation and reduced operational risk. Functions that check
before acting and produce identical results whether run once or multiple times enable safe re-execution and simplify error recovery in
pipelines and manual operations.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — idempotent functions enable safe re-runs and pipeline retries
  without manual cleanup or state inspection before re-execution.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — check-before-act patterns prevent duplicates and
  corruption from partial failures, making deployments predictable and restart-safe.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — idempotent functions have clear, predictable behavior: same
  inputs always produce identical outcomes, reducing hidden state assumptions.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Use proper package managers (`ADR-AUTO-PKGMGR`)

Using platform-native package managers with strong security models — hash verification, code review, no arbitrary script execution — is
foundational to supply-chain security. Rejecting structurally weak alternatives keeps the toolchain's attack surface minimal.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — platform-native managers with hash verification prevent
  supply-chain attacks and arbitrary code execution during tool installation.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — platform-native managers (winget, brew, apt-get)
  provide consistent, trusted tool provisioning across operating systems.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — standard package managers reduce special-case installation
  logic and keep provisioning scripts clear and reviewable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Effective in enterprise environments (`ADR-AUTO-ENTERP`)

DORA's research links self-contained, network-independent automation to reliable deployments in diverse enterprise environments. Vendoring
all dependencies and avoiding runtime access to external feeds ensures the system works behind firewalls and without privileged access.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — vendored dependencies and user-scope installers enable
  automation on machines without local admin or gallery access.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — vendoring dependencies and eliminating runtime network calls
  make the dependency set explicit and reproducible across all machines.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — eliminating external runtime dependencies enables
  reliable, self-provisioning automation in firewalled enterprise networks.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Controlling system-wide dependencies (`ADR-AUTO-DEPS`)

DORA's research links reliable, reproducible external tool provisioning to deployment frequency and platform independence. Locking tool
versions in configuration and asserting them at runtime ensures consistent behavior across local and CI environments without requiring
container runtimes.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — platform-aware installers support Windows, macOS, and
  Linux without Docker, driven by unified configuration.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — version-locked tools and predictable provisioning ensure
  CI pipelines can be self-provisioning and deterministic.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — configuration-driven tool versions and assertions make the
  toolchain's state clear and upgrades reviewable as config changes.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Install / Uninstall / Remove — the tool lifecycle and the destructive-eviction escalation (`ADR-AUTO-REMOVE`)

Clean separation of managed removal from destructive eviction, with safe default behavior, makes provisioning reliable and auditable.
Double-gated destructive operations prevent accidental data loss while enabling systematic cleanup when needed.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — uniform tool management across platforms, with clear
  remediation paths for off-config installs.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — idempotent, double-gated removal ensures machines converge
  predictably and safely to the configured state.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — clear verb contracts (Install/Uninstall/Remove) and
  safe-by-default gates make tool management auditable and reviewable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Controlling module dependencies (`ADR-AUTO-DEPM`)

DORA's research links clear dependency structures and acyclic, well-defined interfaces to team independence and deployment reliability.
Declaring and enforcing the module dependency graph enables teams to work on isolated modules safely while preventing the layer inversions
and cycles that slow systems.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — declared module dependencies enable teams to work
  independently on their modules without undeclared cross-layer calls.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — an acyclic dependency graph and explicit interface contracts
  make the system's structure clear and changes auditable.
- [Version control](https://dora.dev/capabilities/version-control/) — the entire dependency graph, internal and external, is versioned in
  config, making every build reproducible from the checkout.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Environment variables are for external boundaries, not internal state (`ADR-AUTO-ENVVAR`)

DORA's research links clear module boundaries and explicit state passing to maintainability and reduced coupling. Confining environment
variables to external tool contracts prevents invisible coupling through global mutable state and keeps secrets out of process-wide
pollution vectors.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — function parameters document inputs explicitly, eliminating
  hidden dependencies that make caller code unclear.
- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — environment variables are kept away from internal state and
  secrets, reducing process-wide visibility and leak risk.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — explicit function contracts through parameters replace
  invisible coupling via shared global mutable state.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Az CLI session verification — three layers, and verify is not connect (`ADR-AZ-SESSION`)

DORA's research links robust authentication and authorization practices to reliable, secure deployments. Layering session verification and
keeping concerns separate enables safe, auditable automation while maintaining module independence.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — layered verification ensures sessions are authenticated to the
  correct subscription before any deployment automation proceeds.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — separating by-args and config-aware verification allows
  modules to verify session state without depending on templating configuration.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — clean session verification functions enable safe,
  automated deployments with proper auth checks at each layer.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Path representation — relative across boundaries, absolute only at the bind (`ADR-AUTO-PATH`)

Distinguishing communication form (relative, portable) from binding form (absolute, deterministic) eliminates a major class of path-based
bugs and makes artifacts portable across machines and pipeline stages. This discipline is essential for reproducible, auditable deployments.

- [Version control](https://dora.dev/capabilities/version-control/) — relative paths in configs and artifacts are portable and committable.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — deterministic path resolution against known anchors, never
  $PWD, makes artifacts work identically across devbox and pipeline.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — centralized converters eliminate path-normalization bugs and
  hand-built Join-Path variants.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Protected globs — session-memory skip of repeated scans over an unchanged globset (`ADR-REPO-PROTGLOB`)

Session-memory gating of repeated scans over unchanged inputs cuts inner-loop feedback time without compromising CI proof. Fail-open
architecture ensures every pipeline run proves the full set, maintaining fast-feedback and reliability together.

- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — CI never gates, always scans full, so protection never
  hides a violation from the merge gate.
- [Test automation](https://dora.dev/capabilities/test-automation/) — heavy read-only scans are gated by globset identity, providing rapid
  feedback on unchanged inputs.
- [Working in small batches](https://dora.dev/capabilities/working-in-small-batches/) — skipped scans cut iteration time in local inner
  loop.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Managed GUIDs — every GUID literal is a registered, described identity (`ADR-AUTO-GUIDS`)

DORA's research links explicit identity management and auditability to security, reliability, and compliance. Registering every GUID literal
and describing its purpose makes identity boundaries explicit, prevents drift, and ensures external-facing and placeholder identities are
visibly distinct.

- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — registering and categorizing every GUID literal prevents
  production identity leakage and makes unregistered identities detectable.
- [Version control](https://dora.dev/capabilities/version-control/) — the managed-GUID registry is version-controlled configuration, making
  every identity change a reviewed diff with full audit trail.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — named registry entries and self-describing minted GUIDs make
  code and fixtures legible, and dead entries are caught by liveness rules.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Platform bundle — an installable, relocatable copy of catzc (`ADR-AUTO-BUNDLE`)

DORA's research links deployment automation, continuous delivery, and comprehensive version control to delivery performance. A relocatable,
content-addressed platform bundle turns the toolset itself into a build-once, deploy-many artifact: reproducible from a commit, verifiable
by hash and provenance, and installed by one command onto any root — so a consuming team runs exactly the platform a commit built, without a
repository checkout.

- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — one command builds an immutable artifact and installs it
  onto any destination root.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — the content-addressed, provenance-carrying bundle is
  reproducible from a commit and verifiable before use.
- [Version control](https://dora.dev/capabilities/version-control/) — the durable-SHA identity and `build.json` make the installed version
  an exact, traceable fact.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — the anchor split makes the platform relocatable,
  running the same from the repo or an install.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Vendor toolset dependencies (`ADR-AUTO-VENDOR`)

DORA research shows that vendored dependencies and version pinning reduce deployment variability and enable reproducible builds. Checking
modules into git guarantees every developer and CI run uses identical code, eliminating version-skew bugs and network brittleness.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — eliminates network dependency, enables offline work.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — version pinning and explicit diffs prevent version-skew
  surprises.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — fast disk loading and no version skew accelerate cycles.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Prefer Az CLI over Az PowerShell modules (`ADR-AUTO-AZCLI`)

DORA research links tool standardization and process isolation to faster deployments and fewer failures. Using a single executable tool
across all environments removes version skew and assembly conflicts.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — single tool, process isolation, no hidden
  dependencies.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — single tool eliminates environment-specific failures.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — explicit dependencies and simple return types reduce risk.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## One function per file (`ADR-AUTO-ONEFUNC`)

DORA's research on code maintainability emphasizes modularity and navigability—and one-function-per-file encoding that into file structure.
Matching file name to function name eliminates both AST parsing and merge conflicts, makes the module's surface area visible at a glance,
and creates natural test-file pairing.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — file name equals function name eliminates search friction
  and serves as self-documenting structure.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — one-function-per-file prevents merge conflicts when
  developers add functions in parallel.
- [Test automation](https://dora.dev/capabilities/test-automation/) — test files pair naturally with function files, improving test coverage
  and organization.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## PrePost extension modules (`ADR-AUTO-PREPOST`)

DORA's research connects loosely coupled architectures to faster delivery and better team autonomy. A single, clearly-defined extension
point for per-template hooks allows teams to customize deployments without scattered code or central orchestration.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — clear extension points enable independent template
  customization.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — grouped hooks in one .psm1 avoid scattered, duplicated code.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Error handling — fail immediately, no warnings (`ADR-AUTO-ERROR`)

DORA's research links fail-fast patterns to deployment reliability—and PowerShell's complex error model tempts silent failures. Using
terminating errors with `throw` and self-contained assertions eliminates the "maybe wrong" middle ground, surfaces problems immediately, and
enables CI to fail clearly instead of succeeding with warnings.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — fail-fast patterns prevent silent failures and corrupted
  state.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — two-state error handling (success or throw) is simpler than
  distinguishing warnings from errors.
- [Test automation](https://dora.dev/capabilities/test-automation/) — deterministic error behavior makes test assertions reliable and
  failures easy to diagnose.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Avoid using semicolons (`ADR-AUTO-NOSEMI`)

DORA's research on code maintainability shows that reducing syntactic noise and following language idioms correlates with faster code review
cycles and fewer defects. Semicolon-free PowerShell code reads as idiomatic, lowers cognitive load, and improves team velocity.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — idiomatic syntax reduces cognitive load and review friction.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — clear, consistent code patterns serve as
  self-documentation.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Console output matters (`ADR-AUTO-CONSOLE`)

DORA's research links monitoring and observability to deployment frequency and change failure rates—and console output is the automation's
sole window into what is happening. Structured, meaningful logging that announces long operations and stays silent on success enables fast
troubleshooting without re-running, reducing mean time to recovery.

- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — clear logging enables quick diagnosis of
  failures without re-running operations.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — output serves as the primary documentation of what
  happened and what failed.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — consistent output patterns make automation behavior easy to
  reason about and review.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Prefer foreach over ForEach-Object (`ADR-AUTO-FOREACH`)

DORA research shows that correct language semantics and predictable control flow reduce debugging time and test failures. Using foreach for
iteration eliminates entire classes of bugs where control flow keywords behave unexpectedly in scriptblock contexts.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — correct control flow semantics reduce cognitive load and
  bugs.
- [Test automation](https://dora.dev/capabilities/test-automation/) — predictable iteration behavior enables reliable, non-flaky tests.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Respect PowerShell approved verbs (`ADR-AUTO-VERBS`)

DORA research shows that consistent naming conventions improve code maintainability and enable teams to understand unfamiliar code by name
alone. Using PowerShell's approved verbs as the shared vocabulary transforms function names into behavioral contracts every team member
recognizes.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — consistent verbs reduce cognitive load, enable behavior
  prediction.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — verbs encode contracts that document behavior in names.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — shared verbs enable independent navigation of unfamiliar
  code.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Spell out names — no invented abbreviations (`ADR-AUTO-SPELL`)

DORA research shows that consistent naming conventions improve code readability and enable reliable refactoring. Full, spelled-out
identifiers are self-documenting, searchable by grep, and shared across the team, eliminating the translation cost of invented
abbreviations.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — full names enable reliable search and refactoring.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — identifiers are self-documenting without translation.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Use `.ps1` for function files, not `.psm1` (`ADR-AUTO-USEPS`)

DORA research shows that aligning code structure with established community patterns improves maintainability and reduces onboarding
friction. Using .ps1 files for module functions eliminates scope isolation and boilerplate, letting developers focus on logic rather than
module plumbing.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — shared scope eliminates boilerplate and scope isolation
  overhead.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — established patterns reduce onboarding friction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
- `.psm1` remains in use only for genuine module/standalone files, never for a module's function files: the `automation/.internal/*.psm1`
  shared modules (loader, bootstrap, TestKit, types), the `automation/.scriptanalyzer/*.psm1` custom analyzer rule modules, and per-template
  `PrePost.psm1` files (see [`prepost-extension-modules`](prepost-extension-modules.md))

## Automatic variable pitfalls (`ADR-AUTO-AUTOVAR`)

DORA's research links code maintainability to delivery performance—and automatic-variable pitfalls are a major class of silent bugs that
slip through code review. Handling automatic variables safely (read immediately, capture in locals, prefer wrappers) builds the robust error
handling that enables high-frequency deployment.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — avoiding subtle variable-scoping bugs that slip past code
  review.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — robust error handling and consistent patterns enable safe
  automation at scale.
- [Test automation](https://dora.dev/capabilities/test-automation/) — proper error handling patterns surface failures early in testing.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## PowerShell formatting — the language layer over uniform-formatting (`ADR-AUTO-PSFORMAT`)

DORA research links consistent code formatting to improved code maintainability. Mechanical enforcement of uniform standards removes
variation and lets teams focus on logic rather than style.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — consistent conventions enable faster code review.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — clear structure serves as living documentation.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Environment-variable mechanics — the PowerShell layer over environment-variables (`ADR-AUTO-PSENV`)

DORA's research on test automation and deployment reliability emphasizes isolation and predictability—and process-wide environment variables
violate both. Using scoped mechanisms (parameters, return values, `$script:` state) instead of `$env:` for internal coordination provides
automatic cleanup, prevents test leakage, and enables confident concurrent execution.

- [Test automation](https://dora.dev/capabilities/test-automation/) — scoped, isolated state prevents order-dependent test failures and race
  conditions.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — proper scoping bounds state lifetime and surfaces contracts
  at the call site.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — predictable state isolation enables safe parallelism and
  reduces deployment friction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Module-path hygiene — the PowerShell layer over effective-in-enterprises (`ADR-AUTO-MODPATH`)

DORA's research on flexible infrastructure emphasizes deterministic dependencies—and network module paths destroy performance in enterprise
environments. Vendoring PowerShell modules and keeping the module path local by default eliminates network round-trips, makes module loading
predictable, and enables fast automation everywhere.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — running reliably in enterprise environments without
  network delays.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — deterministic, local dependencies enable consistent
  automation across machines.
- [Version control](https://dora.dev/capabilities/version-control/) — vendored modules are reproducible and tracked without gallery access.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Parameter design — the PowerShell layer over sensible-defaults (`ADR-AUTO-PSPARAM`)

DORA's research on code maintainability shows that clear interfaces reduce cognitive load—and well-designed parameters make call sites
self-documenting. Positional primaries and switches for opt-in behavior surface intent at the call site, eliminating named-parameter noise
and making functions easier to understand and reuse.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — clear parameter surfaces reduce the burden of understanding
  what each call does.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — self-documenting call sites serve as examples; positional
  and switch conventions are widely understood.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Working-directory mechanics — the PowerShell layer over never-depend-on-pwd (`ADR-AUTO-PSPWD`)

DORA research shows that eliminating implicit dependencies on environmental state improves code reliability and team velocity. Anchoring
paths to fixed locations and restoring working directory in try/finally guarantees functions compose correctly and never pollute session
state.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — explicit anchors eliminate hidden state pollution and
  failures.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — location-independent functions compose and work
  everywhere.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Cross-platform PowerShell — the language layer over cross-platform (`ADR-AUTO-PSXPLAT`)

DORA's research on flexible infrastructure links platform-agnostic code to deployment reliability—and PowerShell's cross-platform support
enables one codebase on Windows and Linux. Catching platform incompatibilities at analysis time rather than at runtime reduces the friction
of multi-platform deployment and enables confident automation across all environments.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — running on Windows and Linux from one codebase.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — platform-agnostic patterns centralize business logic away
  from environment-specific concerns.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — analyzer catches platform breaks at analysis time,
  before code runs on different OSes.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Dynamic module manifests — the PowerShell layer over open-closed-architecture (`ADR-AUTO-MANIFEST`)

DORA's research links loosely coupled architecture to deployment frequency—and dynamic manifests enable teams to add functions without
editing shared files or resolving merge conflicts. Convention-based discovery (filesystem-as-manifest) eliminates the "add function, edit
manifest, update export list" ceremony, reducing onboarding overhead and merge conflict friction.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — module-based architecture where new functions never
  require edits to shared infrastructure files.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — convention-based discovery (one file = one function = one
  export) is simpler and cheaper than hand-maintained lists.
- [Version control](https://dora.dev/capabilities/version-control/) — avoiding manifest edits prevents merge conflicts when developers add
  functions in parallel.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Script-scope caching — the PowerShell layer over caching (`ADR-AUTO-PSCACHE`)

DORA research shows that caching frequently-recomputed data improves deployment speed and reliability. Tying cache lifetime to module import
creates a predictable, testable contract: the same data for the entire session, with one invalidation knob.

- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — caching eliminates redundant parsing, accelerating operations.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — consistent cache lifetime ensures predictable automation
  behavior.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — simple, isolated idiom follows one repeatable pattern.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Pester testing — the language layer over test-automation (`ADR-AUTO-PESTER`)

DORA's research on test automation emphasizes isolation and reproducibility—and Pester's gotchas tempt tightly coupled tests that fail
mysteriously or mock so broadly they test nothing. Isolating logic through seams (template roots, config discovery), mocking whole functions
only, and splitting logic from integrity tests ensures fast, reliable test feedback.

- [Test automation](https://dora.dev/capabilities/test-automation/) — hermetic logic tests with seam mocks catch regressions fast without
  process-global state leakage.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — seam-based mocking keeps tests decoupled from implementation
  so refactors do not rewrite the suite.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — splitting logic and integrity tests provides both fast
  feedback and real-world coverage.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Prefer an explicit `-DryRun` switch over the ShouldProcess subsystem (`ADR-AUTO-DRYRUN`)

DORA research shows that explicit, observable test data and return values improve test effectiveness and deployment safety. Capturable
dry-run values enable tests to verify plans without side effects, eliminating both hidden failures and test noise.

- [Test automation](https://dora.dev/capabilities/test-automation/) — capturable return values enable testable assertions without side
  effects.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — explicit dry-run prevents silent failures in automation.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — explicit parameters reduce hidden behavior and implicit
  magic.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Native C# types — one combined assembly, namespace per module (`ADR-AUTO-TYPES`)

DORA research links code maintainability and loosely coupled architecture to faster delivery and fewer defects. This ADR encodes domain
models as native types with fixed shapes, versioned assemblies, and dependency-governed layering, reducing the cognitive load of loose
dictionaries.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — fixed, discoverable type shapes and standardized namespace
  patterns.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — dependency graph governs cross-module type references and
  enforces layering.
- [Version control](https://dora.dev/capabilities/version-control/) — committed prebuilt assembly; everything-as-code principle enables
  reproducible builds.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
