<#
.SYNOPSIS
    Tests whether the current session runs inside WSL (Windows Subsystem for Linux).
.DESCRIPTION
    A WSL distribution sets WSL_DISTRO_NAME, and a WSL kernel identifies itself in /proc/version
    ("microsoft"). Either signal means the Linux session is backed by a Windows host, so
    Windows-side tools are reachable under /mnt/c. Never true outside Linux.
.OUTPUTS
    [bool]
#>
function Test-IsWslSession {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if (-not $IsLinux) {
        return $false
    }
    if ($env:WSL_DISTRO_NAME) {
        return $true
    }
    (Test-Path '/proc/version') -and ((Get-Content '/proc/version' -Raw) -match 'microsoft')
}
