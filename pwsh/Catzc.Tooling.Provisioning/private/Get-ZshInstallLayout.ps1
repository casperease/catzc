<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1
    folder: private
    name: get-zsh-install-layout
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
    test: pwsh/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
    docs: "[Get-ZshInstallLayout.ps1.md](docs/references/pwsh/catzc-tooling-provisioning/private/Get-ZshInstallLayout.ps1.md)"
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
