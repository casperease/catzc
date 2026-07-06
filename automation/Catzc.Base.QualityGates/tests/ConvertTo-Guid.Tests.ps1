Describe 'ConvertTo-Guid' -Tag 'L0', 'logic' {
    It 'returns a [guid], positionally' {
        $result = ConvertTo-Guid 'sample test data'
        $result | Should -BeOfType [guid]
        "$result" | Should -BeExactly '5a1e7e57-da7a-0000-0000-000000000000'
    }

    It 'matches the SentenceGuid type it wraps' {
        $sentence = 'alpha test tenant'
        (ConvertTo-Guid $sentence) | Should -Be ([Catzc.Base.QualityGates.SentenceGuid]::Convert($sentence))
    }

    It 'throws on a null, empty, or whitespace-only sentence' {
        # Bind explicitly — an omitted mandatory parameter prompts instead of throwing in an interactive host.
        { ConvertTo-Guid -Sentence $null } | Should -Throw
        { ConvertTo-Guid -Sentence '' } | Should -Throw
        { ConvertTo-Guid -Sentence '   ' } | Should -Throw
    }
}
