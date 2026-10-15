<#
.SYNOPSIS
    Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the
    manifest of the files Install-Zsh added.
.DESCRIPTION
    zsh on Windows is the MSYS2 zsh package installed into the Git Bash tree that Install-Git provides, so it runs on...
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
