Describe 'Measure-NoAzModuleNaming' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        $script:rulePath = Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoAzModuleNaming.psm1'

        function Test-AzureNaming {
            param([string] $Code)
            Invoke-ScriptAnalyzer -ScriptDefinition $Code -CustomRulePath $script:rulePath |
                Where-Object RuleName -EQ 'Measure-NoAzModuleNaming'
        }
    }

    It 'flags Az PowerShell module naming: <Name>' -ForEach @(
        @{ Name = 'Get-AzResource' }
        @{ Name = 'New-AzVM' }
        @{ Name = 'Remove-AzResourceGroup' }
    ) {
        Test-AzureNaming "function $Name { }" | Should -Not -BeNullOrEmpty
    }

    It 'accepts a sanctioned name: <Name>' -ForEach @(
        @{ Name = 'Get-AzureResourceName' }    # Azure spelled out (platform)
        @{ Name = 'Deploy-AzureResourceGroup' }
        @{ Name = 'Invoke-AzCli' }             # az CLI wrapper
        @{ Name = 'Assert-AzCliIsConnected' }  # az CLI connectivity
        @{ Name = 'Assert-AzBicepValid' }      # az bicep check (AzBicep* sanctioned)
        @{ Name = 'Get-BicepTemplate' }        # no Az* prefix at all
    ) {
        Test-AzureNaming "function $Name { }" | Should -BeNullOrEmpty
    }
}
