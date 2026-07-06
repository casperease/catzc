# cspell:ignore oilzstgq
Describe 'SentenceGuid' -Tag 'L0', 'logic' {
    It 'is deterministic — the same sentence yields the same GUID' {
        $a = [Catzc.Base.QualityGates.SentenceGuid]::Convert('the quick brown fox')
        $b = [Catzc.Base.QualityGates.SentenceGuid]::Convert('the quick brown fox')
        $a | Should -Be $b
    }

    It 'spells the sentence through the hex look-alike map, one digit per character' {
        # s→5 a→a m→0 p→0 l→1 e→e | (word break: skip to the next dash group) | t→7 e→e s→5 t→7 | d→d a→a t→7 a→a
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('sample test data')
        "$result" | Should -BeExactly '5a001e00-7e57-da7a-0000-000000000000'
    }

    It 'aligns each word to its own dash group' {
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('be a cafe')
        "$result" | Should -BeExactly 'be000000-a000-cafe-0000-000000000000'
    }

    It 'collapses whitespace runs and ignores leading whitespace' {
        $plain = [Catzc.Base.QualityGates.SentenceGuid]::Convert('be a cafe')
        [Catzc.Base.QualityGates.SentenceGuid]::Convert('   be    a  cafe') | Should -Be $plain
    }

    It 'maps each leet character to its hex look-alike' {
        # o→0 i→1 l→1 z→2 s→5 t→7 g→6 q→9 — one input exercising the whole non-identity table.
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('oilzstgq')
        "$result" | Should -BeExactly '01125769-0000-0000-0000-000000000000'
    }

    It 'passes hex letters and digits through unchanged' {
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('abcdef0123456789')
        "$result" | Should -BeExactly 'abcdef01-2345-6789-0000-000000000000'
    }

    It 'renders a character with no hex look-alike as 0' {
        # h and ! have no look-alike — each still occupies one digit, so the shape stays positional.
        $result = [Catzc.Base.QualityGates.SentenceGuid]::Convert('ah!')
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
            "tabs`t and`n newlines"
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
