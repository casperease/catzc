---
task:
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: nothing; the module model's resolver is in the tree and Get-AutomationModules and Get-BaseModule are gone (checked 2026-10-18)
  targets:
    [
      automation/.internal/Catzc.Internal.Importer.psm1,
      automation/Catzc.Base.RootConfig,
      automation,
      automation/.scriptanalyzer,
      .claude/hooks/Assert-BashTimeout,
    ]
---

# Task: layers P2, the funnel

Behaviour-preserving: the folder is still `automation/` after this task, but the literal is spelled in as few places as possible and a guard
keeps it so, which is also the regression net for the flip (ADR-PRIN-POKAYOKE). The worklist is section 3 to 5 of the carried rename
worklist in the plan (single sources, registry bypasses, S4 identifiers). One file at a time in module order (Get-ModuleOrder), leaf modules
first; C# edits need a fresh pwsh.

## Steps

1. [x] Bootstrap constants: one constant in `Catzc.Internal.Importer.psm1` from which `New-Importer` writes the shim's line (the generated
       `importer.ps1` stops being a second place; `Build-RootConfig 'importer.ps1'` regenerates it). Check: `New-Importer.Tests.ps1` passes;
       Test-GeneratedFiles clean. Done 2026-10-18: `$script:modulesFolder = 'automation'` at the module's top is the one constant;
       Invoke-Importer and Invoke-ConsumerOverlay read it (the `.catzc/<folder>` overlay check too). New-Importer reads the folder back
       through `Get-CatzcModulesRoot` relative to the root, finds the overlay with it and writes the shim's two `{{modules-folder}}` places
       from it, so the shim spells no folder of its own. The shim it renders equals the committed `importer.ps1`; New-Importer 9/9,
       Write-ImporterMessage 5/5, `GENERATED issues=0`, `ANALYZER issues=0` on both files.
2. [x] Done 2026-10-18. `BashSafeguard.ConfigModulePath` is module-relative, and `BashSafeguard.FindConfig` finds the one top-level folder
       of the repository that holds it (one level only, so a built bundle under out/ is never read; none or two throw, and the hook denies).
       The hook csproj names `$(CatzcModulesFolder)`, which Build-BashTimeoutHook passes from `Get-CatzcModulesFolder` and substitutes when
       it hashes the linked sources; a build without it stops with an error. Checked on a copy first: published to out/hook-check/bin, the
       hook allows a compliant call and denies a 999999 ms one; BashSafeguard 45 tests, Build-BashTimeoutHook 14/14. The live hook
       republishes on the next import. Original step: The Bash hook keeps its own constant (`BashSafeguard.ConfigRelativePath` and the
       csproj, no importer there); try the csproj change on a copy first and confirm the layers doctrine's edge fact before touching the
       real one. Check: the hook builds; a denied call is still logged to out/time-safeguard.log.
