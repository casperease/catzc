<#
.SYNOPSIS
    Installs (or upgrades) the Bicep CLI that az uses, to at least the configured minimum.
.DESCRIPTION
    The install companion to Test-AzCliBicep (query) and Assert-AzCliBicep (throw).
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1)
    [comment:1](/docs/references/automation/catzc-azure-cli/Install-AzCliBicep.ps1.md#comment1)
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
