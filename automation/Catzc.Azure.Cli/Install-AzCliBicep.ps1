<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
    name: install-az-cli-bicep
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Cli/tests/Install-AzCliBicep.Tests.ps1
    adrs:
      - ADR-AZ-CLI#1
  config:
    synopsis: Installs (or upgrades) the Bicep CLI that az uses, to at least the configured minimum.
    description: |-
      The install companion to Test-AzCliBicep (query) and Assert-AzCliBicep (throw). `az bicep build` needs the
      Bicep CLI; this provisions it deterministically instead of relying on az's silent first-use auto-install,
      which can fail quietly behind an enterprise proxy or leave a stale version. Idempotent — skips when the
      Bicep CLI already meets Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); installs it when absent,
      upgrades it when too old. Asserts the az CLI itself first (Assert-Tool 'az_cli'), and confirms the result
      meets the minimum before returning. See
      [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
    parameters:
      Force: Upgrade to the latest Bicep CLI even when the installed one already meets the minimum.
    examples:
      - Install-AzCliBicep
---
#>

function Install-AzCliBicep {
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    Assert-Tool 'az_cli'

    $state = Get-AzCliBicepState
    if ($state.meets_minimum -and -not $Force) {
        Write-Message "Bicep CLI $($state.version) is already installed (minimum $($state.min_version))"
        return
    }

    # Not installed -> install; present (too old, or -Force) -> upgrade. Both fetch the latest Bicep CLI.
    if ($state.installed) {
        Invoke-AzCli 'bicep upgrade'
    }
    else {
        Invoke-AzCli 'bicep install'
    }

    # Confirm the freshly installed/upgraded Bicep CLI now meets the minimum (Get-AzCliBicepState re-probes az).
    Assert-AzCliBicep
    Write-Message "Bicep CLI installed (minimum $($state.min_version))"
}
