<#
---
catzc:
  immutable:
    with_body_sha: "73f844b033cf"
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Wait-DocChange.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

function Wait-DocChange {
    <#
    .SYNOPSIS
        Waits until a change of the watched folder has settled, and returns it; returns nothing when the wait's bound runs out.

    .DESCRIPTION
        Polls Get-DocChange every poll_milliseconds. Once a change shows, it waits until the set of changes, diffs included, has stayed the
        same for quiet_seconds, so one burst of saves is one change. The whole wait is bounded by -TimeoutSeconds
        ([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)); the
        listener simply waits again after a bound runs out.

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER TimeoutSeconds
        The bound of this wait. Default: listen.yml's change_wait_seconds.

    .OUTPUTS
        [pscustomobject] per settled change (Get-DocChange's records), or nothing.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [ValidateRange(1, 86400)]
        [int] $TimeoutSeconds = (Get-Config -Config listen).change_wait_seconds
    )

    $Session = Resolve-ListenSession $Session
    $config = Get-Config -Config listen
    $deadline = [System.Diagnostics.Stopwatch]::StartNew()
    $quiet = [System.Diagnostics.Stopwatch]::new()
    $signature = ''
    $changes = @()

    while ($deadline.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
        $changes = @(Get-DocChange -Session $Session)
        $now = @(foreach ($change in $changes) {
                "$($change.Change)|$($change.From)|$($change.Path)|$($change.Diff)"
            }) -join "`n"

        if ($changes.Count -eq 0) {
            $quiet.Reset()
        }
        elseif ($now -cne $signature) {
            $quiet.Restart()
        }
        elseif ($quiet.Elapsed.TotalSeconds -ge $config.quiet_seconds) {
            return $changes
        }
        $signature = $now
        Start-Sleep -Milliseconds $config.poll_milliseconds
    }
}
