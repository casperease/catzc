<#
.SYNOPSIS
    Returns true when the current session is executing inside a Pester test run (the test-time binding).
.DESCRIPTION
    Test-time is "runtime for test" (ADR-TIMEBIND:1): the code runs for real, exercised by the suite. It is
    detected by Pester's own module being on the call stack — the code under test always executes within
    Invoke-Pester's frames. This is the ONE sanctioned place that reads that signal (ADR-TIMEBIND:4), so how
    a test run is recognised stays an implementation detail; read the binding through Get-TimeBinding, and
    only at a genuine seam (ADR-TIMEBIND:3).
.EXAMPLE
    Test-IsTestTime
#>
function Test-IsTestTime {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    foreach ($frame in Get-PSCallStack) {
        if ($frame.ScriptName -and $frame.ScriptName -match '[\\/]Pester\.psm1$') {
            return $true
        }
    }
    $false
}
