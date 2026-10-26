function Wait-DocChange {
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
