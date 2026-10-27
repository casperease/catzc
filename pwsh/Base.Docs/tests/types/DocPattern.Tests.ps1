Describe 'DocPattern' -Tag 'L0', 'logic' {
    It 'constructs and exposes the glob' {
        [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'widgets/*' }).glob | Should -Be 'widgets/*'
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $p = [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'a/*' })
        $p.Contains('glob') | Should -BeTrue
        $p['glob'] | Should -Be 'a/*'
    }

    It 'throws when glob is missing' {
        { [Catzc.Base.Docs.DocPattern]::new(@{}) } | Should -Throw '*glob is required*'
    }

    It 'refuses a source template, since the module article is derived' -Tag 'PDR-ONELIVE-NOCOMPATIBILITYSHIMS' {
        { [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'a/*'; source = 'b/{kebab}.md' }) } | Should -Throw "*'source' is no longer a pattern key*"
    }
}
