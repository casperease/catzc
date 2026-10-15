<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1
    kind: function
    module: Catzc.Tooling.Provisioning
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the
    manifest of the files Install-Zsh added.
.DESCRIPTION
    One shared layout keeps Install-Zsh and Uninstall-Zsh on the same paths; the manifest dies with a replaced Git tree.
    [ADR-AUTO-ENTERP#4](/docs/adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)
    [comment:1](/docs/references/automation/catzc-tooling-provisioning/private/Get-ZshInstallLayout.ps1.md#comment1)
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