3. [x] (PowerShell code; the C# constants are open) Done 2026-10-18 from the guard's worklist, 49 code files: each site reads
       `Get-CatzcModulesRoot`, `Get-CatzcModuleRoot`, or the new `Get-CatzcModulesFolder` (Catzc.Base.Repository: the modules root relative
       to the repository root, throwing outside the source tree; help page, 3 tests, a Division row). A function given a root (a fixture, a
       sandbox, the Builder's `$SourceRoot`) joins or labels with that root's folder, so fixtures keep working. Each file's own Pester file
       passed after it; nine tests had to mock the resolver instead of `Get-RepositoryRoot`, `Resolve-RepoPath` or `Get-Track`. Exempt with
       their reason in `track_root_literal`: the bootstrap constant, `Get-CatzcModulesRoot`, `Get-CatzcRunMode` (it compares against the
       source folder), and the three Exporter files whose `out/automation/{built,packages}` areas are named after the track (Q6, renamed
       with output-formats.yml in P4). The re-run guard leaves one code file: `automation/Catzc.Base.RootConfig/assets/root/importer.ps1`,
       an orphan template nothing reads (rootconfig.yml builds importer.ps1 with New-Importer), listed for the user's delete. The C#
       constants the analyzer does not see: `GlobsConfig.ConfigPath` and the `CliRunner` and Catzc.Types.csproj messages name the module,
       not the folder (GlobsConfig 24/24, CliRunner 12/12); `CommentsConfig.DefaultPages` keeps `automation/*` because it mirrors
       comments.yml, which P4 renames in the same edit (a P4 item, with its tests in types/CommentsConfig.Tests.ps1). Original step:
       Registry bypasses (worklist section 4, about 45 sites): move each onto `Get-CatzcModulesRoot` or `Get-Track`, one file per step with
       its test; C# constants such as `GlobsConfig.ConfigPath` read the track root through the config type's resolver where one exists
       (`AdrsConfig` is S3 and stays). Check: that file's Pester file; a grep of the literal in the file finds nothing.
4. (in progress 2026-10-18, module by module, the user's choice) Done and green, guard 0 per file: Azure, Azure.Cli, Azure.Firewall,
   CodeMeta, ConfigExtensions, Languages, RootConfig, TypesSystem, Vendor, Tooling.Github, Tooling.KeyHandler, Files, Git, ModuleSystem,
   Objects, Contracts, Globs, Repository's path tests, Azure.Templates (26), Docs (16), QualityGates (52), .scriptanalyzer, .internal. The
   rule per literal: a real path reads the resolver (`Get-CatzcModulesRoot`, `Get-CatzcModulesFolder`); a fixture TestKit builds, or code
   that reads the resolver over a throwaway root, follows the real folder name or mocks `Get-CatzcModulesFolder` to a neutral one; pure data
   takes a neutral `widgets` path. The bare place alone is flagged only where a path is built (Join-Path, Resolve-RepoPath, Get-ChildPath,
   Path.Combine), so an ADR domain or layer named `automation` is no hit. Exempt with reasons: the two tests of the constant
   (Get-CatzcModulesRoot, Get-CatzcRunMode), the three Exporter tests (Q6 out/ areas), PipelineTrigger-Integrity (the real globset key, S6).
   Code sites the guard cannot see (the place inside a regex or a here-string) were fixed on the way: Get-ChangeTestFile,
   Get-ImprintStepFile, Test-InIsolation, Test-Markdownlint. Still open: types/CommentsConfig.Tests.ps1 lines 11 and 42-55 test the C#
   default `automation/*` and move with the C# constants (step 3); the messages that named the folder in prose now name the module and
   config, or the resolved path (a message must not call `Get-CatzcModulesFolder`, which throws outside the source tree); Variants, VSCode
   and Get-CatzcOverlayRoot's test wait for their holding sessions. Original step: Test fixtures that bake `<root>/automation`: a root from
   the resolver or a neutral root (widget/gadget). Check: the fixture's tests pass.
5. [x] Done 2026-10-18. `Get-AutomationFunctions` is `Get-ModuleFunction`, `Get-AutomationSourceFiles` is `Get-ModuleSourceFile`,
       `Copy-Automation` is `Copy-CatzcModule` (beside `Get-CatzcModule`); `-AutomationRoot` is `-ModulesRoot` on all nine functions
       that took it, the `$automationRoot` locals are `$modulesRoot`, and the TestKit fake repository's `Automation` key is `ModulesRoot`.
       `Get-AutomationModules` was already gone with the module model. Each file's tests pass, analyzer 0; the comment pages, the help
       sections and their anchors follow. Left for the diagram owner: the module-graph `.drawio.md` and `.drawio.verify.md` still name
       Copy-Automation, and the generated explanation grids and trees (from describe.py) link the old Get-AutomationFunctions page until
       the next minimap run. Original step: S4 identifiers (worklist section 5), one function per step: file, test, call sites, comment
       page regenerated. Check: Test-Links, Test-Comments on the touched files.
6. [x] Guard, built first (the user's choice 2026-10-18, so its report is step 3's exact worklist):
       `automation/.scriptanalyzer/NoTrackRootLiteral.psm1` reports, at severity Information, a string literal or expandable string equal to
       the place of a `modules` track or starting with it plus `/` (help and comments are not strings, so they never count); the places come
       from variants.yml and the exemptions from `source-conventions.yml` `track_root_literal.exempt` (SourceConventionsConfig reads the
       key), so the rule names no root. Registered in CatzcRules.psm1. NoTrackRootLiteral 4/4, SourceConventionsConfig 4/4, CustomRuleWiring
       19/19. First report (`out/track-root-literal-worklist.txt`): 49 code files with 103 findings (step 3), 204 test files with 762 (step
       4); C# constants such as `GlobsConfig.ConfigPath` are outside the analyzer and stay on the step 3 list by hand. Original wording of
       this step: `automation/.scriptanalyzer/NoTrackRootLiteral.psm1` (or a source-conventions entry if the convention gate fits better): a
       string literal equal to any track root in code outside `variants.yml` and the resolvers is a finding citing ADR-AUTO-LAYERS;
       allowlist declared once in its config. Tests with fixtures; registered in `PSScriptAnalyzerSettings.psd1`. Check: its tests pass;
       Test-ScriptAnalyzer over automation reports only the allowlist.
7. Stop: grep for the literal outside the registry returns only the allowlist; Test-GeneratedFiles unchanged from the P0 baseline. Record in
   the plan. Check: both lines in the plan.
8. Tick P2 in `plan-layers-vocabulary-rename-contracts.md`. Check: grep `- [ ]` counts P3 to P8.

## Report

As report-fixed.
