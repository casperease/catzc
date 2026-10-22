<#
---
catzc:
  immutable:
    with_body_sha: "8273b52085cd"
---
#>

<#
.SYNOPSIS
    Defines Wait-CatzcRunLock, the one way a run or a burst takes the machine's run lock: in turn, and for as long as a burst lasts.

.DESCRIPTION
    Dot-sourced by Invoke-CatzcCommand.ps1 and Enter-CatzcBurst.ps1; it imports nothing. A waiter takes a ticket in the lock's queue
    folder and tries the named mutex only while its ticket is the oldest live one, so waiters are served in the order they came. It waits
    up to -LockSeconds; while a burst holds the lock (Enter-CatzcBurst's event exists) the wait lasts as long as the burst, and the waiter
    still has -LockSeconds once it ends. It writes its waiting lines to the pipeline as they happen, and sets -Lock to the owned mutex, or
    writes a "run lock busy" line and leaves -Lock null when the wait ran out.

    . (Join-Path $PSScriptRoot 'Wait-CatzcRunLock.ps1')
    $lock = [ref] $null
    Wait-CatzcRunLock -LockName 'Local\catzc-run' -LockSeconds 120 -Caller 'Invoke-CatzcCommand' -Busy 'nothing ran' -Lock $lock
#>

function Wait-CatzcRunLock {
    param(
        [Parameter(Mandatory)]
        [string] $LockName,

        [Parameter(Mandatory)]
        [int] $LockSeconds,

        [Parameter(Mandatory)]
        [string] $Caller,

        [Parameter(Mandatory)]
        [string] $Busy,

        [Parameter(Mandatory)]
        [ref] $Lock
    )

    $mutex = [System.Threading.Mutex]::new($false, $LockName)
    $queue = Join-Path ([System.IO.Path]::GetTempPath()) "catzc-run-queue/$($LockName -replace '[\\/:*?"<>|]', '_')"
    # A ticket sorts by its arrival; its process id lets a later waiter drop the ticket of a run that was killed.
    $ticket = Join-Path $queue ('{0:D20}-{1}-{2}.ticket' -f [datetime]::UtcNow.Ticks, $PID, [guid]::NewGuid().ToString('N'))
    foreach ($attempt in 1..3) {
        try {
            [System.IO.Directory]::CreateDirectory($queue) | Out-Null
            [System.IO.File]::WriteAllText($ticket, '')
            break
        }
        catch [System.IO.DirectoryNotFoundException] {
            Write-Verbose "Wait-CatzcRunLock: the last waiter out removed $queue between the two calls; making it again (attempt $attempt)."
        }
    }

    $deadline = [datetime]::UtcNow.AddSeconds($LockSeconds)
    $owned = $false
    $saidWaiting = $false
    $saidBurst = $false
    try {
        while ($true) {
            if (Test-CatzcRunLockTurn -Queue $queue -Ticket $ticket) {
                # The first try does not wait, so a free lock is taken without a waiting line.
                $tryMilliseconds = if ($saidWaiting) {
                    250
                }
                else {
                    0
                }
                try {
                    $owned = $mutex.WaitOne($tryMilliseconds)
                }
                catch [System.Threading.AbandonedMutexException] {
                    # Its run was killed while it held the lock: the lock is taken over.
                    $owned = $true
                }
                if ($owned) {
                    break
                }
            }
            else {
                Start-Sleep -Milliseconds 250
            }
            if (-not $saidWaiting) {
                "[$Caller] waiting for the run lock: another run holds it (up to $LockSeconds s)"
                $saidWaiting = $true
            }
            $burst = $null
            if ([System.Threading.EventWaitHandle]::TryOpenExisting("$LockName-burst", [ref] $burst)) {
                $burst.Dispose()
                if (-not $saidBurst) {
                    "[$Caller] a burst holds the run lock: waiting until it ends, then up to $LockSeconds s"
                    $saidBurst = $true
                }
                $deadline = [datetime]::UtcNow.AddSeconds($LockSeconds)
            }
            elseif ([datetime]::UtcNow -ge $deadline) {
                break
            }
        }
    }
    finally {
        [System.IO.File]::Delete($ticket)
        try {
            # The last waiter out removes the empty queue folder; one with tickets left stays.
            [System.IO.Directory]::Delete($queue)
        }
        catch [System.IO.IOException] {
            Write-Verbose "Wait-CatzcRunLock: $queue still holds tickets, so it stays."
        }
    }

    if ($owned) {
        $Lock.Value = $mutex
    }
    else {
        $mutex.Dispose()
        "[$Caller] run lock busy: another run held it for $LockSeconds s, so $Busy"
    }
}

function Test-CatzcRunLockTurn {
    param(
        [Parameter(Mandatory)]
        [string] $Queue,

        [Parameter(Mandatory)]
        [string] $Ticket
    )

    # The oldest live ticket has the turn; a ticket whose process is gone, or older than the longest run (12 min), is dropped.
    $stale = [datetime]::UtcNow.AddMinutes(-12).Ticks
    foreach ($path in @([System.IO.Directory]::GetFiles($Queue, '*.ticket') | Sort-Object)) {
        if ($path -ceq $Ticket) {
            return $true
        }
        $parts = [System.IO.Path]::GetFileNameWithoutExtension($path) -split '-'
        $alive = [long] $parts[0] -gt $stale -and $null -ne (Get-Process -Id ([int] $parts[1]) -ErrorAction Ignore)
        if ($alive) {
            return $false
        }
        try {
            [System.IO.File]::Delete($path)
        }
        catch [System.IO.IOException] {
            Write-Verbose "Wait-CatzcRunLock: another waiter dropped $path first."
        }
    }
    $true
}
