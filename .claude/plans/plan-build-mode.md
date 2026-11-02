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
      docs/drs/automation/go/go-test-artifacts.md,
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
  PSScriptAnalyzer, the analyzer settings and rules and `Catzc.Internal.TestKit`; `vendor_policy` stops deciding that. Node, Python, Go and
  their formatters stay tools a consumer installs through the Toolchain commands (ADR-AUTO-PKGMGR); a gate whose tool is missing says which
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
- **One place names the modules folder.** `pwsh` is the `pwsh` track's place in `variants`; `Get-CatzcRunMode`, `Get-CatzcModulesRoot`'s
  fallback, `Get-OverlayRoot` and `Get-ConfigOverlayRoot` read it from there. `Get-CatzcModulesFolder` stays source-only (it throws outside
  the repository by design).
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

### A: the builder and the install

1. [ ] `pwsh/Base.Repository/Get-RepositoryRoot.ps1`: throw when `$env:RepositoryRoot` is unset, naming the importer. (check:
       `Invoke-TestFile -Path pwsh/Base.Repository/tests/Get-RepositoryRoot.Tests.ps1`, then
       `Invoke-TestFile -Path pwsh/.internal/tests/Import-Catzc.Tests.ps1`)
2. [ ] `pwsh/Base.Repository/Get-CatzcRunMode.ps1`: compare against the `pwsh` track's place from `variants`, not the literal. (check:
       `Invoke-TestFile -Path pwsh/Base.Repository/tests/Get-CatzcRunMode.Tests.ps1`)
3. [ ] `pwsh/Base.Repository/Get-CatzcModulesRoot.ps1`: the same for the unset-variable fallback. (check:
       `Invoke-TestFile -Path pwsh/Base.Repository/tests/Get-CatzcModulesRoot.Tests.ps1`)
4. [ ] `pwsh/Base.Repository/Get-OverlayRoot.ps1`: `.catzc/<place>` from the same source. (check:
       `Invoke-TestFile -Path pwsh/Base.Repository/tests/Get-OverlayRoot.Tests.ps1`)
5. [ ] `pwsh/Base.Config/private/Get-ConfigOverlayRoot.ps1`: replace the leaf-of-modules-root at line 15 (the version in a bundle) with the
       same source. (check: `Invoke-TestFile -Path pwsh/Base.Config/tests/Get-ConfigOverlayRoot.Tests.ps1`)
6. [ ] `pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1`: in a bundle load, skip `Sync-TypesContract`, which would write into the
       working root from a contract derived from the bundle folder (ADR-AUTO-BUNDLE-ISSESSION). (check:
       `Invoke-TestFile -Path pwsh/.internal/tests/Import-CSharpTypes.Shipped.Tests.ps1`)
7. [ ] `pwsh/.internal/assets/types/Write-TypesContract.ps1`: make `RepositoryRoot` mandatory instead of the code root's parent. (check:
       `Invoke-TestFile -Path pwsh/.internal/tests/Write-TypesContract.Tests.ps1`)
8. [ ] `pwsh/.internal/assets/builder/Get-ModuleBuildPlan.ps1`: ship Pester, PSScriptAnalyzer, the analyzer settings and rules and
       `Catzc.Internal.TestKit` exactly when the selection holds `Catzc.Base.QualityGates`, whatever `vendor_policy` says. (check:
       `Invoke-TestFile -Path pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1`)
9. [ ] `pwsh/Base.Exporter/types/ExporterConfig.cs`: move `Catzc.Internal.TestKit` out of `DefaultFullInternalFiles` into the gate-following
       set. (check: `Invoke-TestFile -Path pwsh/Base.Exporter/tests/types/ExporterConfig.Tests.ps1`)
10. [ ] `pwsh/Base.Exporter/configs/exporter.yml`: add `base` and `tooling` bundles, each with its version line and footprint limits
        measured from a first build. (check: `Invoke-TestFile -Path pwsh/Base.Exporter/tests/types/ExporterConfig.Tests.ps1`)
11. [ ] `pwsh/Base.Exporter/tests/types/ExporterConfig.Tests.ps1`: "every profile has a bundle", beside the test at line 160. (check: the
        same file under `Invoke-TestFile`)
