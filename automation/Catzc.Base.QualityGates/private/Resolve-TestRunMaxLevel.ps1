<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Resolve-TestRunMaxLevel.Tests.ps1
    adrs:
      - ADR-AUTO-CONSOLE#10
      - ADR-AUTO-TEST#33
      - ADR-AUTO-TEST#41
  config:
    synopsis: Resolves the highest tier a test run executes, from the location it runs in.
    description: |-
      L3 holds the vertical system tests: they change or depend on state outside the repository — the cloud, the
      user's environment, installed tools
      ([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)). A snapshot isolates a run from
      the working folder,
      never from that outside state, so only the run that owns the working folder (the in-place location) runs L3 —
      and since that state belongs to the user, not to one checkout, only while it also holds the user's
      system-test lock (Enter-SystemTestLock). Two concurrent runs — from one checkout or from two — never both
      execute system tests against the same user's state, and nobody waits.

      In place with the system-test lock, the requested level stands (both runs ask for 3 unless the caller bound
      a lower -MaxLevel). Otherwise — in a snapshot, or in place while another run on this account holds the
      system-test lock — a request that reaches L3 is capped at L2, and the cap is announced: the run says it
      skips L3 and who holds the working folder or the lock, so a missing tier is never silent
      ([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
      L4, the opt-in tier that tests the released system after final approval
      ([ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)), runs only when asked for, and
      where L3 runs: a run capped at L2 skips L4 too, and says so.
    parameters:
      Location: The location Enter-TestRunLocation returned.
      Requested: |-
        The highest tier the caller asks for. Default 3 (TestTiers.DefaultTop): every tier the location allows, L4
        excluded; 4 includes L4.
      MinLevel: |-
        The lowest tier the caller asks for. A run that asks only for tiers its location skips (L3 in a snapshot, or
        without the system-test lock) has nothing to run, so it throws, naming why.
    outputs: '[int] the highest tier to run.'
    examples:
      - '$maxLevel = Resolve-TestRunMaxLevel -Location $location'
---
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
