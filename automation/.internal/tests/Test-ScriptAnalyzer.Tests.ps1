<#
---
catzc:
  immutable:
    path: automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1
    name: test-script-analyzer-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Internal.Tests
    moduletype: pwsh-folder
    catzc_bundle: minimal
  edges:
    page: docs/references/automation/internal/tests/Test-ScriptAnalyzer.Tests.ps1.md
    cites:
      - ADR-AUTO-CACHE#10
      - ADR-PWSH-FORMAT#5
---
#>

Describe 'PSScriptAnalyzer' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'

        $script:targetFiles = [System.Collections.Generic.List[string]]::new()
        foreach ($file in (& (Get-Module Catzc.Base.QualityGates) { Get-AutomationSourceFiles } | Sort-Object)) {
            $script:targetFiles.Add($file)
        }

        $allDiagnostics = & (Get-Module Catzc.Base.QualityGates) {
            param($Files, $Settings)
            @(Get-ScriptAnalyzerDiagnostics -Path $Files -SettingsPath $Settings)
        } $script:targetFiles.ToArray() $settingsPath

        # Index diagnostics as strings by file path — only files WITH violations get an entry.
        $script:diagnosticsByFile = @{}
        foreach ($d in $allDiagnostics) {
            if (-not $script:diagnosticsByFile.ContainsKey($d.ScriptPath)) {
                $script:diagnosticsByFile[$d.ScriptPath] = [System.Collections.Generic.List[string]]::new()
            }
            $script:diagnosticsByFile[$d.ScriptPath].Add("$($d.RuleName): $($d.Message) (line $($d.Line))")
        }
    }

    It 'analyzed the module file set (guards against a silent no-op)' {
        # The violation check below passes vacuously if nothing was analyzed, so prove the scan + shards ran.
        $script:targetFiles.Count | Should -BeGreaterThan 50
    }

    It 'has no PSScriptAnalyzer violations' {
        $offenders = foreach ($entry in ($script:diagnosticsByFile.GetEnumerator() | Sort-Object Key)) {
            "$([System.IO.Path]::GetFileName($entry.Key)):`n  " + ($entry.Value -join "`n  ")
        }
        $offenders | Should -BeNullOrEmpty -Because "PSScriptAnalyzer reported violations:`n$($offenders -join "`n")"
    }
}
