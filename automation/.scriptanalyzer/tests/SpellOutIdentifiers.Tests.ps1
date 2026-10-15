<#
---
catzc:
  derived:
    path: automation/.scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-SPELL#2
      - ADR-AUTO-SPELL#4
---
#>

# The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a...
# [comment:1](/docs/references/automation/scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1.md#comment1)
Describe 'Measure-SpellOutIdentifiers' -Tag 'L0', 'logic' {
    BeforeAll {
        Import-Module (Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/SpellOutIdentifiers.psm1') -Force
        # The rule's return type ([DiagnosticRecord]) lives in the PSScriptAnalyzer assembly, so load the module once...
        # [comment:2](/docs/references/automation/scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1.md#comment2)
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
        # single-letter loop index
        # [comment:3](/docs/references/automation/scriptanalyzer/tests/SpellOutIdentifiers.Tests.ps1.md#comment3)
        @{ Code = 'foreach ($i in 1..3) { $i }' }
        @{ Code = 'function Get-Thing { param($Path) $Path }' }
    ) {
        Test-SpellOut $Code | Should -BeNullOrEmpty
    }

    It 'does not flag an external drive variable (ADR-AUTO-SPELL#4): <Code>' -ForEach @(
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
