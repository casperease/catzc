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
        [Catzc.Base.QualityGates.SpellingOracle]::Initialize($englishPath, [string[]] $termPaths,
            [string[]] $fixturePaths)
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
        # 'capi' is test-only vocabulary: coined in production scope, known when fixtures are included.
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $false) | Should -Be @('capi')
        [Catzc.Base.QualityGates.SpellingOracle]::CoinedFragments('capi', $true) | Should -BeNullOrEmpty
    }

    It 'IsKnown is true for a real word and false for a coinage' {
        [Catzc.Base.QualityGates.SpellingOracle]::IsKnown('collection') | Should -BeTrue
        # Three characters, below cspell's minWordLength, so Test-Spelling does not flag the literal.
        [Catzc.Base.QualityGates.SpellingOracle]::IsKnown('zzq') | Should -BeFalse
    }
}

Describe 'SpellingOracle paths' -Tag 'L0', 'logic' {
    It 'names the assets folder, the word list and its stamp under the module root its caller passes' {
        $root = Join-Path $TestDrive 'widget-modules/Gadget.Gates'
        $assets = [Catzc.Base.QualityGates.SpellingOracle]::AssetsFolder($root)
        $assets | Should -Be ([System.IO.Path]::GetFullPath((Join-Path $root 'assets')))
        [Catzc.Base.QualityGates.SpellingOracle]::DictionaryPath($assets) |
            Should -Be (Join-Path $assets 'english.txt.gz')
        [Catzc.Base.QualityGates.SpellingOracle]::DictionaryStampPath($assets) |
            Should -Be (Join-Path $assets 'english.stamp')
    }

    It 'gives its inputs as the word list, its own source and the .cspell term lists, sorted, a missing term folder adding none' {
        $repository = Join-Path $TestDrive 'widget-repository'
        $modules = Join-Path $repository 'widget-modules/Gadget.Gates'
        $terms = Join-Path $repository '.cspell'
        [System.IO.Directory]::CreateDirectory($terms) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $terms 'gadget.txt'), "gadget`n")
        $inputs = [Catzc.Base.QualityGates.SpellingOracle]::Inputs($repository, $modules)
        @($inputs | ForEach-Object { [System.IO.Path]::GetRelativePath($repository, $_).Replace('\', '/') }) |
            Should -Be @(
                '.cspell/gadget.txt'
                'widget-modules/Gadget.Gates/assets/english.txt.gz'
                'widget-modules/Gadget.Gates/types/SpellingOracle.cs'
            )
        [System.IO.Directory]::Delete($terms, $true)
        @([Catzc.Base.QualityGates.SpellingOracle]::Inputs($repository, $modules)).Count | Should -Be 2
    }
}
