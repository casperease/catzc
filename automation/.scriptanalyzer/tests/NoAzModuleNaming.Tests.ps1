<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/NoAzModuleNaming.Tests.ps1
    kind: pester-test
---
#>

# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a...
# [comment:1](/docs/references/automation/scriptanalyzer/tests/NoAzModuleNaming.Tests.ps1.md#comment1)
Describe 'Measure-NoAzModuleNaming' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoAzModuleNaming.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module once...
        # [comment:2](/docs/references/automation/scriptanalyzer/tests/NoAzModuleNaming.Tests.ps1.md#comment2)
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
