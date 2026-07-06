<#
.SYNOPSIS
    Awaits a mutex reliably, announcing itself only when the wait is actually noticeable.
.DESCRIPTION
    The one low-level cover for blocking on a [System.Threading.Mutex]. It scales its console
    presence to how long the wait actually takes:

    - Acquired within -AnnounceAfterSeconds (default 2): a non-noticeable glitch — the only trace is
      a verbose breadcrumb ('Awaited the <name> in N ms'), visible under -Verbose and silent otherwise.
    - Still waiting past that threshold: a genuine halt — one announcement line names what is being
      waited on (ADR-CONSOLE:10), then a liveness dot every -DotIntervalSeconds (default 5) until the
      mutex is acquired (the dot-per-interval signal of ADR-CONSOLE:8), followed by an acquisition
      outcome line.

    An abandoned mutex — the previous holder's process or thread died while owning it — transfers
    ownership and is treated as acquired, not as an error (a verbose breadcrumb records the transfer).
    On return the caller owns the mutex and MUST release and dispose it in a finally block.

    Dots are written via [Console]::Write (bypassing the PowerShell streams, so nothing pollutes the
    pipeline) and are suppressed during a Pester run by the same $global:__PesterRunning flag that
    silences the writers.
.PARAMETER Mutex
    The mutex to await. On return the current thread owns it.
.PARAMETER Name
    Short noun for the messages (e.g. 'test-run mutex'). Defaults to 'mutex'.
.PARAMETER AnnounceText
    The announcement written when the wait crosses -AnnounceAfterSeconds. Defaults to
    'Waiting for the <Name> — another process holds it'.
.PARAMETER AnnounceAfterSeconds
    How long a wait may take before it is announced (and dots begin). Defaults to 2.
.PARAMETER DotIntervalSeconds
    Seconds between liveness dots once the wait is announced. Defaults to 5.
.PARAMETER TimeoutSeconds
    Optional hard ceiling on the whole wait; the function throws when it expires. Defaults to 0 —
    wait indefinitely.
.OUTPUTS
    None. Ownership is expressed on the mutex object itself.
.EXAMPLE
    $mutex = [System.Threading.Mutex]::new($false, "Global\my-app-lock")
    Wait-Mutex $mutex -Name 'app lock'
    try {
        # ... exclusive work ...
    }
    finally {
        $mutex.ReleaseMutex()
        $mutex.Dispose()
    }
.EXAMPLE
    Wait-Mutex $mutex -Name 'deploy mutex' -TimeoutSeconds 300   # throw rather than wait past 5 minutes
#>
function Wait-Mutex {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) is read to suppress the raw [Console] liveness dots during test runs — they bypass the writer chokepoint that silences everything else; global is required to cross module session-state boundaries')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Liveness dots are written via [Console]::Write specifically to bypass PowerShell output streams — the information stream cannot emit an inline (no-newline) dot, and nothing may pollute the pipeline; see .DESCRIPTION and ADR-CONSOLE:8')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.Threading.Mutex] $Mutex,

        [string] $Name = 'mutex',

        [string] $AnnounceText,

        [ValidateRange(0, 3600)]
        [double] $AnnounceAfterSeconds = 2,

        [ValidateRange(0.01, 3600)]
        [double] $DotIntervalSeconds = 5,

        [ValidateRange(0, 86400)]
        [double] $TimeoutSeconds = 0
    )

    if (-not $AnnounceText) {
        $AnnounceText = "Waiting for the $Name — another process holds it"
    }
    $emitVerbose = $VerbosePreference -eq 'Continue'

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $announced = $false
    $dotsWritten = $false

    while ($true) {
        # Wait in observation-sized slices: up to the announce threshold first, then one dot interval
        # per slice — a failed slice is exactly one console event (the announcement, or a dot).
        $waitSeconds = if ($announced) {
            $DotIntervalSeconds
        }
        else {
            [Math]::Max(0, $AnnounceAfterSeconds - $stopwatch.Elapsed.TotalSeconds)
        }
        if ($TimeoutSeconds -gt 0) {
            $remainingSeconds = $TimeoutSeconds - $stopwatch.Elapsed.TotalSeconds
            if ($remainingSeconds -le 0) {
                if ($dotsWritten -and -not $global:__PesterRunning) {
                    [Console]::WriteLine()
                }
                throw "Timed out waiting for the $Name after $TimeoutSeconds second(s)."
            }
            $waitSeconds = [Math]::Min($waitSeconds, $remainingSeconds)
        }

        $acquired = try {
            $Mutex.WaitOne([TimeSpan]::FromSeconds($waitSeconds))
        }
        catch [System.Threading.AbandonedMutexException] {
            # The previous holder died owning the mutex; the wait handle grants us ownership.
            Write-Message "The previous $Name holder died owning it; ownership transferred." -Verbose:$emitVerbose
            $true
        }
        if ($acquired) {
            break
        }

        if (-not $announced) {
            Write-Message $AnnounceText
            $announced = $true
        }
        elseif (-not $global:__PesterRunning) {
            [Console]::Write('.')
            $dotsWritten = $true
        }
    }

    $stopwatch.Stop()
    if ($dotsWritten -and -not $global:__PesterRunning) {
        [Console]::WriteLine()
    }
    if ($announced) {
        Write-Message ('Acquired the {0} after {1:0.#} second(s).' -f $Name, $stopwatch.Elapsed.TotalSeconds)
    }
    else {
        Write-Message ('Awaited the {0} in {1} ms.' -f $Name, [int]$stopwatch.Elapsed.TotalMilliseconds) -Verbose:$emitVerbose
    }
}
