<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1
    name: assert-az-cli-bicep
    filetype: ps1
    kind: function
    subkind: assert
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure.Cli/tests/Assert-AzCliBicep.Tests.ps1
    cites:
      - ADR-AUTO-ENTERP
      - ADR-AZ-CLI#1
  config:
    synopsis: Asserts the Bicep CLI is available to az and at or above the configured minimum (throws otherwise).
    description: |-
      The throwing companion to Test-AzCliBicep. Throws a remediation-bearing error when the Bicep CLI that
      `az bicep build` needs is missing or below Get-AzureBicepMinVersion (azure.yml `bicep_min_version`),
      distinguishing the two cases: not installed -> `az bicep install`; too old -> `az bicep upgrade`.
      Asserting it before a build turns the silent "az bicep build exits 0 but writes no main.json" failure
      into a clear, early error at the source. It first asserts the az CLI itself is installed at the
      locked version (Assert-Tool 'az_cli'), then checks the Bicep CLI. Both share Get-AzCliBicepState.
      See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1) and
      [ADR-AUTO-ENTERP](/docs/adr/automation/effective-in-enterprises.md).
    parameters:
      ErrorText: Custom error message. Defaults to one naming the specific cause and the matching az bicep fix.
    examples:
      - Assert-AzCliBicep
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
