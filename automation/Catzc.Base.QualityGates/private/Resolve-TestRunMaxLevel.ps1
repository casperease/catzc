<#
.SYNOPSIS
    Resolves the highest tier a test run executes, from the slot it runs in.
.DESCRIPTION
    L3 holds the vertical system tests: they change or depend on state outside the repository — the cloud, the
    user's environment, installed tools (ADR-AUTO-TEST:33). A snapshot isolates a run from the working folder,
    never from that outside state, so only the run that owns the working folder (the in-place slot) runs L3 —
    and since that state belongs to the user, not to one checkout, only while it also holds the user's
    system-test lock (Enter-SystemTestLock). Two concurrent runs — from one checkout or from two — never both
    execute system tests against the same user's state, and nobody waits.

    In place with the system-test lock, the requested level stands (the suites ask for 3 unless the caller bound
    a lower -MaxLevel). Otherwise — in a snapshot, or in place while another run on this account holds the
    system-test lock — a request that reaches L3 is capped at L2, and the cap is announced: the run says it
    skips L3 and who holds the working folder or the lock, so a missing tier is never silent
    (ADR-AUTO-CONSOLE:10).
.PARAMETER Slot
    The slot Enter-TestRunSlot returned.
.PARAMETER Requested
    The highest tier the caller asks for. Default 3: every tier the slot allows.
.PARAMETER MinLevel
    The lowest tier the caller asks for. A run that asks only for tiers the slot skips (L3 in a snapshot, or
    without the system-test lock) has nothing to run, so it throws, naming why.
.OUTPUTS
    [int] the highest tier to run.
.EXAMPLE
    $maxLevel = Resolve-TestRunMaxLevel -Slot $slot
#>
function Resolve-TestRunMaxLevel {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Slot,

        [ValidateSet(0, 1, 2, 3)]
        [int] $Requested = 3,

        [ValidateSet(0, 1, 2, 3)]
        [int] $MinLevel = 0
    )

    if ($Requested -lt 3 -or ($Slot.Mode -ne 'Snapshot' -and $Slot.SystemTests)) {
        return $Requested
    }

    if ($Slot.Mode -eq 'Snapshot') {
        if ($MinLevel -gt 2) {
            throw "This run asks for L$MinLevel and up, but runs in a snapshot, which skips L3 — run it when the working folder is free."
        }
        $holder = if ($Slot.Holder) {
            " ($($Slot.Holder.Description) holds it)"
        }
        else {
            ''
        }
        Write-Message "Skipping L3: vertical system tests change state outside the repository, so they run only in the working-folder slot$holder." -ForegroundColor Yellow
        return 2
    }

    # In place, but another run on this account — from another checkout — holds the system-test lock.
    $holder = if ($Slot.SystemTestHolder) {
        $Slot.SystemTestHolder.Description
    }
    else {
        'another test run'
    }
    if ($MinLevel -gt 2) {
        throw "This run asks for L$MinLevel and up, but $holder holds the system-test lock — L3 changes state that belongs to the user, so one run on this account runs it at a time. Run it when that run has finished."
    }
    Write-Message "Skipping L3: $holder holds the system-test lock — vertical system tests change state that belongs to the user, not to this checkout, so one run on this account runs them at a time." -ForegroundColor Yellow
    2
}
