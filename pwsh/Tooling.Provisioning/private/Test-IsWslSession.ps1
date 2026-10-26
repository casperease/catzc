<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-tooling-provisioning/private/Test-IsWslSession.ps1.md"
  header: "generated"
---
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
