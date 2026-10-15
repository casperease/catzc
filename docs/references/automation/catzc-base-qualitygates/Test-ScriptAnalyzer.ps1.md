---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md
    kind: comment-page
    body_sha: d6955c543668
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-NOPWD#1
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs PSScriptAnalyzer over the same automation file set the analyzer test covers (module root *.ps1,
private/, tests/, and the .internal/.scriptanalyzer infrastructure folders), applying the single rule set at
.internal/assets/PSScriptAnalyzerSettings.psd1 under the loaded code root (Get-CatzcModulesRoot) — so the
result matches what the editor and CI see.

This is the interactive, report-style sibling of the L2 'PSScriptAnalyzer' Pester test
(automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1): both shard the analysis across background
processes (see Get-ScriptAnalyzerDiagnostics) so a full-tree run finishes in ~15-30s with live progress
rather than ~90s of silence. It is also the verify counterpart to Format-Code -Language powershell — Format-Code
FIXES the auto-fixable formatting, Test-ScriptAnalyzer only reports and never rewrites files.

A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every
diagnostic ('<path>:<line>:<col> <severity> <rule> <message>', repository-relative) is an issue, and the gate
ends through Write-QualityGateReport, which writes out/test-script-analyzer/, prints every issue, and throws
once listing them all; -PassThru returns the result object instead.

PSScriptAnalyzer is vendored under the code root's .vendor/ — no install step is needed.
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
One or more files or directories to analyze — absolute, or repository-root-relative (never resolved against
$PWD). Defaults to the canonical checked set (Get-AutomationSourceFiles):
module root *.ps1, private/, tests/, the .internal and .scriptanalyzer infrastructure folders (bootstrap,
TestKit, custom analyzer rules, and their tests), the root importer.ps1, and authored .psd1 config. The
default set is the catzc source tree, so it needs the source mode; an explicit -Path works in either run
mode.
```

## comment:3

Above `$settingsPath = Join-Path (Get-CatzcModulesRoot)...`.

```text
The one settings file ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
```

## comment:4

Above `$files = [System.Collections.Generic.List[string]]::new()`.

```text
Resolve the file set — same coverage as the L2 analyzer test (module root
*.ps1 non-test, private/, tests/ *.Tests.ps1, and the .internal/.scriptanalyzer infrastructure folders).
```

## comment:5

Above `$full = if ([System.IO.Path]::IsPathRooted($item)) {`.

```text
A relative path is repository-relative, never $PWD-relative
([ADR-AUTO-NOPWD#1](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1)).
```

## comment:6

Above `foreach ($f in (Get-AutomationSourceFiles)) {`.

```text
The canonical checked set — shared with the L2 analyzer test so they cannot
drift. Includes the root importer.ps1 and authored .psd1 config; excludes generated manifests.
```

## comment:7

Above `Write-Message "Analyzing $($files.Count) PowerShell file(s) with...`.

```text
Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a
serial pass is ~90s of silence and reads as a hang. The upfront message confirms work has started.
```

## comment:8

Above `$settingsPath = Join-Path (Get-CatzcModulesRoot)...`.

```text
The one settings file ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
```

## comment:9

Above `$files = [System.Collections.Generic.List[string]]::new()`.

```text
Resolve the file set — same coverage as the L2 analyzer test (module root
*.ps1 non-test, private/, tests/ *.Tests.ps1, and the .internal/.scriptanalyzer infrastructure folders).
```

## comment:10

Above `$full = if ([System.IO.Path]::IsPathRooted($item)) {`.

```text
A relative path is repository-relative, never $PWD-relative
([ADR-AUTO-NOPWD#1](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1)).
```

## comment:11

Above `foreach ($f in (Get-AutomationSourceFiles)) {`.

```text
The canonical checked set — shared with the L2 analyzer test so they cannot
drift. Includes the root importer.ps1 and authored .psd1 config; excludes generated manifests.
```

## comment:12

Above `Write-Message "Analyzing $($files.Count) PowerShell file(s) with...`.

```text
Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a
serial pass is ~90s of silence and reads as a hang. The upfront message confirms work has started.
```
