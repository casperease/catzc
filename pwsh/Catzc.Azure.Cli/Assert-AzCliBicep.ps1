<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
    name: assert-az-cli-bicep
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Assert-AzCliBicep.Tests.ps1
    docs: "[Assert-AzCliBicep.ps1.md](docs/references/pwsh/catzc-azure-cli/Assert-AzCliBicep.ps1.md)"
    cites:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI-AZBYDEFAULT
---
#>

function Assert-AzCliBicep {
    param(
        [string] $ErrorText
    )

    Assert-Tool 'az_cli'

    $state = Get-AzCliBicepState
    if ($state.meets_minimum) {
        return
    }

    if ($ErrorText) {
        throw $ErrorText
    }

    if (-not $state.installed) {
        throw (
            'The Bicep CLI is not available to az (`az bicep version` failed). ' +
            '`az bicep build` cannot compile without it. Run: az bicep install'
        )
    }
    if ($null -eq $state.version) {
        throw (
            'Could not determine the Bicep CLI version from `az bicep version`. ' +
            "At least $($state.min_version) is required. Run: az bicep upgrade"
        )
    }
    throw (
        "The Bicep CLI version $($state.version) is below the required minimum " +
        "$($state.min_version) (azure.yml bicep_min_version). Run: az bicep upgrade"
    )
}
