<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1
    name: test-az-cli-bicep
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Test-AzCliBicep.Tests.ps1
    cites:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI#1
---
#>

function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}
