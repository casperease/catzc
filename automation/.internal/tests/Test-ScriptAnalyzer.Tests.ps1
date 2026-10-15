<#
---
catzc:
  derived:
    path: automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1
    kind: test
---
#>

# greedy: the analysis shards across min(ProcessorCount - 1, 10) background pwsh processes of its own —
# stacked on the parallel worker pool that fan-out oversubscribes the machine (and inflates neighbouring
# tests' wall clock against the level time limits); the greedy phase runs it after the pool instead.
Describe 'PSScriptAnalyzer' -Tag 'L2', 'integrity', 'greedy' {
    BeforeAll {
        $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'

        # Draw the exact files from the one shared selector (Get-AutomationSourceFiles), so this gate cannot
        # drift from Test-ScriptAnalyzer
        # ([ADR-PWSH-FORMAT#5](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format5)). The
        # selector covers module *.ps1
        # (root, private/), tests/**/*.Tests.ps1 recursively (so tests/types/ is included), the
        # .internal/.scriptanalyzer infrastructure folders (bootstrap, TestKit, custom analyzer rules, and
        # their tests), the root importer.ps1, and authored .psd1 config; .vendor, .compiled, and generated
        # manifests are excluded as build output. Sorted here for stable, reproducible shard assignment.
        $script:targetFiles = [System.Collections.Generic.List[string]]::new()
        foreach ($file in (& (Get-Module Catzc.Base.QualityGates) { Get-AutomationSourceFiles } | Sort-Object)) {
            $script:targetFiles.Add($file)
        }

        # The one analysis engine Test-ScriptAnalyzer runs (Get-ScriptAnalyzerDiagnostics): the file list sharded
        # across background processes, each importing the vendored analyzer once, and its result cache, which skips
        # every file the analyzer last found clean whose bytes and analyzer inputs are unchanged since
        # ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)) — a pipeline, without the
        # cache, analyzes every file. A shard error fails the run loudly inside the engine.
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
