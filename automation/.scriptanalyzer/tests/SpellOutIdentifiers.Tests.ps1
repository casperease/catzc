# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
# ScriptBlockAst (the SpellingOracle it consults is loaded once, warmed in BeforeAll below). The engine-wiring
# proof (PSScriptAnalyzer discovers and fires this rule via -CustomRulePath, which also exercises the oracle
# initializing inside the analyzer's own runspace) lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
Describe 'Measure-SpellOutIdentifiers' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/SpellOutIdentifiers.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module
        # once for the type — we never invoke the analyzer engine (that is the L2 wiring test below).
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }

        function Test-SpellOut {
            param([string] $Code)
            $ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
            Measure-SpellOutIdentifiers -ScriptBlockAst $ast
        }

        # Warm the spelling oracle (dictionary load) once so it is not attributed to the first It.
        Test-SpellOut '$warm = 1' | Out-Null
    }

    It 'flags an invented abbreviation in a variable name: <Code>' -ForEach @(
        @{ Code = '$rcg = 1' }                       # coined 3-char token cspell's minWordLength misses
        @{ Code = '$zzqPath = 1' }                   # coined fragment inside a compound
        @{ Code = 'foreach ($rcg in 1..3) { $rcg }' }  # loop variable
    ) {
        Test-SpellOut $Code | Should -Not -BeNullOrEmpty
    }

    It 'accepts a fully spelled-out name: <Code>' -ForEach @(
        @{ Code = '$ruleCollectionGroup = 1' }
        @{ Code = '$templateContext = 1' }
        @{ Code = 'foreach ($i in 1..3) { $i }' }    # single-letter loop index (ADR-AUTO-SPELL:2)
        @{ Code = 'function Get-Thing { param($Path) $Path }' }
    ) {
        Test-SpellOut $Code | Should -BeNullOrEmpty
    }

    It 'does not flag an external drive variable (ADR-AUTO-SPELL:4): <Code>' -ForEach @(
        @{ Code = '$env:SomeRcgValue = "x"' }        # $env: is an external contract, not our identifier
    ) {
        Test-SpellOut $Code | Should -BeNullOrEmpty
    }

    It 'flags an invented abbreviation in a function noun' {
        Test-SpellOut 'function Get-Rcg { }' | Should -Not -BeNullOrEmpty
    }

    It 'accepts a spelled-out function noun' {
        Test-SpellOut 'function Get-ModuleTestOrder { }' | Should -BeNullOrEmpty
    }
}
