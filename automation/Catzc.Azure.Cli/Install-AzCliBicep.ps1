<#
.SYNOPSIS
    Installs (or upgrades) the Bicep CLI that az uses, to at least the configured minimum.
.DESCRIPTION
    The install companion to Test-AzCliBicep (query) and Assert-AzCliBicep (throw). `az bicep build` needs the
    Bicep CLI; this provisions it deterministically instead of relying on az's silent first-use auto-install,
    which can fail quietly behind an enterprise proxy or leave a stale version. Idempotent — skips when the
    Bicep CLI already meets Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); installs it when absent,
    upgrades it when too old. Asserts the az CLI itself first (Assert-Tool 'az_cli'), and confirms the result
    meets the minimum before returning. See docs/adr/automation/powershell/prefer-az-cli.md#rule-adr-azcli1.
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
