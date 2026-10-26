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

2. [ ] Base.Contracts: `Get-ContractGroup.ps1` and `private/Get-ContractTypeFindings.ps1` (pages without `## help`),
       `private/Get-ContractDescriptionFindings.ps1` (no page). Check: `Test-Formatting -Path` on the three reports no help hand edit.
3. [ ] Base.Slides: `Build-Diagrams.ps1` (Workers undocumented), `private/Get-DiagramCodeRows.ps1`, `private/Get-DiagramComponentRows.ps1`,
       `private/Get-DiagramImageReference.ps1`, `private/Get-NameMentionFinding.ps1` and `private/Write-DiagramQueryRows.ps1` (pages without
       `## help`). Check: `Test-Formatting -Path` on the six reports no help hand edit.
4. [ ] Base.VSCode: `New-VsCodeSettings.ps1` (Filter documented but gone, RepositoryFilter and LampLanguage undocumented),
       `private/ConvertFrom-EditorConfig.ps1` (page without `## help`). Check: `Test-Formatting -Path` on the two reports no help hand edit.
5. [ ] Tooling.Node: `Install-TypeScript.ps1` (page without `## help`), `Uninstall-TypeScript.ps1` (no page). Check: `Test-Formatting -Path`
       on the two reports no help hand edit.
