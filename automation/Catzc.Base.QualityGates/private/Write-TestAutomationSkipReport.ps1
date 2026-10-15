<#
.SYNOPSIS
    Prints the end-of-run skip report — what was skipped or not run, and why.
.DESCRIPTION
    Writes a final console section (information stream) distinguishing the two ways a discovered test does not...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md#comment1)
.PARAMETER Rows
    The aggregated per-test rows (ConvertTo-TestAutomationRowSet output, merged across shards).
.PARAMETER MinLevel
    The -MinLevel the run was invoked with — names the scope that excluded a test in the "not run" header.
.PARAMETER MaxLevel
    The -MaxLevel (-Level) the run was invoked with — names the scope that excluded a test in the "not run" header.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md#comment2)
.PARAMETER Category
    The -Category the run was invoked with (Logic/Integrity/Both) — named in the scope when not Both.
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

    # Skipped — actively skipped during the run, each with the reason from Set-ItResult -Because (an `It -Skip`...
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md#comment3)
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

    # Not run — excluded by this run's tier/category scope, never executed.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationSkipReport.ps1.md#comment4)
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
