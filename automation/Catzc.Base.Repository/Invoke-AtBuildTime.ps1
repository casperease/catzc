<#
.SYNOPSIS
    Runs a script block in the build-time binding — the sanctioned way a producer enters build-time.
.DESCRIPTION
    Build producers (rendering configs, compiling types, generating manifests/markers) run their work inside
    this scope so Get-TimeBinding reports 'build-time' (ADR-TIMEBIND:1) while the artifact is being stitched,
    then reverts. This is the one sanctioned WRITER of the $env:CATZC_BUILD_TIME flag that Test-IsBuildTime
    reads (ADR-TIMEBIND:4) — the NoRawTimeDetection rule is suppressed here for that single deliberate write.
    The prior value is restored in a finally, so a nested or failed build never leaks the binding, and the
    flag nests correctly (an inner build leaves the outer one still build-time).
.PARAMETER ScriptBlock
    The build work to run at build-time.
.EXAMPLE
    Invoke-AtBuildTime { Build-RootConfig }
#>
function Invoke-AtBuildTime {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawTimeDetection', '', Justification = 'The one sanctioned WRITER of the build-time flag Test-IsBuildTime reads — this is how build-time is entered (ADR-TIMEBIND:4).')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [scriptblock] $ScriptBlock
    )

    $previous = $env:CATZC_BUILD_TIME
    $env:CATZC_BUILD_TIME = 'true'
    try {
        & $ScriptBlock
    }
    finally {
        $env:CATZC_BUILD_TIME = $previous
    }
}
