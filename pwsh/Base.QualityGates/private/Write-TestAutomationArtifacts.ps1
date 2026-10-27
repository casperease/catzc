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

    # Written before any throw, so a failing run still has its report.
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

    # Rule coverage unions the tagged tests' and the analyzer rules' enforcers over every rule id; report-only, so a failure never fails the run.
    try {
        $ruleIds = Get-DrsRuleIds
        Write-TestAutomationRuleCoverage -Rows $Rows -AnalyzerCoverage @(Get-AnalyzerDrsCoverage) `
            -AllRuleIds @($ruleIds) -OutputFolder $RunDirectory
    }
    catch {
        Write-Message "Could not render the rule-coverage report: $_" -ForegroundColor Yellow -NoHeader
    }
}
