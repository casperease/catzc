<#
---
catzc:
  immutable:
    with_body_sha: "3d0167c5e940"
  edges:
    docs: "[DocPattern.Tests.ps1.md](../../../../docs/references/pwsh/catzc-base-docs/tests/types/DocPattern.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/types/DocPattern.cs
---
#>

Describe 'DocPattern' -Tag 'L0', 'logic' {
    It 'constructs and exposes glob + source' {
        $p = [Catzc.Base.Docs.DocPattern]::new(@{ glob = 'widgets/*'; source = 'docs/references/pwsh/{kebab}.md' })
        $p.glob | Should -Be 'widgets/*'
        $p.source | Should -Be 'docs/references/pwsh/{kebab}.md'
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
