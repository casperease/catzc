# pwsh/Base.QualityGates/Test-ScriptAnalyzer.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Analyzes the automation PowerShell with PSScriptAnalyzer and writes a report to the output folder.

### description

Runs PSScriptAnalyzer over the same automation file set the analyzer test covers (module root `*.ps1`, private/, tests/, and the
.internal/.scriptanalyzer infrastructure folders), applying the single rule set at .internal/assets/PSScriptAnalyzerSettings.psd1 under the
loaded code root (Get-CatzcModulesRoot) — so the result matches what the editor and CI see.

This is the interactive, report-style sibling of the L2 'PSScriptAnalyzer' Pester test (pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1):
both shard the analysis across background processes (see Get-ScriptAnalyzerDiagnostics) so a full-tree run finishes in ~15-30s with live
progress rather than ~90s of silence. It is also the verify counterpart to Format-Code -Language powershell — Format-Code FIXES the
auto-fixable formatting, Test-ScriptAnalyzer only reports and never rewrites files.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every diagnostic
('`<path>:<line>:<col>` `<severity>` `<rule>` `<message>`', repository-relative) is an issue, and the gate ends through
Write-QualityGateReport, which writes out/test-script-analyzer/, prints every issue, and throws once listing them all; -PassThru returns the
result object instead.

A file of the `third-party` glob set (vendored or downloaded, never authored here) is left out of the run, whether it was found under a
directory or named, so the analyzer judges only what the repository writes.

PSScriptAnalyzer is vendored under the code root's .vendor/ — no install step is needed.

### parameter `Path`

One or more files or directories to analyze — absolute, or repository-root-relative (never resolved against $PWD). Defaults to the canonical
checked set (Get-ModuleSourceFile): module root `*.ps1`, private/, tests/, the .internal and .scriptanalyzer infrastructure folders
(bootstrap, TestKit, custom analyzer rules, and their tests), the root importer.ps1, and authored .psd1 config. The default set is the catzc
source tree, so it needs the source mode; an explicit -Path works in either run mode.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-script-analyzer`.

### parameter `NoCache`

Analyze every file, ignoring the result cache (which is still refreshed).

### parameter `PassThru`

Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount }) instead of throwing.

### example 1

```powershell
Test-ScriptAnalyzer
```

### example 2

```powershell
$result = Test-ScriptAnalyzer -PassThru
$result.IssueCount
```

### example 3

```powershell
Test-ScriptAnalyzer -Path pwsh/Base.QualityGates
Analyze just one module.
```

## comment:1

Above `$settingsPath =...`, written with `#`.

```text
The one settings file ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).
```

## comment:2

Above `$files = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Resolve the file set — same coverage as the L2 analyzer test (module root
*.ps1 non-test, private/, tests/ *.Tests.ps1, and the .internal/.scriptanalyzer infrastructure folders).
```

## comment:3

Above `$full = if ([System.IO.Path]::IsPathRooted($item)) {`, written with `#`.

```text
A relative path is repository-relative, never $PWD-relative
([ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS](/docs/drs/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd-noworkingdirectorypaths)).
```

## comment:4

Above `foreach ($f in (Get-ModuleSourceFile)) {`, written with `#`.

```text
The canonical checked set — shared with the L2 analyzer test so they cannot
drift. Includes the root importer.ps1 and authored .psd1 config; excludes generated manifests.
```

## comment:5

Above `Write-Message "Analyzing $($files.Count) PowerShell file(s) with...`, written with `#`.

```text
Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a
serial pass is ~90s of silence and reads as a hang. The upfront message confirms work has started.
```

## comment:6

Above `$thirdParty = Get-GlobSet -Name 'third-party'`, written with `#`.

```text
Third-party files are not authored here, so the analyzer never judges them; a file outside the repository is never
third-party.
```
