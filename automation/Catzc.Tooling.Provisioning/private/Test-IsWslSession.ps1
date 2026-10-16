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
  config:
    synopsis: Tests whether the current session runs inside WSL (Windows Subsystem for Linux).
    description: |-
      A WSL distribution sets WSL_DISTRO_NAME, and a WSL kernel identifies itself in /proc/version
      ("microsoft"). Either signal means the Linux session is backed by a Windows host, so
      Windows-side tools are reachable under /mnt/c. Never true outside Linux.
    outputs: '[bool]'
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
