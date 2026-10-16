<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/private/Get-ZshInstallLayout.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Provisioning
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: private
    relatives:
      test: automation/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
    adrs:
      - ADR-AUTO-ENTERP
  config:
    synopsis: |-
      Returns where Install-Zsh puts zsh on Windows: the Git for Windows home, its MSYS2 runtime, zsh's executable, and the
      manifest of the files Install-Zsh added.
    description: |-
      zsh on Windows is the MSYS2 zsh package installed into the Git Bash tree that Install-Git provides, so it runs on
      Git's own MSYS2 runtime (usr\bin\msys-2.0.dll) with no admin rights
      ([ADR-AUTO-ENTERP#4](/docs/adr/automation/effective-in-enterprises.md#rule-adr-auto-enterp4)). That tree is declared
      once, by the zsh entry's windows_install_dir in tools.yml, and resolved by Get-ScriptInstallDir. The manifest lives
      inside that tree, so a tree Install-Git replaces takes the manifest with it. Install-Zsh and Uninstall-Zsh both read
      the layout here, so they agree on every path.
    outputs: '[pscustomobject] { GitHome; Runtime; Executable; Manifest }'
    examples:
      - (Get-ZshInstallLayout).Executable
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
