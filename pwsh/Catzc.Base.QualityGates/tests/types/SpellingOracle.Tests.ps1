<#
---
catzc:
  immutable:
    with_body_sha: "22f48a3659d8"
  edges:
    docs: "[SpellingOracle.Tests.ps1.md](../../../../docs/references/pwsh/catzc-base-quality-gates/tests/types/SpellingOracle.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/types/SpellingOracle.cs
    cites:
      - ADR-AUTO-SPELL-CATEGORYANDMEANING
      - ADR-AUTO-TEST-ONECATEGORY
---
#>

Describe 'SpellingOracle.Tokenize' -Tag 'L0', 'logic' {
    # Tokenize is a pure function of its input — no dictionary, no Initialize required.
    It 'splits camelCase into lower-cased fragments' {
        [Catzc.Base.QualityGates.SpellingOracle]::Tokenize('ruleCollectionGroup') |
            Should -Be @('rule', 'collection', 'group')
    }

    It 'splits snake_case on underscores' {
        [Catzc.Base.QualityGates.SpellingOracle]::Tokenize('rule_collection_group') |
            Should -Be @('rule', 'collection', 'group')
    }

    It 'splits a camel acronym seam (lower to Upper)' {
        [Catzc.Base.QualityGates.SpellingOracle]::Tokenize('ioStream') | Should -Be @('io', 'stream')
    }

    It 'splits an acronym-to-word seam (UpperRun then Upper+lower)' {
        [Catzc.Base.QualityGates.SpellingOracle]::Tokenize('HTTPServer') | Should -Be @('http', 'server')
    }

    It 'treats digits as separators and drops them' {
        [Catzc.Base.QualityGates.SpellingOracle]::Tokenize('utf8Value') | Should -Be @('utf', 'value')
    }

    It 'yields a single fragment for a bare word' {
        [Catzc.Base.QualityGates.SpellingOracle]::Tokenize('rcg') | Should -Be @('rcg')
    }
}

Describe 'SpellingOracle.CoinedFragments (shipped dictionary)' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $englishPath = Get-CatzcModuleRoot 'assets/english.txt.gz' -Module Catzc.Base.QualityGates
        $allTermPaths = @(Get-ChildPath (Join-Path (Get-RepositoryRoot) '.cspell') -File -Filter '*.txt' -Depth 1)
        $fixturePaths = @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -eq 'fixture.txt' })
        $termPaths = @($allTermPaths | Where-Object { [System.IO.Path]::GetFileName($_) -ne 'fixture.txt' })
        [Catzc.Base.QualityGates.SpellingOracle]::Initialize($englishPath, [string[]] $termPaths, [string[]] $fixturePaths)
    }

    It 'loads a substantial English word set' {
        [Catzc.Base.QualityGates.SpellingOracle]::WordCount | Should -BeGreaterThan 100000
    }

    It 'passes a fully spelled-out identifier (every fragment a real word)' {
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('ruleCollectionGroup') | Should -BeNullOrEmpty
    }

    It 'flags an invented short abbreviation' {
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('rcg') | Should -Be @('rcg')
    }

    It 'flags only the coined fragment of a compound, keeping the real word' {
        # zzq is a coined fragment; path is a real word — only zzq is returned.
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('zzqPath') | Should -Be @('zzq')
    }

    It 'exempts single-letter fragments (loop indices)' {
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('i') | Should -BeNullOrEmpty
    }

    It 'accepts a fixture term only in test scope (ADR-AUTO-SPELL-CATEGORYANDMEANING)' {
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $false) | Should -Be @('capi')
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $true) | Should -BeNullOrEmpty
    }

    It 'IsKnown is true for a real word and false for a coinage' {
        [Catzc.Base.QualityGates.SpellingOracle]::IsKnown('collection') | Should -BeTrue
        [Catzc.Base.QualityGates.SpellingOracle]::IsKnown('zzq') | Should -BeFalse
    }
}
