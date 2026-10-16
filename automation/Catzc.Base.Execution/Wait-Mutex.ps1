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
  config:
    synopsis: Awaits a mutex reliably, announcing itself only when the wait is actually noticeable.
    description: |-
      The one low-level cover for blocking on a [System.Threading.Mutex]. It scales its console
      presence to how long the wait actually takes:

      - Acquired within -AnnounceAfterSeconds (default 2): a non-noticeable glitch — the only trace is
        a verbose breadcrumb ('Awaited the <name> in N ms'), visible under -Verbose and silent otherwise.
      - Still waiting past that threshold: a genuine halt — one announcement line names what is being
        waited on
        ([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)), then a
        liveness dot every -DotIntervalSeconds (default 5) until the
        mutex is acquired (the dot-per-interval signal of
        [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)), followed
        by an acquisition
        outcome line.

      An abandoned mutex — the previous holder's process or thread died while owning it — transfers
      ownership and is treated as acquired, not as an error (a verbose breadcrumb records the transfer).
      On return the caller owns the mutex and MUST release and dispose it in a finally block.

      Dots are written through the writer chokepoint (Write-Message '.' -NoHeader -NoNewline,
      [ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): an inline
      information-stream record, so nothing pollutes the pipeline and a
      Pester run silences them with every other message.
    parameters:
      Mutex: The mutex to await. On return the current thread owns it.
      Name: Short noun for the messages (e.g. 'test-run mutex'). Defaults to 'mutex'.
      AnnounceText: |-
        The announcement written when the wait crosses -AnnounceAfterSeconds. Defaults to
        'Waiting for the <Name> — another process holds it'.
      AnnounceAfterSeconds: How long a wait may take before it is announced (and dots begin). Defaults to 2.
      DotIntervalSeconds: Seconds between liveness dots once the wait is announced. Defaults to 5.
      TimeoutSeconds: |-
        Optional hard ceiling on the whole wait; the function throws when it expires. Defaults to 0 —
        wait indefinitely.
    outputs: None. Ownership is expressed on the mutex object itself.
    examples:
      - |-
        $mutex = [System.Threading.Mutex]::new($false, "Global\my-app-lock")
        Wait-Mutex $mutex -Name 'app lock'
        try {
            # ... exclusive work ...
        }
        finally {
            $mutex.ReleaseMutex()
            $mutex.Dispose()
        }
      - 'Wait-Mutex $mutex -Name ''deploy mutex'' -TimeoutSeconds 300   # throw rather than wait past 5 minutes'
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
