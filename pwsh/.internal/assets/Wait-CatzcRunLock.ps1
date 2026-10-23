<#
.SYNOPSIS
    Defines Wait-CatzcRunLock, the one way a run or a burst takes the machine's run lock: in turn, for as long as a burst lasts, and for as
    long as a live holder is inside its own deadline.

.DESCRIPTION
    Dot-sourced by Invoke-CatzcCommand.ps1 and Enter-CatzcBurst.ps1; it imports nothing. A waiter takes a ticket in the lock's queue
    folder and tries the named mutex only while its ticket is the oldest live one, so waiters are served in the order they came. It waits
    up to -LockSeconds; while a burst holds the lock (Enter-CatzcBurst's event exists), or while the holder record names a live process
    whose deadline has not passed, the wait lasts as long as the hold, and the waiter still has -LockSeconds once it ends. A live
    holder is waited for until the waiter's -BudgetSeconds leaves only its own -LockSeconds, whatever deadline the holder declares; then
    the waiter stops and says when to retry. It writes its waiting
    lines to the pipeline as they happen, and sets -Lock to the owned mutex, or writes a "run lock busy" line and leaves -Lock null.
    The holder record sits beside the queue folder: the holding process's id and start time, its deadline and what it runs. The waiter
    that takes the lock writes it, Set-CatzcRunLockHolder moves its deadline once the run knows its commands' limits, and
    Remove-CatzcRunLockHolder deletes it before the lock is let go. The wait, the stale-ticket age and the budget are the run_lock entry
    of timeouts.yml (Get-CatzcRunLockSetting), read here without an import.

    . (Join-Path $PSScriptRoot 'Wait-CatzcRunLock.ps1')
    $settings = Get-CatzcRunLockSetting
    $lock = [ref] $null
    Wait-CatzcRunLock -LockName 'Local\catzc-run' -LockSeconds $settings.wait_seconds -BudgetSeconds $settings.budget_seconds `
        -StaleSeconds $settings.stale_seconds -Holding 'Get-Widget' -Caller 'Invoke-CatzcCommand' -Busy 'nothing ran' -Lock $lock
#>

function Get-CatzcRunLockSetting {
    param(
        [string] $Path = (Join-Path $PSScriptRoot '../../Catzc.Base.Timeouts/configs/timeouts.yml')
    )

    # The run lock is taken before any import, so the entry is read as text; the defaults live on TimeoutsConfig and the shipped file shows
    # them, so a missing key is an error here, never a second default.
    if (-not [System.IO.File]::Exists($Path)) {
        throw "Get-CatzcRunLockSetting: $Path is missing, so the run lock has no wait, stale age or budget."
    }
    $settings = @{}
    $inside = $false
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        if ($line -match '^run_lock:\s*(#.*)?$') {
            $inside = $true
            continue
        }
        if ($inside -and $line -match '^\S') {
            break
        }
        if ($inside -and $line -match '^\s+(?<key>[a-z_]+):\s*(?<value>\d+)\s*(#.*)?$') {
            $settings[$Matches['key']] = [int] $Matches['value']
        }
    }
    foreach ($key in 'wait_seconds', 'stale_seconds', 'budget_seconds') {
        if (-not $settings.ContainsKey($key)) {
            throw "Get-CatzcRunLockSetting: $Path declares no run_lock.$key, which the run lock reads before any import."
        }
    }
    [pscustomobject] $settings
}

function Get-CatzcRunLockHolderPath {
    param(
        [Parameter(Mandatory)]
        [string] $LockName
    )

    Join-Path ([System.IO.Path]::GetTempPath()) "catzc-run-queue/$($LockName -replace '[\\/:*?"<>|]', '_').holder"
}

function Set-CatzcRunLockHolder {
    param(
        [Parameter(Mandatory)]
        [string] $LockName,

        [Parameter(Mandatory)]
        [int] $Seconds,

        [Parameter(Mandatory)]
        [string] $Holding
    )

    # One line: the process id and start time, so a reused id is never taken for the holder, the deadline (the budget when the lock is
    # taken, then the run's own limits summed, or a burst's length), and what it runs.
    $path = Get-CatzcRunLockHolderPath -LockName $LockName
    $started = (Get-Process -Id $PID).StartTime.ToUniversalTime().Ticks
    $deadline = [datetime]::UtcNow.AddSeconds($Seconds).Ticks
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($path)) | Out-Null
    [System.IO.File]::WriteAllText($path, "$PID|$started|$deadline|$($Holding -replace '[\r\n|]', ' ')")
}

function Test-CatzcRunLockHolderGone {
    param(
        [Parameter(Mandatory)]
        [string] $LockName
    )

    # A record that names no live holder within its deadline: its process died, its id was reused, or it outlasted what it declared.
    [System.IO.File]::Exists((Get-CatzcRunLockHolderPath -LockName $LockName)) -and $null -eq (Get-CatzcRunLockHolder -LockName $LockName)
}

function Remove-CatzcRunLockHolder {
    param(
        [Parameter(Mandatory)]
        [string] $LockName
    )

    $path = Get-CatzcRunLockHolderPath -LockName $LockName
    try {
        [System.IO.File]::Delete($path)
    }
    catch [System.IO.IOException] {
        Write-Verbose "Remove-CatzcRunLockHolder: $path is in use; the next holder overwrites it."
    }
}

function Format-CatzcRunLockTime {
    param(
        [Parameter(Mandatory)]
        [datetime] $Time
    )

    # The local clock time a reader compares with their own, in one form on every machine whatever its culture.
    $Time.ToLocalTime().ToString('HH:mm:ss', [System.Globalization.CultureInfo]::InvariantCulture)
}

function Get-CatzcRunLockHolder {
    param(
        [Parameter(Mandatory)]
        [string] $LockName
    )

    # The holder counts only while its process lives with the same start time and its deadline has not passed.
    $path = Get-CatzcRunLockHolderPath -LockName $LockName
    $text = $null
    try {
        $text = [System.IO.File]::ReadAllText($path)
    }
    catch [System.IO.IOException] {
        return $null
    }
    catch [System.UnauthorizedAccessException] {
        return $null
    }
    $parts = $text -split '\|', 4
    if ($parts.Count -lt 4) {
        return $null
    }
    $process = Get-Process -Id ([int] $parts[0]) -ErrorAction Ignore
    if ($null -eq $process -or $process.StartTime.ToUniversalTime().Ticks -ne [long] $parts[1]) {
        return $null
    }
    $deadline = [datetime]::new([long] $parts[2], [System.DateTimeKind]::Utc)
    if ($deadline -le [datetime]::UtcNow) {
        return $null
    }
    [pscustomobject]@{ ProcessId = [int] $parts[0]; Deadline = $deadline; Holding = $parts[3] }
}

function Wait-CatzcRunLock {
    param(
        [Parameter(Mandatory)]
        [string] $LockName,

        [Parameter(Mandatory)]
        [int] $LockSeconds,

        [Parameter(Mandatory)]
        [int] $BudgetSeconds,

        [Parameter(Mandatory)]
        [int] $StaleSeconds,

        [Parameter(Mandatory)]
        [string] $Holding,

        [int] $HoldSeconds,

        [Parameter(Mandatory)]
        [string] $Caller,

        [Parameter(Mandatory)]
        [string] $Busy,

        [Parameter(Mandatory)]
        [ref] $Lock,

        [int] $ParentId = ((Get-Process -Id $PID).Parent)?.Id ?? 0
    )

    # The caller this wait serves: a waiter whose caller has gone (its call killed by a timeout or stopped) never takes the lock, so no
    # orphaned run holds it for no one. The start time pins the process, so a reused id never passes for it.
    $parentStart = 0L
    if ($ParentId -gt 0) {
        $parentProcess = Get-Process -Id $ParentId -ErrorAction Ignore
        if ($parentProcess) {
            $parentStart = $parentProcess.StartTime.ToUniversalTime().Ticks
        }
    }
    $callerGone = {
        if ($ParentId -le 0) {
            return $false
        }
        $process = Get-Process -Id $ParentId -ErrorAction Ignore
        $null -eq $process -or $process.HasExited -or $process.StartTime.ToUniversalTime().Ticks -ne $parentStart
    }

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

    $started = [datetime]::UtcNow
    $deadline = $started.AddSeconds($LockSeconds)
    $owned = $false
    $overBudget = $null
    $burstOverBudget = $false
    $saidWaiting = $false
    $saidBurst = $false
    $saidGoneBurst = $false
    $saidHolder = $false
    $orphaned = $false
    try {
        while ($true) {
            if (& $callerGone) {
                $orphaned = $true
                break
            }
            if (Test-CatzcRunLockTurn -Queue $queue -Ticket $ticket -StaleSeconds $StaleSeconds) {
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
            $burstOpen = [System.Threading.EventWaitHandle]::TryOpenExisting("$LockName-burst", [ref] $burst)
            if ($burstOpen) {
                $burst.Dispose()
            }
            # A burst whose holder died or ran past its declared length holds no one: the waiter falls back to its own wait.
            if ($burstOpen -and (Test-CatzcRunLockHolderGone -LockName $LockName)) {
                if (-not $saidGoneBurst) {
                    "[$Caller] a burst's holder is gone or past its declared length: not waiting for it, up to $LockSeconds s"
                    $saidGoneBurst = $true
                }
                $burstOpen = $false
            }
            if ($burstOpen) {
                if (-not $saidBurst) {
                    "[$Caller] a burst holds the run lock: waiting until it ends, then up to $LockSeconds s"
                    $saidBurst = $true
                }
                # A burst that hangs past this run's whole budget is waited for no longer: the budget is the ceiling of every wait.
                if ([datetime]::UtcNow -ge $started.AddSeconds($BudgetSeconds)) {
                    $burstOverBudget = $true
                    break
                }
                $deadline = [datetime]::UtcNow.AddSeconds($LockSeconds)
                continue
            }
            $holder = Get-CatzcRunLockHolder -LockName $LockName
            if ($holder) {
                # A deadline is the most a holder may take, never when it ends, so a live holder is waited for while this run's budget
                # still leaves room for its own work; only then does the run say when to come back.
                if ([datetime]::UtcNow -ge $started.AddSeconds($BudgetSeconds - $LockSeconds)) {
                    $overBudget = $holder
                    break
                }
                if (-not $saidHolder) {
                    "[$Caller] $($holder.Holding) (pid $($holder.ProcessId)) holds the run lock until $(Format-CatzcRunLockTime $holder.Deadline): waiting for it, then up to $LockSeconds s"
                    $saidHolder = $true
                }
                $deadline = [datetime]::UtcNow.AddSeconds($LockSeconds)
                continue
            }
            if ([datetime]::UtcNow -ge $deadline) {
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
        $hold = if ($HoldSeconds -gt 0) {
            $HoldSeconds
        }
        else {
            $BudgetSeconds
        }
        # A hold length the caller gives (a burst's) is its deadline; otherwise the budget, the most the run may take.
        Set-CatzcRunLockHolder -LockName $LockName -Seconds $hold -Holding $Holding
        $Lock.Value = $mutex
        return
    }
    $mutex.Dispose()
    if ($orphaned) {
        "[$Caller] run lock not taken: the caller that started this run (pid $ParentId) is gone, so $Busy"
        return
    }
    if ($burstOverBudget) {
        "[$Caller] run lock busy: a burst held it past this run's budget of $BudgetSeconds s, so $Busy; retry after it"
        return
    }
    if ($overBudget) {
        "[$Caller] run lock busy: $($overBudget.Holding) (pid $($overBudget.ProcessId)) holds it until $(Format-CatzcRunLockTime $overBudget.Deadline), past this run's budget of $BudgetSeconds s, so $Busy; retry after it"
        return
    }
    "[$Caller] run lock busy: another run held it for $LockSeconds s, so $Busy"
}

function Test-CatzcRunLockTurn {
    param(
        [Parameter(Mandatory)]
        [string] $Queue,

        [Parameter(Mandatory)]
        [string] $Ticket,

        [Parameter(Mandatory)]
        [int] $StaleSeconds
    )

    # The oldest live ticket has the turn; a ticket whose process is gone, or older than the longest run (run_lock.stale_seconds), is dropped.
    $stale = [datetime]::UtcNow.AddSeconds(-$StaleSeconds).Ticks
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
