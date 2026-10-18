<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1
    folder: private
    name: get-zsh-install-layout
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
    test: automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
    cites:
      - ADR-AUTO-ENTERP
---
#>

function Get-ZshInstallLayout {
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param()

    $gitHome = Get-ScriptInstallDir -Config (Get-ToolConfig -Tool zsh)
    [pscustomobject]@{
        GitHome    = $gitHome
        Runtime    = Join-Path $gitHome 'usr\bin\msys-2.0.dll'
        Executable = Join-Path $gitHome 'usr\bin\zsh.exe'
        Manifest   = Join-Path $gitHome 'usr\share\catzc\zsh.manifest.json'
    }
}
