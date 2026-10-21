<#
---
catzc:
  immutable:
    with_body_sha: c2bab1e43f69
  edges:
    test: pwsh/Catzc.Tooling.Listen/tests/Wait-DocNote.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---
#>

function Wait-DocNote {
    <#
    .SYNOPSIS
        Waits until a session holds a note the processor has not processed, and returns those notes; returns nothing when the bound runs out.

    .DESCRIPTION
        The processor's wait, bounded under the background roof of the time safeguard
        ([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)). It
        returns at once when unprocessed notes already exist, so a processor that starts late catches up on the backlog first.

        The session lives in out/, which can be wiped at any time: with no session yet, or once the session has vanished, it keeps
        waiting, and without -Session it follows the newest session, so a listener that starts after the processor, or starts again after
        a wipe, is picked up.

    .PARAMETER Session
        The session folder. Default: the newest session, looked up again on every poll.

    .PARAMETER TimeoutSeconds
        The bound of this wait. Default: listen.yml's note_wait_seconds.

    .PARAMETER Source
        Wait only for notes from these writers (Get-DocNote -Source); the processor waits for editor.

    .OUTPUTS
        [pscustomobject] per unprocessed note (Get-DocNote's records), or nothing.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [ValidateRange(1, 3600)]
        [int] $TimeoutSeconds = (Get-Config -Config listen).note_wait_seconds,

        [ValidateSet('editor', 'agent', 'unknown')]
        [string[]] $Source
    )

    $poll = (Get-Config -Config listen).poll_milliseconds
    $deadline = [System.Diagnostics.Stopwatch]::StartNew()
    while ($true) {
        $current = Resolve-ListenSession $Session -AllowMissing
        if ($current) {
            # The session can vanish between the lookup and the read; that is the same as no session yet.
            [object[]] $notes = @()
            try {
                $filter = @{}
                if ($Source) {
                    $filter['Source'] = $Source
                }
                $notes = @(Get-DocNote -Session $current -Unprocessed @filter)
            }
            catch {
                if (Resolve-ListenSession $current -AllowMissing) {
                    throw
                }
            }
            if ($notes.Count -gt 0) {
                return $notes
            }
        }
        if ($deadline.Elapsed.TotalSeconds -ge $TimeoutSeconds) {
            return
        }
        Start-Sleep -Milliseconds $poll
    }
}
