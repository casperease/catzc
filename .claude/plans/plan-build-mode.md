---
plan:
  status: active
  value: highest
  reviewed: 2026-11-02
  class: feature
  targets:
    [
      pwsh/Base.Exporter,
      pwsh/.internal,
      pwsh/Base.Repository,
      pwsh/Base.Overlay,
      pwsh/Base.Config,
      pwsh/Base.Drs,
      pwsh/Base.QualityGates,
      pwsh/Base.Languages,
      pwsh/Base.ModuleSystem/configs/profiles.yml,
      docs/drs/automation/consumer-overlay.md,
      docs/drs/automation/go/go-language.md,
    ]
---

# Build mode

Catzc is developed and built in this repository, in source mode, and only here. Build mode is what another team runs: a bundle installed
into its own repository (or a folder with no repository). On top of the bundle, that repository is a catzc-shaped repository of its own: its
own modules in every catzc language, loaded from source with no build; its own config tree; its own C# types in its own assembly and
namespace; its own DRS; and catzc's gates as its CI. It changes catzc itself only through `.catzc/`.

## Why its value

The bundle is the shipped product (ADR-AUTO-BUNDLE-ISBUILD), and catzc's value to another team is the tooling (tracks, modules, configs,
gates, DRS) applied to that team's code. Verified against the tree on 2026-11-02, a consumer today is blocked six ways:

- **Configs** (today's gap, closed by the config decisions below): catzc's config registry is sealed and is the only registry, so today a
  consumer has no place to register a typed config of its own; names are bare and global (about 741 `Get-Config` call lines), so a consumer
  config with a catzc name throws "exists in multiple modules" at every catzc call site (`Resolve-ConfigEntry.ps1:91`).
- **Repository-describing configs merge instead of replace**: `variants` (the tracks) and `drs` are overridable fragments, so a consumer
  inherits catzc's tracks and DRS domains and can only add to them.
- **Types**: a bundle loads prebuilt only (`Import-CSharpTypes.ps1:23-25`), the overlay refuses `types/`
  (`Get-LocalModuleViolation.ps1:44`), and the assembly prefix `Catzc.Types.` is hard-coded (`Catzc.Internal.Types.psm1:65,97,101`).
- **Modules**: overlay local modules are `New-Module` dynamic modules (`Import-Overlay.ps1:23-49`): no manifest, no namespace, ordinal load
  order, no dependency declaration (`dependencies.yml` is sealed), pwsh only, and the overlay code is wired to `Get-Track -Name pwsh`.
- **Gates**: every generic gate calls `Assert-SourceTree` and refuses a consumer tree; Pester, PSScriptAnalyzer and `Catzc.Internal.TestKit`
  ship only under `-VendorPolicy full` (`Get-ModuleBuildPlan.ps1:105`, `ExporterConfig.cs:15-23`), and no bundle declares `full`; `tests/`
  never ships, so a consumer has no entry that runs the gates.
- **Install proof**: install is tested only mocked (`Export-Catzc.Tests.ps1` targets `C:\work\target`), the overlay only with a mocked code
  root (`Overlay.Fixture.ps1:65`).

## Decided

- **Catzc never runs its own source-tree tools through a bundle.** The builder, catzc's README, dictionary and DRS-index generators, vendor
  install and agent hooks stay catzc-source only; `Test-CatzcBuild` keeps this repository as its working root.
- **Walking skeleton first.** The consumer fixture and its L2 test land before any feature, with one pwsh consumer module; every later step
  that adds a capability adds its assertion to that test in the same step, so the test is the definition of done and is green after every
  step.
- **Three config scopes, declared in the config registry** (`scope:` per entry, one default): _engine_ (sealed, as today), _module_
  (overridable by a `.catzc/` fragment merged key by key, as today), and _working-root_, a config that describes the repository rather than
  the engine (`variants`, `drs`, `plans`, `links`, `file-limits`, `go`, `python`, the analyzer DRS map and the like; the registry entries
  decide). In build mode a working-root config is read **whole** from the working root (`.catzc/configs/<name>.yml`), never merged onto
  catzc's, and falls back to its type's default. In source mode catzc is its own working root, so nothing changes here. This is how a
  consumer gets its own tracks, its own DRS domains and its own plan rules. Lands in consumer-overlay.md and module-config-loading.md.
- **A consumer owns typed configs in its own namespace.** A consumer creates its own configs and their C# types exactly as catzc does: a
  config in a consumer module's `configs/`, its type in that module's `types/` (in the consumer's assembly and C# namespace), registered in
  the consumer's own registry, `configs.yml` in a consumer module's `configs/`, read beside catzc's sealed registry and never merged into
  it. A config's identity is its namespace and its name, so a consumer's `azure` and catzc's `azure` are two configs. A bare name resolves
  in the namespace of the module that calls `Get-Config`, so catzc's 741 call sites keep reading catzc's configs and a consumer's calls read
  its own; `-Namespace` names another one explicitly. Only catzc's own configs are closed to a consumer, except through `.catzc/` fragments
  of module-scope configs.
- **A consumer's own code lives in its own tracks** (from its own working-root `variants`, ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE). Its
  namespace is the consumer track's `namespace` (ADR-AUTO-MODULE-NAMESPACEISTRACK); `Catzc` is refused (PDR-CATS). Its pwsh modules load
  through **the same source-mode loader catzc's modules use** (`Import-ModuleFiles.ps1` and the generated manifest, ADR-PWSH-MANIFEST),
  named `<Namespace>.<Folder>`, ordered by the consumer's own `dependencies.yml` (a module config of the consumer, which may name catzc
  modules), after the bundle and its `.catzc/` overrides; nothing is written to load them, and an edited file is live after re-import. The
  `New-Module` path in `Import-Overlay` is deleted (PDR-ONELIVE). The run mode stays derived from catzc's code root
  (DDR-RUNMODE-MODEISDERIVED), and DDR-RUNMODE-NEVERCOEXIST is about catzc's modules.
- **Overrides of catzc stay in `.catzc/<modules folder>/<bundled module>/`** under ADR-AUTO-OVERLAY. A folder there that names no bundled
  module is a finding that points at the consumer's tracks; the local-module rule leaves the overlay record.
- **A consumer's C# types compile, catzc's never do in a bundle.** The types machinery keys on a namespace instead of the literal
  `Catzc.Types.`: catzc's assembly stays prebuilt in a bundle; a consumer's `types/*.cs` compile in-process (the same Roslyn `Add-Type` path
  source mode uses, no SDK) into `<Namespace>.Types.<hash>.dll` under the working root's `out/`, referencing catzc's loaded assembly, with
  type accelerators under the consumer's prefix. A `Catzc.` C# namespace in consumer code is refused. Lands in hosting-csharp-types.md
  (ADR-PWSH-TYPES) and native-csharp-types.md (ADR-BCL-TYPES: one combined assembly per namespace).
- **The gate tooling follows the gates, not a policy flag.** A bundle that carries `Catzc.Base.QualityGates` carries Pester,
  PSScriptAnalyzer, the analyzer settings and rules and `Catzc.Internal.TestKit`; `vendor_policy` decided nothing else (read 2026-11-02), so
  the key, the `VendorPolicy` parameters and the manifest line are deleted (PDR-ONELIVE), and a gate that enters a built module's scope puts
  `Catzc.Base.QualityGates` in its build selection, as `Test-CatzcBuild` already does with its harness module. Node, Python, Go and their
  formatters stay tools a consumer installs through the Toolchain commands (ADR-AUTO-PKGMGR); a gate whose tool is missing says which
  install command to run.
- **The source-tree guard splits.** `Assert-CatzcSourceTree` guards catzc-only tools; `Assert-SourceTree` keeps its name and means "the
  working root has tracks to check", true in catzc and in a consumer. The generic gates keep calling `Assert-SourceTree` and scan the
  working root's tracks; catzc's analyzer rules apply to consumer code, settings overridable by fragment.
- **One gate entry for every CI.** A new `Test-QualityGates` runs the union of the language registry's `checks:` over the working root (the
  set `Measure-QualityGates` already measures) and fails on any issue; a CI is `Test-QualityGates` then `Test-Automation`, in catzc's
  pipelines and in a consumer's.
