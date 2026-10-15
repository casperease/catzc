<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/private/Get-AzCliBicepState.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: private
    adrs:
      - ADR-AUTO-PRELOG#5
---
#>

<#
.SYNOPSIS
    Returns the Bicep CLI state relative to the configured minimum version.
.DESCRIPTION
    The one comparison behind both Test and Assert, so the bool and the throw cannot drift apart.
.EXAMPLE
    (Get-AzCliBicepState).meets_minimum
#>
function Get-AzCliBicepState {
    param()

    $minVersion = Get-AzureBicepMinVersion

    # A plumbing probe parsed below, so its version line must not echo to the console on every build.
    # [comment:2](/docs/references/automation/catzc-azure-cli/private/Get-AzCliBicepState.ps1.md#comment2)
    $result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0) {
        return [Catzc.Azure.Cli.BicepState]::new($false, $null, $minVersion, $false)
    }

    # `az bicep version` prints e.g. "Bicep CLI version 0.43.8 (310735909d)".
    $installedVersion = $null
    if ("$($result.Output)" -match '(\d+\.\d+\.\d+)') {
        $installedVersion = [version]$Matches[1]
    }

    [Catzc.Azure.Cli.BicepState]::new($true, $installedVersion, $minVersion, ($null -ne $installedVersion -and $installedVersion -ge $minVersion))
}
