Describe 'Install-AzCliBicep' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Assert-Tool { } -ModuleName Catzc.Azure.Cli
        Mock Assert-AzCliBicep { } -ModuleName Catzc.Azure.Cli
        Mock Invoke-AzCli { } -ModuleName Catzc.Azure.Cli
        Mock Write-Message { } -ModuleName Catzc.Azure.Cli
    }

    It 'skips when the Bicep CLI already meets the minimum' {
        Mock Get-AzCliBicepState { [pscustomobject]@{ installed = $true; version = '0.44.1'; min_version = '0.40.0'; meets_minimum = $true } } -ModuleName Catzc.Azure.Cli
        Install-AzCliBicep
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Cli -Times 0
    }

    It 'installs when the Bicep CLI is absent' {
        Mock Get-AzCliBicepState { [pscustomobject]@{ installed = $false; version = $null; min_version = '0.40.0'; meets_minimum = $false } } -ModuleName Catzc.Azure.Cli
        Install-AzCliBicep
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Cli -Times 1 -ParameterFilter { $Arguments -eq 'bicep install' }
    }

    It 'upgrades when the Bicep CLI is present but too old' {
        Mock Get-AzCliBicepState { [pscustomobject]@{ installed = $true; version = '0.30.0'; min_version = '0.40.0'; meets_minimum = $false } } -ModuleName Catzc.Azure.Cli
        Install-AzCliBicep
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Cli -Times 1 -ParameterFilter { $Arguments -eq 'bicep upgrade' }
    }

    It 'upgrades under -Force even when already at the minimum' {
        Mock Get-AzCliBicepState { [pscustomobject]@{ installed = $true; version = '0.44.1'; min_version = '0.40.0'; meets_minimum = $true } } -ModuleName Catzc.Azure.Cli
        Install-AzCliBicep -Force
        Should -Invoke Invoke-AzCli -ModuleName Catzc.Azure.Cli -Times 1 -ParameterFilter { $Arguments -eq 'bicep upgrade' }
    }
}
