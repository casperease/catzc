<#
.SYNOPSIS
    Returns true when the current session is in the build-time binding (producing artifacts).
.DESCRIPTION
    Build-time is when code produces artifacts rather than serving them (ADR-TIMEBIND:1): compiling the C#
    types, rendering templates, generating manifests/markers. Unlike test-time it is not sniffed from the
    call stack — it is entered EXPLICITLY by the build entry points, which set $env:CATZC_BUILD_TIME for the
    scope of the build pass. This is the ONE sanctioned reader of that flag (ADR-TIMEBIND:4); read the binding
    through Get-TimeBinding. Absent the flag, the session is not build-time.
.EXAMPLE
    Test-IsBuildTime
#>
function Test-IsBuildTime {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:CATZC_BUILD_TIME
}
