<#
---
catzc:
  immutable:
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
  config:
    synopsis: Tests whether the Bicep CLI is available to az AND at or above the configured minimum version.
    description: |-
      Returns $true when `az bicep version` exits zero and reports a version at or above
      Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); $false otherwise (not installed, unparseable,
      or too old). A pure query: it never throws. Use Assert-AzCliBicep for the throwing companion (with a
      remediation message that distinguishes not-installed from too-old). Both share Get-AzCliBicepState.

      Why this exists: `az bicep build` auto-installs the Bicep CLI on first use, and on a machine where
      that install is missing, blocked (enterprise proxy/firewall), or stale, the first build can exit zero
      while writing no main.json. Probing `az bicep version` first surfaces — and warms — the Bicep CLI, and
      enforces a known-good minimum, before a build depends on it.
      See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1) and
      [ADR-AUTO-ENTERP](/docs/adr/automation/effective-in-enterprises.md).
    examples:
      - if (Test-AzCliBicep) { Build-Bicep sample }
---
#>

function Test-AzCliBicep {
    [OutputType([bool])]
    param()

    (Get-AzCliBicepState).meets_minimum
}
