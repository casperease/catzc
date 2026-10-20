<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Measure-QualityGates.ps1
    name: measure-quality-gates
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
    docs: "[Measure-QualityGates.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Measure-QualityGates.ps1.md)"
    cites:
      - ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING
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
            $all = @(Get-ModuleSourceFile)
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