12. [ ] `pwsh/Base.Exporter/tests/Build-Modules.Bundles.Tests.ps1` (new, L2 integrity, greedy, source-only): build every declared bundle
        unmocked into a temp destination; assert `Assert-CatzcBundle` and a fresh-session load through `New-BuiltCatzcRoot` and
        `Invoke-InBuiltCatzc` calling one public function of each module. (check: the file under `Invoke-TestFile`)
13. [ ] `pwsh/Base.Exporter/tests/Export-Catzc.Install.Tests.ps1` (new, L2, source-only): unmocked `Export-Catzc -Root` into a temp git repo
        and a temp folder with no `.git`; assert the root `importer.ps1`, the idempotent re-install, the derived mode `build`, and that the
        load wrote nothing outside the working root's `out/`. (check: the file under `Invoke-TestFile`)

### B: the walking skeleton

1. [ ] `pwsh/.internal/Catzc.Internal.TestKit.psm1`: `New-ConsumerRoot` (a temp working root with an installed bundle and a given file tree)
       beside `New-BuiltCatzcRoot`, reusing its build. (check: `Invoke-TestFile -Path pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1`)
2. [ ] `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1` (new, L2 greedy, source-only): a consumer with a `.catzc/` config fragment and
       function override and today's local module; asserts what works today. Each later step below adds its assertion here. (check: the file
       under `Invoke-TestFile`)

### C: the consumer's configs

1. [ ] `docs/drs/configuration/module-config-loading.md`: the three config scopes and the whole-file read of a working-root config in build
       mode. (check: `Test-DrsRegistry`, `Test-Links -Path docs/drs/configuration/module-config-loading.md`)
2. [ ] `pwsh/Base.Config/types/ConfigsConfig.cs`: the `scope` key (engine, module, working-root), with `overridable: false` folded into
       `engine`. (check: `Invoke-TestFile -Path pwsh/Base.Config/tests/types/ConfigsConfig.Tests.ps1`)
3. [ ] `pwsh/Base.Config/configs/configs.yml`: a `scope` on every entry that is not the default. (check: the same test file)
4. [ ] `pwsh/Base.Config/Get-Config.ps1`: in build mode, read a working-root config whole from `.catzc/configs/`; add the consumer
       registries beside the sealed one; assertion in the consumer test: a consumer `variants` and a typed consumer config. (check:
       `Invoke-TestFile -Path pwsh/Base.Config/tests/Get-Config.Tests.ps1`, then the consumer test)
5. [ ] `pwsh/Base.Config/private/Resolve-ConfigEntry.ps1`: key the index by namespace and name, and index consumer tracks' `configs/` under
       the consumer's namespace. (check: `Invoke-TestFile -Path pwsh/Base.Config/tests/Resolve-ConfigEntry.Tests.ps1`)
6. [ ] `pwsh/Base.Config/Get-Config.ps1`: resolve a bare name in the calling module's namespace, with `-Namespace` to name another;
       assertion in the consumer test: a consumer config named like a catzc config, typed by a consumer type, read by both sides without
       collision. (check: `Invoke-TestFile -Path pwsh/Base.Config/tests/Get-Config.Tests.ps1`, then the consumer test)

### D: the consumer's modules

1. [ ] `docs/drs/automation/consumer-overlay.md`: keep the `.catzc/` override rules; the overlay names no local module; the scopes of
       configs a fragment may touch. (check: `Test-DrsRegistry`, `Test-Links -Path docs/drs/automation/consumer-overlay.md`)
2. [ ] `docs/drs/automation/consumer-repository.md` (new ADR-AUTO record, registered in `drs.yml`): consumer tracks and namespace, modules
       through the one source loader, its own dependencies, config registry, types, DRS and gates. (check: `Test-DrsRegistry`,
       `Test-Links -Path docs/drs/automation/consumer-repository.md`)
3. [ ] `docs/drs/design/run-modes.md`: consumer modules load from source on top of a bundle; the modes' exclusion is about catzc's modules.
       (check: `Test-DrsRegistry`, `Test-Links -Path docs/drs/design/run-modes.md`)
