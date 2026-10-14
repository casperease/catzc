<#
.SYNOPSIS
    Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the
    manifest of the files Install-Zsh added.
.DESCRIPTION
    zsh on Windows is the MSYS2 zsh package installed into the Git Bash tree that Install-Git provides at
    %LOCALAPPDATA%\Git, so it runs on Git's own MSYS2 runtime (usr\bin\msys-2.0.dll) with no admin rights
    ([ADR-AUTO-ENTERP#4](/docs/adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)). The manifest lives
    inside that tree, so a tree Install-Git replaces takes the manifest with it. Install-Zsh and Uninstall-Zsh both read
    the layout here, so they agree on every path.
.OUTPUTS
    [pscustomobject] { GitHome; Runtime; Executable; Manifest }
.EXAMPLE
    (Get-ZshInstallLayout).Executable
#>
function Get-ZshInstallLayout {
    [OutputType([pscustomobject])]
    [CmdletBinding()]
    param()

    $gitHome = Join-Path $env:LOCALAPPDATA 'Git'
    [pscustomobject]@{
        GitHome    = $gitHome
        Runtime    = Join-Path $gitHome 'usr\bin\msys-2.0.dll'
        Executable = Join-Path $gitHome 'usr\bin\zsh.exe'
        Manifest   = Join-Path $gitHome 'usr\share\catzc\zsh.manifest.json'
    }
}
