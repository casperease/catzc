<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Test-AzCliBicep.ps1
    name: test-az-cli-bicep
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliBicep.Tests.ps1
    docs: "[Test-AzCliBicep.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliBicep.ps1.md)"
    cites:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI-AZBYDEFAULT
---
#>

function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}
