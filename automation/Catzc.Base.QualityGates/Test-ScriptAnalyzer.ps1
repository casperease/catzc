<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
    name: test-script-analyzer
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-NOPWD#1
      - ADR-AUTO-TEST#35
  config:
    synopsis: Analyzes the automation PowerShell with PSScriptAnalyzer and writes a report under out/.
    description: |-
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
    parameters:
      Path: |-
        One or more files or directories to analyze — absolute, or repository-root-relative (never resolved against
        $PWD). Defaults to the canonical checked set (Get-AutomationSourceFiles):
        module root *.ps1, private/, tests/, the .internal and .scriptanalyzer infrastructure folders (bootstrap,
        TestKit, custom analyzer rules, and their tests), the root importer.ps1, and authored .psd1 config. The
        default set is the catzc source tree, so it needs the source mode; an explicit -Path works in either run
        mode.
      OutputFolder: The report base folder. Defaults to <out>/test-script-analyzer.
      NoCache: Analyze every file, ignoring the result cache (which is still refreshed).
      PassThru: Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount }) instead of throwing.
    examples:
      - Test-ScriptAnalyzer
      - |-
        $result = Test-ScriptAnalyzer -PassThru
        $result.IssueCount
      - |-
        Test-ScriptAnalyzer -Path automation/Catzc.Base.QualityGates
        Analyze just one module.
---
#>

function Test-ScriptAnalyzer {
    [CmdletBinding()]
    [Alias('Test-Pssa')]
    param(
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $NoCache,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
    Assert-PathExist $settingsPath

    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            $full = if ([System.IO.Path]::IsPathRooted($item)) {
                $item
            }
            else {
                Join-Path $root $item
            }
            if (Test-Path -LiteralPath $full -PathType Container) {
                # Scripts reach four levels below automation (module, tests, types, file); vendored modules are pruned.
                foreach ($script in Get-ChildPath $full -File -Filter '*.ps1', '*.psm1' -Depth 4) {
                    $files.Add($script)
                }
            }
            else {
                Assert-PathExist $full -PathType Leaf
                $files.Add([System.IO.Path]::GetFullPath($full))
            }
        }
    }
    else {
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

    Write-Message "Analyzing $($files.Count) PowerShell file(s) with PSScriptAnalyzer..."
    $diagnostics = @(Get-ScriptAnalyzerDiagnostics -Path $files -SettingsPath $settingsPath -NoCache:$NoCache)

    # Paths are made repo-relative so the issues read cleanly and are stable across machines.
    $issues = @(foreach ($d in ($diagnostics | Sort-Object ScriptPath, Line, Column)) {
            $relPath = $d.ScriptPath
            if ($relPath -and $relPath.StartsWith($root)) {
                $relPath = $relPath.Substring($root.Length).TrimStart('\', '/') -replace '\\', '/'
            }
            "${relPath}:$($d.Line):$($d.Column) $($d.Severity) $($d.RuleName) $($d.Message)"
        })

    $facts = [ordered]@{
        FileCount = @($diagnostics | ForEach-Object { $_.ScriptPath } | Select-Object -Unique).Count
    }
    Write-QualityGateReport -Subject script-analyzer -Title Test-ScriptAnalyzer -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
