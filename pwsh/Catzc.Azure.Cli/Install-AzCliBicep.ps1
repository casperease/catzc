<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Install-AzCliBicep.ps1
    name: install-az-cli-bicep
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Install-AzCliBicep.Tests.ps1
    docs: "[Install-AzCliBicep.ps1.md](docs/references/pwsh/catzc-azure-cli/Install-AzCliBicep.ps1.md)"
    cites:
      - ADR-AZ-CLI-AZBYDEFAULT
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
