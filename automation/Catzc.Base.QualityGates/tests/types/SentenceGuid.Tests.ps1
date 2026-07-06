# cspell:ignore oilzstgq
Describe 'SentenceGuid' -Tag 'L0', 'logic' {
    It 'is deterministic — the same sentence yields the same GUID' {
        $a = [Catzc.Base.QualityGates.SentenceGuid]::Convert('the quick brown fox')
        $b = [Catzc.Base.QualityGates.SentenceGuid]::Convert('the quick brown fox')
        $a | Should -Be $b
    }

    It 'spells the sentence through the hex look-alike map' {
        # s→5 a→a m✗ p✗ l→1 e→e | t→7 e→e s→5 t→7 | d→d a→a t→7 a→a, padded with zeros to 32.
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('sample test data')
        "$result" | Should -BeExactly '5a1e7e57-da7a-0000-0000-000000000000'
    }

    It 'maps each leet character to its hex look-alike' {
        # o→0 i→1 l→1 z→2 s→5 g→6 t→7 q→9 — one input exercising the whole non-identity table.
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('oilzstgq')
        "$result" | Should -BeExactly '01125769-0000-0000-0000-000000000000'
    }

    It 'passes hex letters and digits through unchanged' {
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('abcdef0123456789')
        "$result" | Should -BeExactly 'abcdef01-2345-6789-0000-000000000000'
    }

    It 'drops characters with no hex look-alike' {
        # h j k m n p r u v w x y, whitespace, and punctuation all vanish; only 'a' survives.
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('h j-k.m,n p!r?u v(w)x y a')
        "$result" | Should -BeExactly 'a0000000-0000-0000-0000-000000000000'
    }

    It 'is case-insensitive' {
        $upper = [Catzc.Base.QualityGates.SentenceGuid]::Convert('SAMPLE TEST DATA')
        $lower = [Catzc.Base.QualityGates.SentenceGuid]::Convert('sample test data')
        $upper | Should -Be $lower
    }

    It 'truncates past 32 mappable characters' {
        # 40 mappable chars in — only the first 32 land in the GUID.
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert(('abcdef05' * 5))
        "$result" | Should -BeExactly 'abcdef05-abcd-ef05-abcd-ef05abcdef05'
    }

    It 'yields the all-zeros GUID for an input with no mappable characters' {
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('!!! ??? ,,,')
        "$result" | Should -BeExactly '00000000-0000-0000-0000-000000000000'
    }

    It 'yields a valid GUID for every hostile input' {
        $hostile = @(
            'æøå unicode 🚀 emoji'
            '   leading and trailing   '
            ([string][char]0x00E9 * 100)
            'a'
            ('the quick brown fox ' * 50)
            "tabs`tand`nnewlines"
        )
        foreach ($sentence in $hostile) {
            $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert($sentence)
            $result | Should -BeOfType [guid]
        }
    }

    It 'throws on a null, empty, or whitespace-only sentence' {
        { [Catzc.Base.QualityGates.SentenceGuid]::Convert($null) } | Should -Throw
        { [Catzc.Base.QualityGates.SentenceGuid]::Convert('') } | Should -Throw
        { [Catzc.Base.QualityGates.SentenceGuid]::Convert('   ') } | Should -Throw
    }
}
