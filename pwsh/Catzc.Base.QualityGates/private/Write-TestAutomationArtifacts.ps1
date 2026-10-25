<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationArtifacts.ps1.md"
  header: "generated"
---
#>

function Write-TestAutomationArtifacts {
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [object[]] $Rows = @(),

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [string] $OutputFolder,

        [Parameter(Mandatory)]
        [int] $MaxLevel,

        [Parameter(Mandatory)]
        [hashtable] $Limits,

        [Parameter(Mandatory)]
        [string] $RunResult,

        [Parameter(Mandatory)]
        [double] $DurationSeconds,

        [switch] $EnforceTimings,

        [Parameter(Mandatory)]
        [int] $MinLevel,

        [Parameter(Mandatory)]
        [string] $Category,

        [string] $Location
    )

    try {
        Write-TestAutomationReport -Rows $Rows -OutputFolder $RunDirectory -Level $MaxLevel -Limits $Limits `
            -RunResult $RunResult -DurationSeconds $DurationSeconds -TimingsEnforced:$EnforceTimings -Location $Location
        Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $RunDirectory -Leaf) -Encoding utf8
    }
    catch {
        Write-Message "Could not write test report to ${RunDirectory}: $_" -ForegroundColor Yellow -NoHeader
    }

    try {
        Write-TestAutomationSkipReport -Rows $Rows -MinLevel $MinLevel -MaxLevel $MaxLevel -Category $Category
    }
    catch {
        Write-Message "Could not render the skip report: $_" -ForegroundColor Yellow -NoHeader
    }

    try {
        $ruleIds = Get-CatsDrsRuleIds
        Write-TestAutomationRuleCoverage -Rows $Rows -AnalyzerCoverage @(Get-AnalyzerDrsCoverage) `
            -AllRuleIds @($ruleIds) -OutputFolder $RunDirectory
    }
    catch {
        Write-Message "Could not render the rule-coverage report: $_" -ForegroundColor Yellow -NoHeader
    }
}
