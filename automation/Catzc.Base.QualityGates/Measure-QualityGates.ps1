<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Measure-QualityGates.ps1
    name: measure-quality-gates
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Measure-QualityGates.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#10
  config:
    synopsis: Times quality gates (or analyzer rules), to find what makes a check slow.
    description: |-
      Read-only measurement, not a gate: it runs each named quality gate once with -PassThru (its report going to a
      throwaway folder) and returns one row per gate — its wall-clock seconds, its issue count, and the error when it
      threw — slowest first. By default it times every gate languages.yml names in a language's `checks` (the gates
      Test-Change runs), so the zero-argument call answers "which of my per-change checks is slow".

      With -AnalyzerRules it times the analyzer instead: each PSScriptAnalyzer rule the settings enable, run alone (-IncludeRule)
      over every -Every'th file of the analyzed files (Get-AutomationSourceFiles). The repository's custom checks run
      through one entry rule (Measure-CatzcRules) and are timed as that one row.
    parameters:
      Name: 'The quality gates to time. Default: every gate a language''s `checks` names in languages.yml.'
      AnalyzerRules: Time each analyzer rule instead of the gates.
      Every: 'With -AnalyzerRules: analyze every Nth file (1 = all of them). Default 8, a sample that keeps the run short.'
    outputs: '[pscustomobject] { Name; Seconds; IssueCount; Error }, slowest first.'
    examples:
      - Measure-QualityGates
      - Measure-QualityGates Test-Spelling, Test-Links
      - Measure-QualityGates -AnalyzerRules -Every 4 | Select-Object -First 10
---
#>

function Measure-QualityGates {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name = @(Get-FileLanguage | ForEach-Object { $_.checks } | Select-Object -Unique),

        [switch] $AnalyzerRules,

        [ValidateRange(1, 1000)]
        [int] $Every = 8
    )

    $rows = [System.Collections.Generic.List[object]]::new()
    $scratch = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-measure-$([guid]::NewGuid().ToString('N'))"
    try {
        if ($AnalyzerRules) {
            if (-not (Get-Module PSScriptAnalyzer)) {
                Write-Message 'Loading PSScriptAnalyzer (first use this session)...'
                Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
            }
            $settings = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
            $all = @(Get-AutomationSourceFiles)
            $files = @(for ($index = 0; $index -lt $all.Count; $index += $Every) {
                    $all[$index]
                })
            $rules = @((Get-ScriptAnalyzerRule).RuleName) + 'Measure-CatzcRules'
            foreach ($ruleName in $rules) {
                $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
                $records = @($files | Invoke-ScriptAnalyzer -Settings $settings -IncludeRule $ruleName -ErrorAction SilentlyContinue)
                $rows.Add([pscustomobject]@{ Name = $ruleName; Seconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2); IssueCount = $records.Count; Error = $null })
            }
        }
        else {
            foreach ($gate in $Name) {
                $command = Get-Command $gate -CommandType Function -ErrorAction Ignore
                if (-not $command) {
                    $rows.Add([pscustomobject]@{ Name = $gate; Seconds = 0.0; IssueCount = $null; Error = 'no such command' })
                    continue
                }
                $arguments = @{ PassThru = $true }
                if ($command.Parameters.ContainsKey('OutputFolder')) {
                    $arguments['OutputFolder'] = Join-Path $scratch $gate
                }
                $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
                try {
                    $result = & $command @arguments 6> $null
                    $rows.Add([pscustomobject]@{ Name = $gate; Seconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2); IssueCount = @($result.Issues).Count; Error = $null })
                }
                catch {
                    $rows.Add([pscustomobject]@{ Name = $gate; Seconds = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2); IssueCount = $null; Error = $_.Exception.Message })
                }
            }
        }
    }
    finally {
        if ([System.IO.Directory]::Exists($scratch)) {
            [System.IO.Directory]::Delete($scratch, $true)
        }
    }
    $rows | Sort-Object Seconds -Descending
}
