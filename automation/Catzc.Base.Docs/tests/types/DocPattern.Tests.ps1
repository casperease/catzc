# Validates the compiled DocPattern type directly — the constructor is the gate that stops a malformed
# readme.yml patterns entry from ever producing an instance.
Describe 'DocPattern' -Tag 'L0', 'logic' {
    It 'constructs and exposes glob + source' {
        $p = [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'automation/*'; source = 'docs/references/automation/{kebab}.md' })
        $p.glob | Should -Be 'automation/*'
        $p.source | Should -Be 'docs/references/automation/{kebab}.md'
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $p = [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'a/*'; source = 'b/{kebab}.md' })
        $p.Contains('glob') | Should -BeTrue
        $p['source'] | Should -Be 'b/{kebab}.md'
    }

    It 'throws when glob is missing' {
        { [Catzc.Base.Docs.DocPattern]::new(@{ source = 'b/{kebab}.md' }) } | Should -Throw '*glob is required*'
    }

    It 'throws when source is missing' {
        { [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'a/*' }) } | Should -Throw '*source is required*'
    }
}
