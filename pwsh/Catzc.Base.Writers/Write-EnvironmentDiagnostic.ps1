<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Writers/Write-EnvironmentDiagnostic.ps1
    name: write-environment-diagnostic
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-EnvironmentDiagnostic.Tests.ps1
    docs: "[Write-EnvironmentDiagnostic.ps1.md](docs/references/pwsh/catzc-base-writers/Write-EnvironmentDiagnostic.ps1.md)"
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
