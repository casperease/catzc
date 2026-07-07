<#
.SYNOPSIS
    Returns the current time binding: 'build-time', 'runtime', or 'test-time' (ADR-TIMEBIND).
.DESCRIPTION
    The single reader of the current time binding (ADR-TIMEBIND:4) — when the running code executes:
      test-time  — inside a Pester run ("runtime for test", Test-IsTestTime)
      build-time — producing artifacts (Test-IsBuildTime, entered by the build entry points)
      runtime    — the default: running live ("runtime for live")
    test-time wins over build-time (a build step exercised by a test is being verified, not shipping), and
    both win over runtime. Read the binding here, never by sniffing the underlying signals; branch on it only
    at a genuine seam (ADR-TIMEBIND:3), so runtime and test-time deviate by exactly that seam and no more.
.EXAMPLE
    Get-TimeBinding   # -> 'runtime'
.EXAMPLE
    switch (Get-TimeBinding) { 'test-time' { ... } default { ... } }
#>
function Get-TimeBinding {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (Test-IsTestTime) { return 'test-time' }
    if (Test-IsBuildTime) { return 'build-time' }
    'runtime'
}
