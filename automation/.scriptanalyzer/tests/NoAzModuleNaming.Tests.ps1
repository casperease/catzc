<#
---
catzc:
  immutable:
    path: automation/.scriptanalyzer/tests/NoAzModuleNaming.Tests.ps1
    folder: automation/.scriptanalyzer/tests
    name: no-az-module-naming-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
  edges:
    page: docs/references/automation/scriptanalyzer/tests/NoAzModuleNaming.Tests.ps1.md
---
#>

Describe 'Measure-NoAzModuleNaming' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoAzModuleNaming.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-AzureNaming {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoAzModuleNaming -ScriptBlockAst $ast
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
