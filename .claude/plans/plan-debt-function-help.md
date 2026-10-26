---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: debt
  targets: [pwsh, docs/references/pwsh]
---

# Debt function help: every function's help on its comment page, in the shape the ps-help step reads

The ps-help imprint step reports 29 functions whose help it cannot repair by itself: a missing comment page, a page with no `## help`
section, or a parameter declared but undocumented (or documented but gone). The format cache hid them until its stamp covered the engine
code (plan-debt-format-cache); the 2026-10-26 Test-Formatting run lists them. Each is a hand edit to the function's page, never to the
code's parameters.

## Open steps

Each step's check: `Test-Formatting -Path <the module's listed files>` reports no "function help needs a hand edit" for them.

1. [ ] Base.Config: `private/Merge-ConfigFragment.ps1` (parameter Disjoint undocumented).
2. [ ] Base.Contracts: `Get-ContractGroup.ps1` and `private/Get-ContractTypeFindings.ps1` (pages without `## help`),
       `private/Get-ContractDescriptionFindings.ps1` (no page).
3. [ ] Base.FileLimits: `private/Get-StringOverflowLine.ps1` (page without `## help`).
4. [ ] Base.GeneratedFiles: `private/Get-GeneratedWriterStamp.ps1` (InputGlob documented but gone, Writer undocumented, outputs differ).
5. [ ] Base.Globs: `Build-TrackGlobSets.ps1` (no page).
6. [ ] Base.Languages: `New-JsConfig.ps1` and `private/Get-ModuleTestFolder.ps1` (pages without `## help`), `New-PythonProject.ps1`
       (LineLength undocumented), `private/ConvertFrom-NodeTestJunit.ps1` (no page).
7. [ ] Base.QualityGates: `Test-JavaScriptTypes.ps1`, `Test-TrackNamespace.ps1` and `private/Get-JavaScriptTestCases.ps1` (pages without
       `## help`), `private/Get-DrsCitation.ps1`, `private/Get-DrsDefinedRule.ps1` and `private/Get-DrsUsageRow.ps1` (parameters
       undocumented).
8. [ ] Base.Repository: `Get-ModuleFullName.ps1` (RepositoryRoot undocumented).
9. [ ] Base.Slides: `Build-Diagrams.ps1` (Workers undocumented), `private/Get-DiagramCodeRows.ps1`, `private/Get-DiagramComponentRows.ps1`,
       `private/Get-DiagramImageReference.ps1`, `private/Get-NameMentionFinding.ps1` and `private/Write-DiagramQueryRows.ps1` (pages without
       `## help`).
10. [ ] Base.TypesSystem: `New-Solution.ps1` (an `### example` subsection, text before the first subsection).
11. [ ] Base.VSCode: `New-VsCodeSettings.ps1` (Filter documented but gone, RepositoryFilter and LampLanguage undocumented),
        `private/ConvertFrom-EditorConfig.ps1` (page without `## help`).
12. [ ] Tooling.Node: `Install-TypeScript.ps1` (page without `## help`), `Uninstall-TypeScript.ps1` (no page).
