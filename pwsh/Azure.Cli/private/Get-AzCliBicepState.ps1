function Get-AzCliBicepState {
    param()

    $minVersion = Get-AzureBicepMinVersion

    # Silent: the version line is parsed, not shown, so a build does not echo it on every run.
    $result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent
    if ($result.ExitCode -ne 0) {
        return [Catzc.Azure.Cli.BicepState]::new($false, $null, $minVersion, $false)
    }

    # `az bicep version` prints e.g. "Bicep CLI version 0.43.8 (310735909d)".
    $installedVersion = $null
    if ("$($result.Output)" -match '(\d+\.\d+\.\d+)') {
        $installedVersion = [version]$Matches[1]
    }

    [Catzc.Azure.Cli.BicepState]::new($true, $installedVersion, $minVersion, ($null -ne $installedVersion -and
            $installedVersion -ge $minVersion))
}