4. [ ] `pwsh/Base.Overlay/Get-Overlay.ps1`: inventory only `.catzc/` overrides; a non-bundled folder is a finding naming the consumer
       tracks. (check: `Invoke-TestFile -Path pwsh/Base.Overlay/tests/Get-Overlay.Tests.ps1`)
5. [ ] `pwsh/Base.Overlay/private/Get-LocalModuleViolation.ps1`: becomes the consumer-module check over every consumer track (namespace not
       `Catzc`, no command shadowing, no config name catzc owns, `types/` allowed); rename to `Get-ConsumerModuleViolation.ps1`. (check:
       `Invoke-TestFile -Path pwsh/Base.Overlay/tests/Assert-Overlay.Tests.ps1`)
6. [ ] `pwsh/.internal/Catzc.Internal.Importer.psm1`: after the bundle and `Import-Overlay`, load the consumer's pwsh modules from its
       tracks through `Import-ModuleFiles.ps1` with generated manifests, in its `dependencies` order; assertion in the consumer test:
       `<Namespace>.<Folder>` loads, an edit is live after re-import. (check:
       `Invoke-TestFile -Path pwsh/.internal/tests/Import-AllModules.Tests.ps1`, then the consumer test)
7. [ ] `pwsh/Base.Overlay/Import-Overlay.ps1`: delete the `New-Module` local-module path. (check:
       `Invoke-TestFile -Path pwsh/Base.Overlay/tests/Import-Overlay.Tests.ps1`)

### E: the consumer's types

1. [ ] `docs/drs/automation/pwsh/hosting-csharp-types.md` and `docs/drs/automation/BCL/native-csharp-types.md`, one each: one combined
       assembly per namespace; a bundle never compiles catzc's, a consumer's compiles in-process. (check: `Test-DrsRegistry`, `Test-Links`
       on each)
2. [ ] `pwsh/.internal/Catzc.Internal.Types.psm1`: the `Catzc.Types.` prefix becomes a namespace parameter in the load, janitor, holds and
       accelerator code. (check: `Invoke-TestFile -Path pwsh/.internal/tests/Import-TypesAssembly.Tests.ps1`, then
       `Invoke-TestFile -Path pwsh/.internal/tests/Invoke-TypeCacheJanitor.Tests.ps1`)
3. [ ] `pwsh/.internal/assets/bootstrap/Build-CombinedTypeAssembly.ps1`: take the namespace, the source set, the output folder and extra
       references. (check: `Invoke-TestFile -Path pwsh/.internal/tests/Build-CombinedTypeAssembly.Tests.ps1`)
4. [ ] `pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1`: after catzc's prebuilt load, compile and load the consumer's types into
       `<Namespace>.Types.<hash>.dll` under `out/`, reused while the hash holds; refuse a `Catzc.` C# namespace; assertion in the consumer
       test: a consumer type and its accelerator. (check: `Invoke-TestFile -Path pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1`, then
       the consumer test)

### F: the consumer's gates and DRS

1. [ ] `pwsh/Base.Repository/Assert-CatzcSourceTree.ps1` (new public, by staged burst): the guard for catzc-only tools, true only when the
       working root is catzc's own repository. (check: `Invoke-TestFile -Path pwsh/Base.Repository/tests/Assert-CatzcSourceTree.Tests.ps1`)
2. [ ] `pwsh/Base.Repository/Assert-SourceTree.ps1`: true when the working root has tracks to check, in either mode. (check:
       `Invoke-TestFile -Path pwsh/Base.Repository/tests/Assert-SourceTree.Tests.ps1`)
