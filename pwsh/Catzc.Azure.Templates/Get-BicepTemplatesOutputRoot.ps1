<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
    name: get-bicep-templates-output-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplatesOutputRoot.Tests.ps1
    docs: "[Get-BicepTemplatesOutputRoot.ps1.md](docs/references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md)"
    cites:
      - ADR-AUTO-TEST-ONESCHEDULINGPOOL
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
---
#>

function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
