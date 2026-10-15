<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Measure-QualityGates.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-CONSOLE#10
---
#>

<#
.SYNOPSIS
    Times quality gates (or analyzer rules), to find what makes a check slow.
.DESCRIPTION
    Each gate runs once with its report in a throwaway folder, so a measurement leaves no report behind.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Measure-QualityGates.ps1.md#comment1)
.PARAMETER Name
    The quality gates to time. Default: every gate a language's `checks` names in languages.yml.
.PARAMETER AnalyzerRules
    Time each analyzer rule instead of the gates.
.PARAMETER Every
    With -AnalyzerRules: analyze every Nth file (1 = all of them). Default 8, a sample that keeps the run short.
.OUTPUTS
    [pscustomobject] { Name; Seconds; IssueCount; Error }, slowest first.
.EXAMPLE
    Measure-QualityGates
.EXAMPLE
    Measure-QualityGates Test-Spelling, Test-Links
.EXAMPLE
    Measure-QualityGates -AnalyzerRules -Every 4 | Select-Object -First 10
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
                # The vendored import takes several seconds on first use in a session, so say so before it.
                # [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)
                # [comment:2](/docs/references/automation/catzc-base-qualitygates/Measure-QualityGates.ps1.md#comment2)
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