3. [ ] One step per catzc-only tool, switching it to `Assert-CatzcSourceTree`, each proven by its own test file: the Builder,
       `Test-CatzcBuild`, `Test-BuildArtifact`, `Test-GeneratedFiles`, `Build-Readme`, `Get-ReadmeMappings`, `Get-RuleEnforcers`,
       `Get-GlossarySources`, `Test-Glossary`, `Build-EnglishDictionary`, `Install-VendorModule`, `Remove-VendorModules`, `Build-AgentHook`,
       `Invoke-BuildForVsCode`, `Get-CSharpTypeDependency`, `New-Importer`, `Copy-CatzcModule`, `Get-ModuleFunction`,
       `Get-FunctionDependency`, `Test-FunctionDependency`, `Get-InternalAssetDependency`, `Get-ModuleGlobSet`, `Get-ModuleSourceFile`,
       `Test-AnalyzerDrsMap`, `Test-TrackNamespace`, `Test-TrackMemberCommitted`, `Test-LogicTestIdentity`, `Get-FixtureIdentityTokens`,
       `Test-ConfigIdentityHygiene`, `Save-PsReadLineKeyHandlerSet`, `Format-Types`, `Test-ReferencePages`, `Build-CommentView`,
       `Export-Comments`, `Resolve-CatzcBuildVersion`, `Build-DrsCodeDictionary`, `Build-TerminologyDictionary`; the task file splits it
       into one step per file. (check: each file's own test under `Invoke-TestFile`)
4. [ ] `pwsh/Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1`: analyzer rules from the bundle, settings from the working root's
       analyzer config. (check: `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Get-ScriptAnalyzerInputs.Tests.ps1`)
5. [ ] `pwsh/Base.QualityGates/private/Get-TestAutomationTestPaths.ps1`: the working root's tracks' `tests/` folders plus `.catzc/` override
       tests in build mode, never the bundle's. (check:
       `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1`)
6. [ ] `pwsh/Base.QualityGates/Test-QualityGates.ps1` (new public, by staged burst): run the `checks:` union over the working root, one
       report, fail on any issue; assertion in the consumer test: green on the clean consumer, red on a planted defect. (check:
       `Invoke-TestFile -Path pwsh/Base.QualityGates/tests/Test-QualityGates.Tests.ps1`, then the consumer test)
7. [ ] `.github/workflows/ci-pwsh.yml` and `.ado/pipelines/ci-pwsh.yaml`, one each: `Test-QualityGates` before `Test-Automation`. (check:
       each pipeline's trigger test under `Invoke-TestFile`)
8. [ ] `pwsh/Base.Drs/types/DrsConfig.cs`: `drs` registered as a working-root config, so a consumer's `drs.yml` replaces catzc's; assertion
       in the consumer test: `Test-DrsRegistry` on the consumer's one record, no catzc domain in its index. (check:
       `Invoke-TestFile -Path pwsh/Base.Drs/tests/types/DrsConfig.Tests.ps1`, then the consumer test)
9. [ ] `docs/how-to/consumer-repository.md` (new): install a bundle, override a catzc config, add a module in each language with its config
       and types, start a DRS, run `Test-QualityGates` and `Test-Automation` as CI. (check:
       `Test-Links -Path docs/how-to/consumer-repository.md`)

### G: Go as a module language

1. [ ] `docs/drs/automation/go/go-test-artifacts.md`: becomes the Go language record (a `go` track of modules by layout, tests one use),
       renamed `go-language.md` with its `drs.yml` row. (check: `Test-DrsRegistry`,
       `Test-Links -Path docs/drs/automation/go/go-language.md`)
2. [ ] `.claude/CLAUDE.md`: point the ADR-AUTO-GO link at `go-language.md`. (check: `Test-Links -Path .claude/CLAUDE.md`)
3. [ ] `docs/drs/automation/test-artifact-languages.md`: Go named beside python and javascript as a module language. (check:
       `Test-Links -Path docs/drs/automation/test-artifact-languages.md`)
4. [ ] `pwsh/Base.Languages/types/GoConfig.cs`: module roots beside the test root, and `go` registered as a working-root config. (check:
       `Invoke-TestFile -Path pwsh/Base.Languages/tests/types/GoConfig.Tests.ps1`)
5. [ ] `pwsh/Base.Languages/New-GoWorkspace.ps1`: render `go.work` over module folders as well as test folders. (check:
       `Invoke-TestFile -Path pwsh/Base.Languages/tests/New-GoWorkspace.Tests.ps1`)
6. [ ] `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1`: a python, a go, a bash and a javascript consumer module, each with its test, run by
       `Test-Automation` in the consumer. (check: the file under `Invoke-TestFile`)

