<#
---
catzc:
  docs: "../../../docs/references/pwsh/scriptanalyzer/tests/NoRawInformationStream.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Measure-NoRawInformationStream' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path (Get-CatzcModulesRoot) '.scriptanalyzer/NoRawInformationStream.psm1') -Force
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer') -Force
        }

        function Test-RawInfo {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-NoRawInformationStream -ScriptBlockAst $ast
        }
    }

    It 'flags a direct Write-Information call: <Desc>' -ForEach @(
        @{ Desc = 'bare string'; Code = "Write-Information 'a.md: 2'" }
        @{ Desc = 'expandable string'; Code = 'Write-Information "$x done"' }
        @{ Desc = 'empty line'; Code = "Write-Information ''" }
    ) {
        Test-RawInfo $Code | Should -Not -BeNullOrEmpty
    }

    It 'flags Write-Information inside a function other than the chokepoint' {
        $code = @'
function Write-Thing {
    Write-Information 'hello'
}
'@
        Test-RawInfo $code | Should -Not -BeNullOrEmpty
    }

    It 'exempts the chokepoint <Name> (a sanctioned caller)' -ForEach @(
        @{ Name = 'Write-InformationColored' }
        @{ Name = 'Write-ImporterMessage' }
    ) {
        $code = @"
function $Name {
    param(`$MessageData)
    Write-Information `$MessageData
}
"@
        Test-RawInfo $code | Should -BeNullOrEmpty
    }

    It 'passes clean code that uses Write-Message' {
        Test-RawInfo "Write-Message 'a.md: 2' -NoHeader" | Should -BeNullOrEmpty
    }

    It 'does not flag Write-Information named as a string argument to Mock/Should' {
        # 'Write-Information' here is an argument, not the invoked command, so GetCommandName() is Mock/Should.
        Test-RawInfo 'Mock Write-Information { }' | Should -BeNullOrEmpty
    }
}
