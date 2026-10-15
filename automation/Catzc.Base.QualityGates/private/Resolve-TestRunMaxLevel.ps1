<#
.SYNOPSIS
    Resolves the highest tier a test run executes, from the location it runs in.
.DESCRIPTION
    L3 holds the vertical system tests: they change or depend on state outside the repository — the cloud, the user's...
    [ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33),
    [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10),
    [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Resolve-TestRunMaxLevel.ps1.md#comment1)
.PARAMETER Location
    The location Enter-TestRunLocation returned.
.PARAMETER Requested
    The highest tier the caller asks for.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Resolve-TestRunMaxLevel.ps1.md#comment2)
.PARAMETER MinLevel
    The lowest tier the caller asks for.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/private/Resolve-TestRunMaxLevel.ps1.md#comment3)
.OUTPUTS
    [int] the highest tier to run.
.EXAMPLE
    $maxLevel = Resolve-TestRunMaxLevel -Location $location
#>
function Resolve-TestRunMaxLevel {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Location,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $Requested = [Catzc.Base.Timeouts.TestTiers]::DefaultTop,

        [ValidateSet(0, 1, 2, 3, 4)]
        [int] $MinLevel = 0
    )

    if ($Requested -lt 3 -or ($Location.Mode -ne 'snapshot' -and $Location.SystemTests)) {
        return $Requested
    }

    # The tiers the cap drops: L3, and L4 when it was asked for.
    $skipped = if ($Requested -gt 3) {
        'L3 and L4'
    }
    else {
        'L3'
    }
    if ($Location.Mode -eq 'snapshot') {
        if ($MinLevel -gt 2) {
            throw "This run asks for L$MinLevel and up, but runs in a snapshot, which skips $skipped — run it when the working folder is free."
        }
        $holder = if ($Location.Holder) {
            " ($($Location.Holder.Description) holds it)"
        }
        else {
            ''
        }
        Write-Message "Skipping ${skipped}: vertical system tests change state outside the repository, so they run only in the working folder itself$holder." -ForegroundColor Yellow
        return 2
    }

    # In place, but another run on this account — from another checkout — holds the system-test lock.
    $holder = if ($Location.SystemTestHolder) {
        $Location.SystemTestHolder.Description
    }
    else {
        'another test run'
    }
    if ($MinLevel -gt 2) {
        throw "This run asks for L$MinLevel and up, but $holder holds the system-test lock — L3 changes state that belongs to the user, so one run on this account runs it at a time. Run it when that run has finished."
    }
    Write-Message "Skipping ${skipped}: $holder holds the system-test lock — vertical system tests change state that belongs to the user, not to this checkout, so one run on this account runs them at a time." -ForegroundColor Yellow
    2
}