### H: a working root with no repository

1. [ ] `pwsh/Base.Repository/Assert-GitWorkTree.ps1` (new public, by staged burst): the ADR-REPO-REPOKIND-NOREPO message naming the caller,
       built on `Get-GitIndexPath`'s check. (check: `Invoke-TestFile -Path pwsh/Base.Repository/tests/Assert-GitWorkTree.Tests.ps1`)
2. [ ] `pwsh/Base.Files/Get-RepoStatus.ps1`: call `Assert-GitWorkTree`. (check:
       `Invoke-TestFile -Path pwsh/Base.Files/tests/Get-RepoStatus.Tests.ps1`)
3. [ ] `pwsh/Base.Files/Test-GitPathChanged.ps1`: call `Assert-GitWorkTree`. (check:
       `Invoke-TestFile -Path pwsh/Base.Files/tests/Test-GitPathChanged.Tests.ps1`)
4. [ ] `pwsh/Base.Files/Get-GitChangedPath.ps1`: call `Assert-GitWorkTree`. (check:
       `Invoke-TestFile -Path pwsh/Base.Files/tests/Get-GitChangedPath.Tests.ps1`)
5. [ ] `pwsh/Base.Git/Sync-Topic.ps1`: call `Assert-GitWorkTree`. (check: `Invoke-TestFile -Path pwsh/Base.Git/tests/Sync-Topic.Tests.ps1`)
6. [ ] `pwsh/Base.Git/Save-Topic.ps1`: call `Assert-GitWorkTree`. (check: `Invoke-TestFile -Path pwsh/Base.Git/tests/Save-Topic.Tests.ps1`)
7. [ ] `pwsh/Base.Globs/Get-MarkerBlastRadius.ps1`: call `Assert-GitWorkTree`. (check:
       `Invoke-TestFile -Path pwsh/Base.Globs/tests/Get-MarkerBlastRadius.Tests.ps1`)
8. [ ] `pwsh/Base.VSCode/private/New-VsCodeExtensionFolder.ps1`: catzc's extension assets through `Get-CatzcModuleRoot`, not
       `Get-RepositoryRoot` and the js track place. (check:
       `Invoke-TestFile -Path pwsh/Base.VSCode/tests/New-VsCodeExtensionFolder.Tests.ps1`)
9. [ ] `pwsh/Base.VSCode/private/New-VsCodeFileIconTheme.ps1`: the file-icons and track-lamps assets the same way. (check:
       `Invoke-TestFile -Path pwsh/Base.VSCode/tests/New-VsCodeFileIconTheme.Tests.ps1`)
10. [ ] `pwsh/Base.Overlay/tests/Consumer.L2.Tests.ps1`: a no-repository variant of the consumer; a git command stops with the named
        message, the rest runs. (check: the file under `Invoke-TestFile`)
11. [ ] `docs/drs/repository/repository-kinds.md`: name `Assert-GitWorkTree` under how ADR-REPO-REPOKIND-NOREPO is enforced. (check:
        `Test-Links -Path docs/drs/repository/repository-kinds.md`)

### I: every language in the bundle

1. [ ] `docs/drs/automation/test-artifact-languages.md`: a bundle ships the modules of every selected language track in that language's
       packaged form; drop "no bundle holds a file of a test-artifact language". (check: `Test-DrsRegistry`,
       `Test-Links -Path docs/drs/automation/test-artifact-languages.md`)
2. [ ] `docs/drs/automation/platform-bundle.md`: the runtime payload names the per-language packaged forms, the `platforms` list, and the
       content hash over all of it. (check: `Test-DrsRegistry`, `Test-Links -Path docs/drs/automation/platform-bundle.md`)
3. [ ] `docs/drs/design/thin-platforms.md`: the bundle as the one distributable thin platform layer, carrying every language. (check:
       `Test-Links -Path docs/drs/design/thin-platforms.md`)
4. [ ] `pwsh/Base.Languages/types/LanguagesConfig.cs`: a `package` handler per language (command name and shipped form). (check:
       `Invoke-TestFile -Path pwsh/Base.Languages/tests/types/LanguagesConfig.Tests.ps1`)
