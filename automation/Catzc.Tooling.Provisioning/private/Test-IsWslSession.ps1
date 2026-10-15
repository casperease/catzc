<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/private/Test-IsWslSession.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether the current session runs inside WSL (Windows Subsystem for Linux).
.DESCRIPTION
    Either signal proves a Windows host behind the Linux session, so Windows-side tools are reachable under /mnt/c.
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/private/Test-IsWslSession.ps1.md#comment1)
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
