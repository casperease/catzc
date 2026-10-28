# DORA explanations — pwsh

The `Dora explains` rationale for the records of the `automation/pwsh/` domain. Each entry names its record by code, then ties it to
[DORA](../../../references/dora/index.md) research with the domain-relevant capability links; the decisions live in the records themselves.

## The pwsh engine

`The pwsh engine — PowerShell 7 as catzc's module engine`

[ADR-PWSH-ENGINE](pwsh-engine.md)

> DORA's research links reproducible, automated environments to delivery performance. One PowerShell floor, strict mode in every scope,
> terminating preferences set once, and one importer for the source tree and the build mean every session — a devbox, a pipeline agent, an
> installed build — fails the same way on the same mistake, so a defect surfaces where it is made rather than on another machine.

- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — strict mode and terminating preferences make
  every run fail fast on the same defect.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — one importer and one entry per run mode keep the
  load sequence in one living copy.
- [Flexible infrastructure](../../../references/dora/capabilities.md#flexible-infrastructure) — the same session is set up from the
  repository or from an installed build.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## One function per file

[ADR-PWSH-ONEFUNC](one-function-per-file.md)

> DORA's research on code maintainability emphasizes modularity and navigability, and one function per file encodes both in the file
> structure. Matching file name to function name removes AST parsing and merge conflicts, shows the module's surface at a glance, and pairs
> each function with its test file.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — file name equals function name eliminates search
  friction and serves as self-documenting structure.
- [Loosely coupled teams](../../../references/dora/capabilities.md#loosely-coupled-teams) — one-function-per-file prevents merge conflicts
  when developers add functions in parallel.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — test files pair naturally with function files, improving
  test coverage and organization.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Config reading

[ADR-PWSH-CONFIG](config-reading.md)

> DORA's research on code maintainability favours one obvious way to do a common thing. One reader cmdlet and one validator convention mean
> every function reads configuration the same way, so a config change has one path to review and one cache to trust.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — one reader replaces per-function YAML parsing and
  ad-hoc caches.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — a gate ties every validator to a shipped config.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## ADO pipeline functions

[ADR-PWSH-ADOFUNC](ado-pipeline-functions.md)

> DORA's research on deployment automation favours pipeline steps a developer can run locally. One function per pipeline header and per
> pipeline variable keeps the engine's spellings in one place, so a step reads the same in a pipeline and at a prompt.

- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — pipeline values come from named functions, not
  inline lookups.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## `.ps1` function files

`Use .ps1 for function files, not .psm1`

[ADR-PWSH-USEPS](use-ps1-not-psm1.md)

> DORA research shows that aligning code structure with established community patterns improves maintainability and reduces onboarding
> friction. Using .ps1 files for module functions eliminates the scope isolation and boilerplate, letting developers focus on logic rather
> than module plumbing; `.psm1` is kept for genuine module or standalone files, so a file's extension tells a reader what kind of thing it
> is.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — shared scope eliminates boilerplate and scope
  isolation overhead.
- [Documentation quality](../../../references/dora/capabilities.md#documentation-quality) — established patterns reduce onboarding friction.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Dynamic module manifests

`Dynamic module manifests — the pwsh rules over open-closed-architecture`

[ADR-PWSH-MANIFEST](dynamic-module-manifests.md)

> DORA's research links loosely coupled architecture to deployment frequency—and dynamic manifests enable teams to add functions without
> editing shared files or resolving merge conflicts. Convention-based discovery (filesystem-as-manifest) eliminates the "add function, edit
> manifest, update export list" ceremony, reducing onboarding overhead and merge conflict friction.

- [Loosely coupled teams](../../../references/dora/capabilities.md#loosely-coupled-teams) — module-based architecture where new functions
  never require edits to shared infrastructure files.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — convention-based discovery (one file = one
  function = one export) is simpler and cheaper than hand-maintained lists.
- [Version control](../../../references/dora/capabilities.md#version-control) — avoiding manifest edits prevents merge conflicts when
  developers add functions in parallel.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Module-path hygiene

`Module-path hygiene — the pwsh rules over effective-in-enterprises`

[ADR-PWSH-MODPATH](module-path-hygiene.md)

> DORA's research on flexible infrastructure emphasizes deterministic dependencies, and a network module path slows every load in an
> enterprise environment. Vendored modules on a local module path remove the network round-trips and make module loading predictable.

- [Flexible infrastructure](../../../references/dora/capabilities.md#flexible-infrastructure) — running reliably in enterprise environments
  without network delays.
- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — deterministic, local dependencies enable
  consistent automation across machines.
- [Version control](../../../references/dora/capabilities.md#version-control) — vendored modules are reproducible and tracked without
  gallery access.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Vendor toolset dependencies

[ADR-PWSH-VENDOR](vendor-toolset-dependencies.md)

> DORA research shows that vendored dependencies and version pinning reduce deployment variability and enable reproducible builds. Checking
> modules into git and never calling the PowerShell Gallery at runtime guarantees every developer and CI run uses identical code,
> eliminating version-skew bugs and network brittleness.

- [Flexible infrastructure](../../../references/dora/capabilities.md#flexible-infrastructure) — eliminates network dependency, enables
  offline work.
- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — version pinning and explicit diffs prevent
  version-skew surprises.
- [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — fast disk loading and no version skew accelerate
  cycles.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## PrePost extension modules

[ADR-PWSH-PREPOST](prepost-extension-modules.md)

> DORA's research connects loosely coupled architectures to faster delivery and better team autonomy. A single, clearly-defined extension
> point for per-template hooks allows teams to customize deployments without scattered code or central orchestration.

- [Loosely coupled teams](../../../references/dora/capabilities.md#loosely-coupled-teams) — clear extension points enable independent
  template customization.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — grouped hooks in one .psm1 avoid scattered,
  duplicated code.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Error handling

`Error handling — fail immediately, no warnings`

[ADR-PWSH-ERROR](error-handling.md)

> DORA's research links fail-fast patterns to deployment reliability—and PowerShell's complex error model tempts silent failures. Using
> terminating errors with `throw` and self-contained assertions eliminates the "maybe wrong" middle ground, surfaces problems immediately,
> and enables CI to fail clearly instead of succeeding with warnings.

- [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — fail-fast patterns prevent silent failures and
  corrupted state.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — two-state error handling (success or throw) is
  simpler than distinguishing warnings from errors.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — deterministic error behavior makes test assertions reliable
  and failures easy to diagnose.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Assert idioms

`Assert idioms — failing fast in pwsh`

[ADR-PWSH-ASSERT](assert-idioms.md)

> DORA's research links early failure detection and clear error messages to deployment reliability. In PowerShell that means one assertion
> library at fixed places — after the param block and after each external call — and a declared time limit on long work, so failures surface
> at their source with a consistent message and a hang ends at a known limit.

- [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — assertions and time limits stop bad state and hangs
  before they reach a deployment.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — preconditions read as the first lines of a
  function, with one greppable message per assumption.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — a test proves an assertion fires with `Should -Throw`, and
  nothing else catches one.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Announce state changes

`Announce every state change on the information stream`

[ADR-PWSH-ANNOUNCE](announce-state-changes.md)

> DORA treats observability as the ability to explain a system's behaviour from what it emits, without changing it to ask a new question. A
> console session that announces every change made to it, from the binaries and modules it loads to the `PATH` entries it moves and the
> variables it sets, explains its own state from its scrollback. A wrong tool resolution or a stale types build is diagnosed by reading, not
> by re-running with diagnostics, which shortens the time to restore a broken environment.

- [Monitoring and observability](../../../references/dora/capabilities.md#monitoring-and-observability) — every state change is a recorded
  event, so the session's state can be explained from its output alone.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — one writer chokepoint keeps every line out of test output,
  so test results stay readable and no test needs its own output guard.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — an analyzer rule names any unannounced change, so
  the rule holds as code is added rather than depending on review alone.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## foreach over ForEach-Object

`Prefer foreach over ForEach-Object`

[ADR-PWSH-FOREACH](prefer-foreach-over-foreach-object.md)

> DORA research shows that correct language semantics and predictable control flow reduce debugging time and test failures. Using foreach
> for iteration eliminates entire classes of bugs where control flow keywords behave unexpectedly in scriptblock contexts.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — correct control flow semantics reduce cognitive
  load and bugs.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — predictable iteration behavior enables reliable, non-flaky
  tests.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Approved verbs

`Respect PowerShell approved verbs`

[ADR-PWSH-VERBS](respect-pwsh-verb-rules.md)

> DORA research shows that consistent naming conventions improve code maintainability and enable teams to understand unfamiliar code by name
> alone. Using PowerShell's approved verbs as the shared vocabulary transforms function names into behavioral contracts every team member
> recognizes.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — consistent verbs reduce cognitive load, enable
  behavior prediction.
- [Documentation quality](../../../references/dora/capabilities.md#documentation-quality) — verbs encode contracts that document behavior in
  names.
- [Loosely coupled teams](../../../references/dora/capabilities.md#loosely-coupled-teams) — shared verbs enable independent navigation of
  unfamiliar code.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Automatic variable pitfalls

[ADR-PWSH-AUTOVAR](automatic-variable-pitfalls.md)

> DORA's research links code maintainability to delivery performance, and automatic-variable pitfalls are a class of silent bugs that slip
> through code review. Reading them at once, capturing them in locals, and preferring wrappers removes that class.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — avoiding subtle variable-scoping bugs that slip
  past code review.
- [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — robust error handling and consistent patterns enable
  safe automation at scale.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — proper error handling patterns surface failures early in
  testing.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## `-DryRun` over ShouldProcess

`Prefer an explicit -DryRun switch over the ShouldProcess subsystem`

[ADR-PWSH-DRYRUN](prefer-dryrun-over-shouldprocess.md)

> DORA research shows that explicit, observable return values improve test effectiveness. PowerShell's ShouldProcess narrates to the host,
> where no test can capture it; a returned `-DryRun` plan is assertable and leaves the test run silent.

- [Test automation](../../../references/dora/capabilities.md#test-automation) — capturable return values enable testable assertions without
  side effects.
- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — explicit dry-run prevents silent failures in
  automation.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — explicit parameters reduce hidden behavior and
  implicit magic.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Identifier names

`Identifier names — the pwsh rules over spell-out-names`

[ADR-PWSH-NAMES](identifier-names.md)

> Consistent, spelled-out identifiers make code searchable and self-documenting, and an analyzer that checks every variable and function
> noun on every build turns that convention into fast feedback rather than a review argument.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — one spelling per concept keeps grep and rename
  reliable.
- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — coined names are flagged by the analyzer
  quality gate before push.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## PowerShell formatting

`PowerShell formatting — the language layer over uniform-formatting`

[ADR-PWSH-FORMAT](powershell-formatting.md)

> DORA research links consistent code formatting to improved code maintainability. Mechanical enforcement of uniform standards removes
> variation and lets teams focus on logic rather than style. Reducing syntactic noise and following language idioms, such as semicolon-free
> statements, correlates with faster code review cycles and fewer defects.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — consistent conventions and idiomatic syntax enable
  faster code review.
- [Documentation quality](../../../references/dora/capabilities.md#documentation-quality) — clear structure serves as living documentation.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — every analyzer rule names the DRS rule it enforces, so rule
  coverage counts it.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Environment-variable mechanics

`Environment-variable mechanics — the pwsh rules over environment-variables`

[ADR-PWSH-ENV](environment-variable-mechanics.md)

> DORA's research on test automation and deployment reliability emphasizes isolation and predictability—and process-wide environment
> variables violate both. Using scoped mechanisms (parameters, return values, `$script:` state) instead of `$env:` for internal coordination
> provides automatic cleanup, prevents test leakage, and enables confident concurrent execution.

- [Test automation](../../../references/dora/capabilities.md#test-automation) — scoped, isolated state prevents order-dependent test
  failures and race conditions.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — proper scoping bounds state lifetime and surfaces
  contracts at the call site.
- [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — predictable state isolation enables safe parallelism
  and reduces deployment friction.
- [Pervasive security](../../../references/dora/capabilities.md#pervasive-security) — a secret reaches a child process only through one
  masked, scoped seam.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Parameter design

`Parameter design — the pwsh rules over sensible-defaults`

[ADR-PWSH-PARAM](parameter-design.md)

> DORA's research on code maintainability shows that clear interfaces reduce cognitive load—and well-designed parameters make call sites
> self-documenting. Positional primaries and switches for opt-in behavior surface intent at the call site, eliminating named-parameter noise
> and making functions easier to understand and reuse.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — clear parameter surfaces reduce the burden of
  understanding what each call does.
- [Documentation quality](../../../references/dora/capabilities.md#documentation-quality) — self-documenting call sites serve as examples;
  positional and switch conventions are widely understood.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Bounded enumeration

`Bounded enumeration — the pwsh rules over sensible-defaults`

[ADR-PWSH-ENUM](bounded-enumeration.md)

> DORA's research on continuous integration ties a fast, reliable build to short feedback loops, and a search that walks an unbounded tree
> grows slower with every file the repository gains. A shallow default depth, pruned folders, and one compiled walker keep each search at a
> cost its caller chose.

- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — a bounded search keeps the integration budget
  from eroding as the tree grows.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — one walk with one set of rules replaces many
  hand-written loops.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — fast, bounded listings keep all tests under their time
  roofs.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Working-directory mechanics

`Working-directory mechanics — the pwsh rules over never-depend-on-pwd`

[ADR-PWSH-PWD](working-directory-mechanics.md)

> DORA research shows that eliminating implicit dependencies on environmental state improves code reliability and team velocity. Anchoring
> paths to fixed locations and restoring working directory in try/finally guarantees functions compose correctly and never pollute session
> state.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — explicit anchors eliminate hidden state pollution
  and failures.
- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — location-independent functions compose and work
  everywhere.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Cross-platform PowerShell

`Cross-platform PowerShell — the language layer over cross-platform`

[ADR-PWSH-XPLAT](cross-platform-powershell.md)

> DORA's research on flexible infrastructure links platform-agnostic code to deployment reliability, and PowerShell runs one codebase on
> Windows and Linux. Catching platform incompatibilities at analysis time rather than at runtime keeps multi-platform deployment cheap.

- [Flexible infrastructure](../../../references/dora/capabilities.md#flexible-infrastructure) — running on Windows and Linux from one
  codebase.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — platform-agnostic patterns centralize business
  logic away from environment-specific concerns.
- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — analyzer catches platform breaks at analysis
  time, before code runs on different OSes.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Script-scope caching

`Script-scope caching — the pwsh rules over caching`

[ADR-PWSH-CACHE](script-scope-caching.md)

> DORA research shows that caching frequently-recomputed data improves deployment speed and reliability. Tying cache lifetime to module
> import creates a predictable, testable contract: the same data for the entire session, with one invalidation knob.

- [Continuous delivery](../../../references/dora/capabilities.md#continuous-delivery) — caching eliminates redundant parsing, accelerating
  operations.
- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — consistent cache lifetime ensures predictable
  automation behavior.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — simple, isolated idiom follows one repeatable
  pattern.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Pester testing

`Pester testing — the language layer over test-automation`

[ADR-PWSH-PESTER](pester-testing.md)

> DORA's research on test automation emphasizes isolation and reproducibility—and Pester's gotchas tempt tightly coupled tests that fail
> mysteriously or mock so broadly they test nothing. Isolating logic through seams (template roots, config discovery), mocking whole
> functions only, and splitting logic from integrity tests ensures fast, reliable test feedback.

- [Test automation](../../../references/dora/capabilities.md#test-automation) — hermetic logic tests with seam mocks catch regressions fast
  without process-global state leakage.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — seam-based mocking keeps tests decoupled from
  implementation so refactors do not rewrite the tests.
- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — splitting logic and integrity tests provides
  both fast feedback and real-world coverage.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Hosting C# types in pwsh

`Hosting C# types in pwsh — the compiler, the reference set, accelerators, and stale types`

[ADR-PWSH-TYPES](hosting-csharp-types.md)

> DORA research ties code maintainability and fast feedback to delivery performance. Compiling the types with the host's own compiler
> against only the references the host guarantees keeps a fresh checkout buildable with nothing but pwsh, and a stale type is answered with
> a new process rather than a confusing failure.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — no external packages, short source-anchored
  aliases, one compile path.
- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — CI never runs on stale types; it throws.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Idempotent state mechanics

[ADR-PWSH-IDEM](idempotent-state-mechanics.md)

> DORA's research ties deployment automation and fast recovery to delivery performance, and both depend on automation that is safe to run
> again. Writing the replacing cmdlets, guarding list-valued settings, keeping `-Force` to one meaning, and returning one result on both
> paths make a re-run of any pwsh state function leave the same system and the same output, so a retried stage or a restarted setup needs no
> cleanup first.

- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — a deployment step that can be re-run safely is
  one that can be retried automatically.
- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — a retried CI stage converges instead of
  failing on a duplicate.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — one meaning for `-Force` and one result shape per
  function keep every state function readable the same way.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Run-mode mechanics

[ADR-PWSH-RUNMODE](run-mode-mechanics.md)

> DORA's research ties deployment automation and test automation to reliable releases. One importer behind both entry scripts, one module
> per session state in the package, and a mode derived from the code root mean the shipped package and the source tree load the same code
> the same way, so what the tests prove in one form holds in the other.

- [Deployment automation](../../../references/dora/capabilities.md#deployment-automation) — the package enters through the same importer the
  source tree uses.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — the same test files run against both entry scripts.
- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — every pwsh spelling of the run modes lives in one
  record.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.

## Pipeline detection

[ADR-PWSH-DETECT](pipeline-detection.md)

> DORA's research links code maintainability and comprehensive testing to fewer defects and faster deployment cycles. One pwsh function that
> reads every engine's run mark keeps context-dependent logic greppable, testable, and consistent, so an engine is never silently missed and
> a mismatch never surfaces late as a cryptic deployment failure.

- [Code maintainability](../../../references/dora/capabilities.md#code-maintainability) — one detection function keeps the logic consistent
  across every caller.
- [Test automation](../../../references/dora/capabilities.md#test-automation) — the detection function is trivially testable by setting a
  run-mark variable.
- [Continuous integration](../../../references/dora/capabilities.md#continuous-integration) — the same detection on every engine keeps a CI
  run from taking a devbox path.
- [DORA research reference](../../../references/dora/index.md) — the overview these findings sit within.
