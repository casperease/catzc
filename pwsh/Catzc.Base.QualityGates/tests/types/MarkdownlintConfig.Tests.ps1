Describe 'MarkdownlintConfig' -Tag 'L0' {
    Context 'integrity (shipped markdownlint.yml)' -Tag 'integrity' {
        It 'loads, and the shipped batch size is the declared default' {
            $config = Get-Config -Config markdownlint
            $config | Should -BeOfType [Catzc.Base.QualityGates.MarkdownlintConfig]
            $config.batch_size | Should -Be ([Catzc.Base.QualityGates.MarkdownlintConfig]::DefaultBatchSize)
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'gives the default batch size for an empty file and honours a declared one' {
            [Catzc.Base.QualityGates.MarkdownlintConfig]::new([ordered]@{}).batch_size | Should -Be 50
            [Catzc.Base.QualityGates.MarkdownlintConfig]::new([ordered]@{ batch_size = 7 }).batch_size | Should -Be 7
        }

        It 'throws on an unknown key and on a batch size outside 1 to 500' {
            { [Catzc.Base.QualityGates.MarkdownlintConfig]::new([ordered]@{ widget = 1 }) } |
                Should -Throw "*unknown key 'widget'*"
            { [Catzc.Base.QualityGates.MarkdownlintConfig]::new([ordered]@{ batch_size = 0 }) } |
                Should -Throw '*batch_size must be a whole number from 1 to 500*'
            { [Catzc.Base.QualityGates.MarkdownlintConfig]::new([ordered]@{ batch_size = 'many' }) } |
                Should -Throw '*batch_size must be a whole number*'
        }
    }
}
