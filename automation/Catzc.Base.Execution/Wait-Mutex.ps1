<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Execution/Wait-Mutex.ps1
    kind: public-function
    module: Catzc.Base.Execution
    visibility: public
    adrs:
      - ADR-AUTO-CONSOLE#10
      - ADR-AUTO-CONSOLE#8
      - ADR-PWSH-ANNOUNCE#1
---
#>

<#
.SYNOPSIS
    Awaits a mutex reliably, announcing itself only when the wait is actually noticeable.
.DESCRIPTION
    A short wait leaves only a verbose trace; the console speaks up only once the wait is a real halt.
.PARAMETER Mutex
    The mutex to await. On return the current thread owns it.
.PARAMETER Name
    Short noun for the messages (e.g. 'test-run mutex'). Defaults to 'mutex'.
.PARAMETER AnnounceText
    The default names the mutex, so pass -Name rather than rewriting this text.
.PARAMETER AnnounceAfterSeconds
    How long a wait may take before it is announced (and dots begin). Defaults to 2.
.PARAMETER DotIntervalSeconds
    Seconds between liveness dots once the wait is announced. Defaults to 5.
.PARAMETER TimeoutSeconds
    The default 0 waits forever, so a stuck holder hangs the caller unless a ceiling is set.
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
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.Threading.Mutex] $Mutex,

        [string] $Name = 'mutex',

        [string] $AnnounceText = "Waiting for the $Name — another process holds it",

        [ValidateRange(0, 3600)]
        [double] $AnnounceAfterSeconds = 2,

        [ValidateRange(0.01, 3600)]
        [double] $DotIntervalSeconds = 5,

        [ValidateRange(0, 86400)]
        [int] $TimeoutSeconds = 0
    )

    $emitVerbose = $VerbosePreference -eq 'Continue'

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $announced = $false
    $dotsWritten = $false

    while ($true) {
        # A failed slice is exactly one console event, the announcement or one dot, so the wait stays observable.
        # [comment:4](/docs/references/automation/catzc-base-execution/Wait-Mutex.ps1.md#comment4)
        $waitSeconds = if ($announced) {
            $DotIntervalSeconds
        }
        else {
            [Math]::Max(0, $AnnounceAfterSeconds - $stopwatch.Elapsed.TotalSeconds)
        }
        if ($TimeoutSeconds -gt 0) {
            $remainingSeconds = $TimeoutSeconds - $stopwatch.Elapsed.TotalSeconds
            if ($remainingSeconds -le 0) {
                if ($dotsWritten) {
                    Write-Message '' -NoHeader
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
        else {
            Write-Message '.' -NoHeader -NoNewline
            $dotsWritten = $true
        }
    }

    $stopwatch.Stop()
    if ($dotsWritten) {
        Write-Message '' -NoHeader
    }
    if ($announced) {
        Write-Message ('Acquired the {0} after {1:0.#} second(s).' -f $Name, $stopwatch.Elapsed.TotalSeconds)
    }
    else {
        Write-Message ('Awaited the {0} in {1} ms.' -f $Name, [int]$stopwatch.Elapsed.TotalMilliseconds) -Verbose:$emitVerbose
    }
}
