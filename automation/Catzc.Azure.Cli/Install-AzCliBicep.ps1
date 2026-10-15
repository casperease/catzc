<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1
    kind: public-function
    module: Catzc.Azure.Cli
    visibility: public
    adrs:
      - ADR-AZ-CLI#1
---
#>

<#
.SYNOPSIS
    Installs (or upgrades) the Bicep CLI that az uses, to at least the configured minimum.
.DESCRIPTION
    Installs on purpose because az's silent first-use auto-install can fail quietly behind an enterprise proxy.
.PARAMETER Force
    Upgrade to the latest Bicep CLI even when the installed one already meets the minimum.
.EXAMPLE
    Install-AzCliBicep
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
