<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Write-TestAutomationSkipReport.ps1
    folder: private
    name: write-test-automation-skip-report
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Write-TestAutomationSkipReport.Tests.ps1
---
#>

function Write-TestAutomationSkipReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [int] $MinLevel = 0,

        [int] $MaxLevel = 3,

        [string] $Category = 'Both'
    )

    $skipped = @($Rows | Where-Object { $_.Result -eq 'Skipped' })
    $notRun = @($Rows | Where-Object { $_.Result -eq 'NotRun' })

    if ($skipped.Count -eq 0 -and $notRun.Count -eq 0) {
        return
    }   # nothing to report — stay silent

    Write-Message '' -NoHeader
    Write-Header 'Skipped & not run' -ForegroundColor Cyan

    if ($skipped.Count -gt 0) {
        Write-Message "  Skipped ($($skipped.Count)) — ran, then skipped from inside the test:" -NoHeader
        foreach ($row in $skipped) {
            $reason = if ($row.SkipReason) {
                $row.SkipReason
            }
            else {
                'no reason given'
            }
            Write-Message "    [$reason] $($row.ExpandedPath)" -NoHeader
        }
    }

    if ($notRun.Count -gt 0) {
        $scopeParts = @("-MaxLevel $MaxLevel")
        if ($MinLevel -gt 0) {
            $scopeParts += "-MinLevel $MinLevel"
        }
        if ($Category -ne 'Both') {
            $scopeParts += "-Category $Category"
        }
        $scope = $scopeParts -join ' '

        Write-Message "  Not run ($($notRun.Count)) — outside this run's scope ($scope):" -NoHeader

        $groups = $notRun |
            Group-Object { "$($_.Level) $($_.Category)" } |
            Sort-Object Name
        foreach ($group in $groups) {
            $label = if ([string]::IsNullOrWhiteSpace($group.Name)) {
                '(untagged)'
            }
            else {
                $group.Name.Trim()
            }
            Write-Message "    $($label): $($group.Count)" -NoHeader
        }
    }

    Write-Footer -ForegroundColor Cyan
}