5. [ ] `pwsh/Base.Languages/configs/languages.yml`: `package` entries for go, bash, python and javascript. (check: the same test file)
6. [ ] `pwsh/Base.Exporter/types/ExporterBundle.cs`: a `platforms` list with the default set. (check:
       `Invoke-TestFile -Path pwsh/Base.Exporter/tests/types/ExporterConfig.Tests.ps1`)
7. [ ] `pwsh/.internal/assets/builder/Get-ModuleBuildPlan.ps1`: select the modules of every language track in the profile and hand each to
       its language's `package` handler. (check: `Invoke-TestFile -Path pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1`)
8. [ ] `pwsh/.internal/assets/builder/Get-BuildClosureViolation.ps1`: a pwsh call into a Go, Python, bash or JavaScript module must land in
       a selected module and be declared in `dependencies.yml`. (check:
       `Invoke-TestFile -Path pwsh/.internal/tests/Get-BuildClosureViolation.Tests.ps1`)
9. [ ] `pwsh/Base.Exporter/Assert-CatzcBundle.ps1`: every shipped non-pwsh module has its packaged form (a binary per platform, wheels for
       every locked dependency, a `.vsix` per extension). (check:
       `Invoke-TestFile -Path pwsh/Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1`)
10. [ ] `pwsh/Base.Languages/Export-GoModule.ps1` (new public, by staged burst): build a Go module's binaries for the bundle's platforms
        with build paths stripped and the pinned toolchain, byte-identical on rebuild. (check:
        `Invoke-TestFile -Path pwsh/Base.Languages/tests/Export-GoModule.Tests.ps1`)
11. [ ] `pwsh/Base.Languages/Export-BashModule.ps1` (new public, by staged burst): copy a bash module as git stores it, executable bit kept.
        (check: `Invoke-TestFile -Path pwsh/Base.Languages/tests/Export-BashModule.Tests.ps1`)
12. [ ] `pwsh/Base.Languages/Export-PythonModule.ps1` (new public, by staged burst): the module's source plus wheels for its `uv.lock`,
        taken from the managed local cache, never a feed. (check:
        `Invoke-TestFile -Path pwsh/Base.Languages/tests/Export-PythonModule.Tests.ps1`)
13. [ ] `pwsh/Base.Languages/Export-JavaScriptModule.ps1` (new public, by staged burst): a `.vsix` for an extension module, the source for
        any other. (check: `Invoke-TestFile -Path pwsh/Base.Languages/tests/Export-JavaScriptModule.Tests.ps1`)
14. [ ] `pwsh/Base.Repository/Get-CatzcModuleRoot.ps1`: resolve a module of any language track under the code root, so a shipped Go, Python,
        bash or JavaScript module is found in a bundle. (check:
        `Invoke-TestFile -Path pwsh/Base.Repository/tests/Get-CatzcModuleRoot.Tests.ps1`)
15. [ ] `pwsh/Base.Execution` process runner (the command that starts a language tool): run a shipped module from its packaged form — the
        platform's Go binary, bash with the bundle path, Python against the vendored wheels — and name the missing runtime's install command
        when Python or node is absent. (check: the runner's test file under `Invoke-TestFile`)
16. [ ] `pwsh/Base.Exporter/tests/Build-Modules.Languages.Tests.ps1` (new, L2 integrity, greedy, source-only): build a fixture with a Go, a
        bash, a Python and a JavaScript module; assert the packaged forms, a byte-identical rebuild, and from a fresh install in a foreign
        repo and in a folder with no repository, a pwsh call into each that returns its output. (check: the file under `Invoke-TestFile`)
17. [ ] `pwsh/Base.Exporter/configs/exporter.yml`: re-measure each bundle's `max_files` and `max_bytes` with the binaries and wheels in.
        (check: `Invoke-TestFile -Path pwsh/Base.Exporter/tests/types/ExporterConfig.Tests.ps1`)

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
  ([go-test-artifacts](../../docs/drs/automation/go/go-test-artifacts.md)), ADR-PWSH-TYPES
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
