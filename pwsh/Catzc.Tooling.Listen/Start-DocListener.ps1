function Start-DocListener {
    <#
    .SYNOPSIS
        The listener of the listen mode: notes every settled change of the watched folder, until stopped.

    .DESCRIPTION
        Starts a session (New-DocSnapshot), or resumes one, then loops: Wait-DocChange, one New-DocNote per settled change, and
        Update-DocSnapshot to move seen/ forward. It runs no model and interprets nothing, so no note waits on thinking; the processor
        (the listen-very-carefully-to-doc-changes agent) reads the notes on its own time. The editor runs it in a terminal of its own and
        stops it with Ctrl+C; a stopped listener loses nothing, since every note is on disk once written.

    .PARAMETER Session
        Resume this session instead of starting a new one.

    .PARAMETER Cycles
        Stop after this many waits; 0 (default) waits until stopped.
    #>
    [CmdletBinding()]
    param(
        [string] $Session,

        [ValidateRange(0, [int]::MaxValue)]
        [int] $Cycles = 0
    )

    $Session = if ($Session) {
        Resolve-ListenSession $Session
    }
    else {
        (New-DocSnapshot).Path
    }
    Write-Message "Listening to '$((Get-Config -Config listen).watch)' for the session '$Session'; Ctrl+C stops."

    for ($cycle = 1; $Cycles -eq 0 -or $cycle -le $Cycles; $cycle++) {
        foreach ($change in @(Wait-DocChange -Session $Session)) {
            $note = New-DocNote -Session $Session -Change $change
            Update-DocSnapshot -Session $Session -Path @(@($change.Path, $change.From) | Where-Object { $_ })
            Write-Message "Note $($note.Id): $($change.Path) ($($change.Change), $($change.Tier))"
        }
    }
}
