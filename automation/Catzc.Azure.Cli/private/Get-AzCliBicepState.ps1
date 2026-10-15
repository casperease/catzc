<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/private/Get-AzCliBicepState.ps1
    kind: private-function
    module: Catzc.Azure.Cli
    visibility: private
    adrs:
      - ADR-AUTO-PRELOG#5
  config:
    synopsis: Returns the Bicep CLI state relative to the configured minimum version.
    description: |-
      Runs `az bicep version`, parses the installed MAJOR.MINOR.PATCH, and compares it against
      Get-AzureBicepMinVersion (azure.yml `bicep_min_version`). The single source of the comparison, shared
      by Test-AzCliBicep (returns a bool) and Assert-AzCliBicep (throws), so the two cannot drift — the same
      pattern as Get-AzCliConnectionState.

      Returns an ordered dictionary:
        { installed, version, min_version, meets_minimum }
      `installed` is false when `az bicep version` exits non-zero. `version` is the parsed [version] (or
      $null when the output cannot be parsed). `meets_minimum` requires an installed, parseable version at
      or above the minimum.
    examples:
      - (Get-AzCliBicepState).meets_minimum
---
#>

function Get-AzCliBicepState {
    param()

    $minVersion = Get-AzureBicepMinVersion

    # -Silent: a plumbing probe whose output we capture via -PassThru and parse below, so the "Bicep CLI version X"...
    # [comment:3](/docs/references/automation/catzc-azure-cli/private/Get-AzCliBicepState.ps1.md#comment3)
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
