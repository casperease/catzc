<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Execution/Wait-Mutex.ps1
    name: wait-mutex
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Execution
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-execution/Wait-Mutex.ps1.md
    test: automation/Catzc.Base.Execution/tests/Wait-Mutex.Tests.ps1
    cites:
      - ADR-AUTO-CONSOLE#{8,10}
      - ADR-PWSH-ANNOUNCE#1
---
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
