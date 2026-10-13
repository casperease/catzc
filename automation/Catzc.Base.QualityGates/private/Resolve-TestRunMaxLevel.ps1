<#
.SYNOPSIS
    Resolves the highest tier a test run executes, from the slot it runs in.
.DESCRIPTION
    L3 holds the vertical system tests: they change or depend on state outside the repository — the cloud, the
    user's environment, installed tools (ADR-AUTO-TEST:33). A snapshot isolates a run from the working folder,
    never from that outside state, so only the run that owns the working folder (the in-place slot) runs L3.
    That makes the slot the one guard for L3: two concurrent runs never both execute system tests against the
    same repository's outside state, and nobody waits.

    In place, the requested level stands (the suites ask for 3 unless the caller bound a lower -MaxLevel). In a
    snapshot, a request that reaches L3 is capped at L2, and the cap is announced — the run says it skips L3 and
    who holds the working folder — so a missing tier is never silent (ADR-AUTO-CONSOLE:10).
.PARAMETER Slot
    The slot Enter-TestRunSlot returned.
.PARAMETER Requested
    The highest tier the caller asks for. Default 3: every tier the slot allows.
.PARAMETER MinLevel
    The lowest tier the caller asks for. A run that asks only for tiers the slot skips (L3 in a snapshot) has
    nothing to run, so it throws, naming why.
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

    if ($Slot.Mode -ne 'Snapshot' -or $Requested -lt 3) {
        return $Requested
    }
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
    2
}
