<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-EnvironmentDiagnostic.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Writers
    visibility: public
    relatives:
      test: automation/Catzc.Base.Writers/tests/Write-EnvironmentDiagnostic.Tests.ps1
  config:
    synopsis: Displays all environment variables sorted by name.
    examples:
      - Write-EnvironmentDiagnostic
---
#>

function Write-EnvironmentDiagnostic {
    [CmdletBinding()]
    param()

    Get-ChildItem env: |
        Select-Object Name, Value |
        Sort-Object Name |
        Format-Table -Property @{ Expression = 'Name'; Width = 40 }, Value
}
