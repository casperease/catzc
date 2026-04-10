<#
.SYNOPSIS
    Prints the end-of-run skip report — what was skipped or not run, and why.
.DESCRIPTION
    Writes a final console section (information stream) distinguishing the two ways a discovered test does
    not produce a pass/fail, because they mean different things to the reader:

      - Skipped : the test ran discovery and was then skipped from inside the run — a self-skip when its
                  tool/cloud is absent (Set-ItResult -Skipped -Because '…'), or an `It -Skip`. Each is
                  listed with its reason (the -Because text), so "az not installed" is visible rather than
                  a bare count.
      - Not run : the test was never executed because its tier/category tag fell outside this run's
                  requested scope (the -MinLevel/-MaxLevel/-Category filter). These are grouped by
                  tier+category with counts and the scope that excluded them — listing all of them would be
                  noise, but the breakdown tells the reader exactly what raising -Level would add.

    Silent when nothing was skipped or excluded (a full run reports nothing here). Best-effort presentation:
    the caller wraps it so a rendering error never masks the run outcome. Shares Get-TestLevelTag /
    Get-TestCategoryTag with the rest of the report so tier/category resolution is single-sourced.
.PARAMETER Result
    The Pester run object ($result from Invoke-Pester -Configuration <with Run.PassThru>).
.PARAMETER MinLevel
    The -MinLevel the run was invoked with — names the excluding scope in the "not run" header.
.PARAMETER MaxLevel
    The -MaxLevel (-Level) the run was invoked with — names the excluding scope in the "not run" header.
.PARAMETER Category
    The -Category the run was invoked with (Logic/Integrity/Both) — named in the scope when not Both.
#>
function Write-TestAutomationSkipReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Result,

        [int] $MinLevel = 0,

        [int] $MaxLevel = 3,

        [string] $Category = 'Both'
    )

    $tests = @($Result.Tests)
    $skipped = @($tests | Where-Object { $_.Result -eq 'Skipped' })
    $notRun = @($tests | Where-Object { $_.Result -eq 'NotRun' })

    if ($skipped.Count -eq 0 -and $notRun.Count -eq 0) {
        return
    }   # nothing to report — stay silent

    Write-Message '' -NoHeader
    Write-Header 'Skipped & not run' -ForegroundColor Cyan

    # Skipped — actively skipped during the run, each with the reason from Set-ItResult -Because (an `It
    # -Skip` carries none). Listed individually: a self-skip naming the missing tool is the whole value.
    if ($skipped.Count -gt 0) {
        Write-Message "  Skipped ($($skipped.Count)) — ran, then skipped from inside the test:" -NoHeader
        foreach ($test in $skipped) {
            $reason = Get-TestSkipReason -Test $test
            Write-Message "    [$reason] $($test.ExpandedPath)" -NoHeader
        }
    }

    # Not run — excluded by this run's tier/category scope, never executed. Grouped by tier+category with
    # counts so the breakdown shows exactly what a wider -Level/-Category would add, without 90+ lines.
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
            Group-Object { "$(Get-TestLevelTag -Test $_) $(Get-TestCategoryTag -Test $_)" } |
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
