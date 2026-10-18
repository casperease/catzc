<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/private/Test-IsWslSession.ps1
    folder: private
    name: test-is-wsl-session
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Tooling.Provisioning/tests/Test-IsWslSession.Tests.ps1
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
