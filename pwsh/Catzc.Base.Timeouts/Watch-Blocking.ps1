function Watch-Blocking {
    [CmdletBinding()]
    param(
        [ValidateRange(0, 3600)]
        [int] $Seconds = (Get-Config -Config timeouts).wait['seconds'],

        [ValidateRange(0, 3600000)]
        [int] $Milliseconds = (Get-Config -Config timeouts).wait['milliseconds']
    )

    $totalMs = $Seconds * 1000 + $Milliseconds
    Assert-True ($totalMs -gt 0) -ErrorText 'Watch-Blocking: Seconds and Milliseconds add up to zero; stand for at least 1 ms.'

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
        $remainingMs = $dueMs - [long]$watch.ElapsedMilliseconds
        if ($remainingMs -gt 0) {
            Start-Sleep -Milliseconds $remainingMs
        }
        $actualMs = [long]$watch.ElapsedMilliseconds
        $lateMs = [math]::Max(0, $actualMs - $dueMs)
        $worstLateMs = [math]::Max($worstLateMs, $lateMs)
        Write-Message "tick $tick/${tickCount}: due +$dueMs ms, at +$actualMs ms (late $lateMs ms)"
    }

    $measuredText = ($watch.Elapsed.TotalSeconds).ToString('0.000', $format)
    Write-Message -Warning "waited $totalText s asked, $measuredText s measured, worst tick late $worstLateMs ms — remove this watchpoint once the block is bounded"
}
