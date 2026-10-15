<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1
    kind: pester-test
---
#>

# This file is covered by Test-ScriptAnalyzer like all authored PowerShell (Get-AutomationSourceFiles).
# [comment:1](/docs/references/automation/scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1.md#comment1)
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoRawVsoCommand', '', Justification = 'Test fixtures intentionally contain raw ##vso[task.*] strings to prove the rule flags them.')]
param()

# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a...
# [comment:2](/docs/references/automation/scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1.md#comment2)
Describe 'Measure-NoRawVsoCommand' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawVsoCommand.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module once...
        # [comment:3](/docs/references/automation/scriptanalyzer/tests/NoRawVsoCommand.Tests.ps1.md#comment3)
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-RawVso {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoRawVsoCommand -ScriptBlockAst $ast
        }
    }

    It 'flags a raw ##vso command in a script: <Desc>' -ForEach @(
        @{ Desc = 'setvariable, double quotes'; Code = 'Write-Host "##vso[task.setvariable variable=Foo]bar"' }
        @{ Desc = 'setvariable, single quotes'; Code = "Write-Output '##vso[task.setvariable variable=Foo]bar'" }
        @{ Desc = 'logissue'; Code = 'Write-Host "##vso[task.logissue type=error]boom"' }
    ) {
        Test-RawVso $Code | Should -Not -BeNullOrEmpty
    }

    It 'flags a raw ##vso command in a function other than the setter' {
        $code = @'
function Set-SomethingElse {
    Write-Host "##vso[task.setvariable variable=Foo]bar"
}
'@
        Test-RawVso $code | Should -Not -BeNullOrEmpty
    }

    It 'exempts the canonical Set-AdoPipelineVariable function' {
        $code = @'
function Set-AdoPipelineVariable {
    param([string] $Name, [string] $Value)
    Write-Host "##vso[task.setvariable variable=$Name]$Value"
}
'@
        Test-RawVso $code | Should -BeNullOrEmpty
    }

    It 'passes clean code with no ##vso strings' {
        Test-RawVso 'Set-AdoPipelineVariable -Name Foo -Value bar' | Should -BeNullOrEmpty
    }
}
