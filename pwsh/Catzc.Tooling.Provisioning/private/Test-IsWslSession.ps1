<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Provisioning/private/Test-IsWslSession.ps1
    folder: private
    name: test-is-wsl-session
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
