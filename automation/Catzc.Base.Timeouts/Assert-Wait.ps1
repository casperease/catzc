<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Timeouts/Assert-Wait.ps1
    name: assert-wait
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Timeouts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Timeouts/tests/Assert-Wait.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST#{5,7}
  config:
    synopsis: A watchpoint — stands where the thread or process may be blocked, writes loudly, warns once and lets go.
    description: |-
      Holds the calling thread for Seconds + Millisecs in ten evenly spaced ticks and writes a line per tick through
      Write-Message: when the tick was due, when it ran, and how late it was. A blocked thread or a starved process cannot keep
      that schedule, so a late tick is the evidence. It ends with one Write-Message -Warning line (always, blocked or not), then
      returns. It stops nothing and throws nothing for a block; only an invalid argument throws.

      The closing line is Write-Message -Warning, not the Write-Warning cmdlet: the importer sets $WarningPreference = 'Stop',
      so the cmdlet would terminate where this must let go. A watchpoint is a diagnostic — it costs its full duration on every
      run and is removed once the block it found is bounded (Invoke-WithTimeout, a timeouts.yml entry).
    parameters:
      Seconds: Whole seconds to stand. Defaults to 1.
      Millisecs: Milliseconds added to Seconds. Defaults to 1.
    examples:
      - Assert-Wait
      - Assert-Wait -Seconds 2
      - Assert-Wait -Seconds 0 -Millisecs 250
---
#>

function Assert-Wait {
    [CmdletBinding()]
    param(
        [ValidateRange(0, 3600)]
        [int] $Seconds = 1,

        [ValidateRange(0, 3600000)]
        [int] $Millisecs = 1
    )

    $totalMs = $Seconds * 1000 + $Millisecs
    Assert-True ($totalMs -gt 0) -ErrorText 'Assert-Wait: Seconds and Millisecs add up to zero; stand for at least 1 ms.'

    $tickCount = 10
    $tickMs = [int][math]::Round($totalMs / $tickCount)
    $format = [cultureinfo]::InvariantCulture
    $totalText = ($totalMs / 1000).ToString('0.000', $format)

    $frame = (Get-PSCallStack)[1]
    $scriptName = if ($frame.ScriptName) {
        Split-Path $frame.ScriptName -Leaf
    }
    else {
        '<console>'
    }
    Write-Message "standing at $($frame.Command) ($scriptName`:$($frame.ScriptLineNumber)) for $totalText s — watching for a blocked thread or process"

    $watch = [Diagnostics.Stopwatch]::StartNew()
    $dueMs = 0
    $worstLateMs = 0
    for ($tick = 1; $tick -le $tickCount; $tick++) {
        # The last tick takes what rounding left over, so the ticks add up to the total.
        $sleepMs = if ($tick -eq $tickCount) {
            $totalMs - $dueMs
        }
        else {
            $tickMs
        }
        $dueMs += $sleepMs
        Start-Sleep -Milliseconds $sleepMs
        $actualMs = [long]$watch.ElapsedMilliseconds
        $lateMs = [math]::Max(0, $actualMs - $dueMs)
        $worstLateMs = [math]::Max($worstLateMs, $lateMs)
        Write-Message "tick $tick/${tickCount}: due +$dueMs ms, at +$actualMs ms (late $lateMs ms)"
    }

    $measuredText = ($watch.Elapsed.TotalSeconds).ToString('0.000', $format)
    Write-Message -Warning "waited $totalText s asked, $measuredText s measured, worst tick late $worstLateMs ms — remove this watchpoint once the block is bounded"
}
