<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1
    kind: private-function
    module: Catzc.Tooling.Provisioning
    visibility: private
    adrs:
      - ADR-AUTO-ENTERP#4
---
#>

<#
.SYNOPSIS
    Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the
    manifest of the files Install-Zsh added.
.DESCRIPTION
    One shared layout keeps Install-Zsh and Uninstall-Zsh on the same paths; the manifest dies with a replaced Git tree.
.OUTPUTS
    [pscustomobject] { GitHome; Runtime; Executable; Manifest }
.EXAMPLE
    (Get-ZshInstallLayout).Executable
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
