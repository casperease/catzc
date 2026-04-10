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

Describe 'SpellingOracle.CoinedFragments (shipped dictionary)' -Tag 'L1', 'integrity' {
    BeforeAll {
        # Binds to the shipped English list + the generated term lists — an integrity test by construction
        # (ADR-TEST:1): it verifies the real oracle, not a fixture. The static load is idempotent, so this is safe
        # to run alongside any other consumer in the same process.
        $englishPath = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets/english.txt.gz'
        $allTermPaths = @(Get-ChildItem (Join-Path (Get-RepositoryRoot) '.cspell/*.txt') | ForEach-Object FullName)
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

    It 'accepts a fixture term only in test scope (ADR-SPELL:6)' {
        # 'capi' is a fixture-category term — test-only vocabulary. It is coined in production scope and
        # known only when fixtures are included (a test file).
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $false) | Should -Be @('capi')
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $true) | Should -BeNullOrEmpty
    }

    It 'IsKnown is true for a real word and false for a coinage' {
        [Catzc.Base.QualityGates.SpellingOracle]::IsKnown('collection') | Should -BeTrue
        # A 3-char nonsense token: not in the oracle (IsKnown false), and below cspell's minWordLength so the
        # spelling gate does not flag the literal here.
        [Catzc.Base.QualityGates.SpellingOracle]::IsKnown('zzq') | Should -BeFalse
    }
}
