# pwsh/Base.QualityGates/Test-ScriptAnalyzer.ps1

The analyzer gate: it runs PSScriptAnalyzer over the automation PowerShell and writes a report to the output folder.

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

## Settings

The one settings file ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).

## The file set

The set has the same coverage as the L2 analyzer test: the module-root `*.ps1` files that are not tests, `private/`, the `*.Tests.ps1` files
in `tests/`, and the `.internal` and `.scriptanalyzer` infrastructure folders. The canonical checked set is shared with that test so they
cannot drift. It includes the root `importer.ps1` and the authored `.psd1` config, and it excludes generated manifests. A relative path is
repository-relative, never relative to the working folder
([ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS](../../../drs/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd-noworkingdirectorypaths)).
Third-party files are not authored here, so the analyzer never judges them. A file outside the repository is never third-party.

## Sharded run

The analysis is sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics), because a serial pass is about 90
seconds of silence and reads as a hang. The message up front confirms that work has started.
