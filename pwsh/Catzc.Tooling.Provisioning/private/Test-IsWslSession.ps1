<#
---
catzc:
  immutable:
    with_body_sha: "4f84ae705014"
  edges:
    test: pwsh/Catzc.Tooling.Provisioning/tests/Test-IsWslSession.Tests.ps1
    docs: "[Test-IsWslSession.ps1.md](docs/references/pwsh/catzc-tooling-provisioning/private/Test-IsWslSession.ps1.md)"
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
