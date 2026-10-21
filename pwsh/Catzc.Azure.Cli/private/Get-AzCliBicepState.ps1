<#
---
catzc:
  immutable:
    with_body_sha: dcc2affc99ab
  edges:
    docs: "[Get-AzCliBicepState.ps1.md](docs/references/pwsh/catzc-azure-cli/private/Get-AzCliBicepState.ps1.md)"
    cites:
      - ADR-AUTO-PRELOG-SILENTSWITCH
---
#>

function Get-AzCliBicepState {
    param()

    $minVersion = Get-AzureBicepMinVersion

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