- **The DRS tooling reads the working root's `drs.yml`** (a working-root config): a consumer's own kinds and domains, its own `docs/drs`;
  catzc's records are never in a consumer's index.
- **Go is a module language like python and javascript.** That status is "modules of a language track, run as a process by the engine, never
  engine functions, never in the bundle" (ADR-AUTO-TESTLANG-MODULESBYLAYOUT), and Go already has it in all but name and in
  ADR-AUTO-GO-GOTESTMODULE, which confines Go to `tests/`. The engines stay pwsh, bash and zsh (ADR-AUTO-ENGINE-THREEENGINES); a consumer's
  Go, Python and JavaScript modules run through the handlers the bundle carries, configured by the consumer's working-root `go`, `python`
  and `javascript` configs.
- **One place names the modules folder.** `Catzc.Base.Repository` cannot read `variants`: `Catzc.Base.Variants` depends on
  `Catzc.Base.Config`, which depends on `Catzc.Base.Repository`, and `Get-Config` itself calls `Get-CatzcRunMode` through
  `Get-ConfigOverlayRoot` (read 2026-11-02). The one place is the bootstrap constant `$script:modulesFolder` in
  `Catzc.Internal.Importer.psm1`, which every import publishes as `$env:CatzcModulesFolder` beside `$env:CatzcModulesRoot`;
  `Get-CatzcRunMode`, `Get-CatzcModulesRoot`'s fallback, `Get-OverlayRoot` and `Get-ConfigOverlayRoot` read that variable, never the
  literal, and a test pins the `pwsh` track's first member and the module-types folder place `root` to it. `Get-CatzcModulesFolder` stays
  source-only (it throws outside the repository by design).
