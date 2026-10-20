function Wait-DocNote {
    <#
    .SYNOPSIS
        Waits until a session holds a note the processor has not processed, and returns those notes; returns nothing when the bound runs out.

    .DESCRIPTION
        The processor's wait, bounded under the background roof of the time safeguard
        ([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)). It
        returns at once when unprocessed notes already exist, so a processor that starts late catches up on the backlog first.

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER TimeoutSeconds
        The bound of this wait. Default: listen.yml's note_wait_seconds.

    .OUTPUTS
        [pscustomobject] per unprocessed note (Get-DocNote's records), or nothing.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [ValidateRange(1, 3600)]
        [int] $TimeoutSeconds = (Get-Config -Config listen).note_wait_seconds
    )

    $Session = Resolve-ListenSession $Session
    $poll = (Get-Config -Config listen).poll_milliseconds
    $deadline = [System.Diagnostics.Stopwatch]::StartNew()
    while ($true) {
        $notes = @(Get-DocNote -Session $Session -Unprocessed)
        if ($notes.Count -gt 0) {
            return $notes
        }
        if ($deadline.Elapsed.TotalSeconds -ge $TimeoutSeconds) {
            return
        }
        Start-Sleep -Milliseconds $poll
    }
}
