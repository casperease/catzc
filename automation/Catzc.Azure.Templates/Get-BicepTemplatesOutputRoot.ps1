<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
    name: get-bicep-templates-output-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Templates/tests/Get-BicepTemplatesOutputRoot.Tests.ps1
    cites:
      - ADR-AUTO-TEST#26
      - ADR-PWSH-PESTER#2
---
#>

function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