- **A command that needs git asserts it.** A new `Assert-GitWorkTree` realises ADR-REPO-REPOKIND-NOREPO, built on `Get-GitIndexPath`'s
  existing check.
- **Every declared combination is buildable.** Each `exporter.yml` bundle and each `profiles.yml` profile builds, closes, self-checks and
  loads; `base` and `tooling` get bundle entries. The profile-has-a-bundle check is a test beside the existing "every bundle names a
  profile" test (`ExporterConfig.Tests.ps1:160`), not code in the C# type.
- **The bundle carries every language, because catzc is the thin platform layer the organisation distributes** (DDR-THINPLAT). A bundle
  ships the modules of every language track it selects, not only pwsh; this reverses "no bundle holds a file of a test-artifact language" in
  ADR-AUTO-TESTLANG-MODULESBYLAYOUT. Non-pwsh modules stay tools the engine runs as a process (ADR-AUTO-ENGINE-THREEENGINES unchanged). Each
  language says its shipped form through a `package` handler in the language registry, so the builder never branches on a language
  (ADR-AUTO-MODULE-CHECKSBYLANGUAGE): Go as reproducible binaries built by the pinned toolchain with build paths stripped, one per platform
  in the bundle's declared `platforms` list (default windows/amd64, linux/amd64, darwin/arm64), so a target needs no Go; bash verbatim with
  its executable bit; Python as source plus its locked dependencies as vendored wheels, so nothing contacts a feed at install (no
  package-manager contact), with the runtime found through the managed-toolchain check; JavaScript extensions as `.vsix`, other JavaScript
  as source run by `node`. Order of delivery: Go and bash, then Python, then JavaScript. A shipped module is found under the code root,
  never the working root, and every cross-language call is declared in `dependencies.yml` and proven by the closure check.

## Open steps

Every step landed on 2026-11-03; the last one, the JavaScript type packages in a consumer root, moved to plan-package-sources (chunk C),
where the source they install from is configured. The open question below keeps this plan.

## Open questions

- Simplify proposal, not yet answered: `docs/drs/automation/test-automation.md` states the default top tier twice (2 at :273, 3 at :489) and
  says both runs execute in CI (:729), which no pipeline does; state the tier once from `[TestTiers]::DefaultTop` and drop the CI claim
  until a pipeline runs `Test-CatzcBuild`.
- Simplify proposal, not yet answered: a short explanation page with a diagram of the three roots a consumer session has (working root,
  catzc code root, consumer tracks) and the three config scopes, linked from consumer-repository.md, so the next session reads one page
  instead of three records.

## Refs

- DDR-RUNMODE ([run-modes](../../docs/drs/design/run-modes.md)), ADR-AUTO-BUNDLE
  ([platform-bundle](../../docs/drs/automation/platform-bundle.md)), ADR-AUTO-OVERLAY
  ([consumer-overlay](../../docs/drs/automation/consumer-overlay.md)), ADR-CONF-LOADING
  ([module-config-loading](../../docs/drs/configuration/module-config-loading.md)), ADR-AUTO-MODULE
  ([module-model](../../docs/drs/automation/module-model.md)), ADR-AUTO-TESTLANG
  ([test-artifact-languages](../../docs/drs/automation/test-artifact-languages.md)), ADR-AUTO-GO
  ([go-language](../../docs/drs/automation/go/go-language.md)), ADR-PWSH-TYPES
  ([hosting-csharp-types](../../docs/drs/automation/pwsh/hosting-csharp-types.md)), ADR-REPO-REPOKIND-NOREPO
  ([repository-kinds](../../docs/drs/repository/repository-kinds.md)).
- The generic gates that keep `Assert-SourceTree` (no step, they change through it): `Test-Formatting`, `Format-Code`, `Format-FileMeta`,
  `Test-FileMeta`, `Format-MarkdownTitle`, `Test-MarkdownTitle`, `Test-Links`, `Format-Links`, `Get-LinkEdge`, `Test-LinkDirections`,
  `Test-Plans`, `Test-FileLimits`, `Test-SecretScan`, `Test-NetworkCalls`, `Test-BicepLint`, `Test-ShellScripts`, `Test-PythonLint`,
  `Test-PythonTypes`, `Test-PythonTests`, `Test-JavaScriptTypes`, `Test-Terminology`, `Test-Comments`, `Test-TestTitles`,
  `Test-IdiomaticNames`, `Assert-IdiomaticNames`, `Repair-IdiomaticNames`, `Test-ParameterConsistency`, `Test-ManualTestPlan`,
  `Test-SourceConventions`, `Test-Slides`, `Get-GuidScanFiles`. Each that hard-wires a catzc path shows up red in the consumer test's gate
  assertion, and becomes its own step then.
- The no-repository steps are a sample: `Measure-NoScriptRootAnchor` cannot see string-literal path segments, so the no-repository consumer
  variant finds the rest, each red test a new step.
