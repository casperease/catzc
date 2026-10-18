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
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task-layers-funnel.md"
    folder: plans
    name: task-layers-funnel
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Task: layers P2, the funnel

Behaviour-preserving: the folder is still `automation/` after this task, but the literal is spelled in as few places as possible and a guard
keeps it so, which is also the regression net for the flip (ADR-PRIN-POKAYOKE). The worklist is section 3 to 5 of the carried rename
worklist in the plan (single sources, registry bypasses, S4 identifiers). One file at a time in module order (Get-ModuleOrder), leaf modules
first; C# edits need a fresh pwsh.

## Steps

1. [x] Bootstrap constants: one constant in `Catzc.Internal.Importer.psm1` from which `New-Importer` writes the shim's line (the
   generated `importer.ps1` stops being a second place; `Build-RootConfig 'importer.ps1'` regenerates it). Check: `New-Importer.Tests.ps1`
   passes; Test-GeneratedFiles clean. Done 2026-10-18: `$script:modulesFolder = 'automation'` at the module's top is the one constant;
   Invoke-Importer and Invoke-ConsumerOverlay read it (the `.catzc/<folder>` overlay check too). New-Importer reads the folder back through
   `Get-CatzcModulesRoot` relative to the root, finds the overlay with it and writes the shim's two `{{modules-folder}}` places from it, so
   the shim spells no folder of its own. The shim it renders equals the committed `importer.ps1`; New-Importer 9/9, Write-ImporterMessage
   5/5, `GENERATED issues=0`, `ANALYZER issues=0` on both files.
2. The Bash hook keeps its own constant (`BashSafeguard.ConfigRelativePath` and the csproj, no importer there); try the csproj change on a
   copy first and confirm the layers doctrine's edge fact before touching the real one. Check: the hook builds; a denied call is still
   logged to out/time-safeguard.log.
3. Registry bypasses (worklist section 4, about 45 sites): move each onto `Get-CatzcModulesRoot` or `Get-Track`, one file per step with its
   test; C# constants such as `GlobsConfig.ConfigPath` read the track root through the config type's resolver where one exists (`AdrsConfig`
   is S3 and stays). Check: that file's Pester file; a grep of the literal in the file finds nothing.
4. Test fixtures that bake `<root>/automation`: a root from the resolver or a neutral root (widget/gadget). Check: the fixture's tests pass.
5. S4 identifiers (worklist section 5), one function per step: file, test, call sites, comment page regenerated. Check: Test-Links,
   Test-Comments on the touched files.
6. Guard: `automation/.scriptanalyzer/NoTrackRootLiteral.psm1` (or a source-conventions entry if the convention gate fits better): a string
   literal equal to any track root in code outside `variants.yml` and the resolvers is a finding citing ADR-AUTO-LAYERS; allowlist declared
   once in its config. Tests with fixtures; registered in `PSScriptAnalyzerSettings.psd1`. Check: its tests pass; Test-ScriptAnalyzer over
   automation reports only the allowlist.
7. Stop: grep for the literal outside the registry returns only the allowlist; Test-GeneratedFiles unchanged from the P0 baseline. Record in
   the plan. Check: both lines in the plan.
8. Tick P2 in `plan-layers-vocabulary-rename-contracts.md`. Check: grep `- [ ]` counts P3 to P8.

## Report

As report-fixed.
