<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationTimingReport.ps1
    folder: private
    name: write-test-automation-timing-report
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationTimingReport.Tests.ps1
    docs: "[Write-TestAutomationTimingReport.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationTimingReport.ps1.md)"
---
#>

function Write-TestAutomationTimingReport {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [Parameter(Mandatory)]
        [hashtable] $Limits,

        [switch] $EnforceTimings
    )

    $violations = @(Get-TestTimingViolation -Rows $Rows -Limits $Limits)
    if ($violations.Count -eq 0) {
        return $false
    }

    $color = if ($EnforceTimings) {
        'Red'
    }
    else {
        'Yellow'
    }
    $header = if ($EnforceTimings) {
        'Tests exceeding level time limits'
    }
    else {
        'Tests exceeding level time limits (report-only — pass -EnforceTimings to fail)'
    }
    Write-Message '' -NoHeader
    Write-Header $header -ForegroundColor $color
    foreach ($violation in $violations) {
        Write-Message "  $violation" -ForegroundColor $color -NoHeader
    }
    Write-Message 'Tag slow tests with a higher level or optimize them.' -NoHeader
    Write-Footer -ForegroundColor $color

    [bool]$EnforceTimings
}
