<#
---
catzc:
  immutable:
    with_body_sha: "077feb0f35ad"
  edges:
    test: pwsh/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
    docs: "[Get-ZshInstallLayout.ps1.md](../../../docs/references/pwsh/catzc-tooling-provisioning/private/Get-ZshInstallLayout.ps1.md)"
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
