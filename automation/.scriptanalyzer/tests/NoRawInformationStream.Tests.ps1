# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
# ScriptBlockAst. The engine-wiring proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath)
# lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-NoRawInformationStream' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/NoRawInformationStream.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
        # once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
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

    It 'exempts the chokepoint Write-InformationColored (the one sanctioned caller)' {
        $code = @'
function Write-InformationColored {
    param($MessageData)
    Write-Information $MessageData
}
'@
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
