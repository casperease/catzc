Describe 'Measure-SpellOutIdentifiers' -Tag 'L2', 'logic' {
    BeforeAll {
        if (-not (Get-Module PSScriptAnalyzer)) {
            Import-Module (Join-Path $env:RepositoryRoot 'automation/.vendor/PSScriptAnalyzer') -Force
        }
        $script:rulePath = Join-Path $env:RepositoryRoot 'automation/.scriptanalyzer/SpellOutIdentifiers.psm1'

        function Test-SpellOut {
            param([string] $Code)
            Invoke-ScriptAnalyzer -ScriptDefinition $Code -CustomRulePath $script:rulePath |
                Where-Object RuleName -EQ 'Measure-SpellOutIdentifiers'
        }
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
        @{ Code = 'foreach ($i in 1..3) { $i }' }    # single-letter loop index (ADR-SPELL:2)
        @{ Code = 'function Get-Thing { param($Path) $Path }' }
    ) {
        Test-SpellOut $Code | Should -BeNullOrEmpty
    }

    It 'does not flag an external drive variable (ADR-SPELL:4): <Code>' -ForEach @(
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
