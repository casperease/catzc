<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-docs/tests/types/DocMapping.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'DocMapping' -Tag 'L0', 'logic' {
    It 'constructs and exposes folder + source' {
        $m = [Catzc.Base.Docs.DocMapping]::new(@{ folder = 'widgets/Catzc.Fixture'; source = 'docs/readme/foo.md' })
        $m.folder | Should -Be 'widgets/Catzc.Fixture'
        $m.source | Should -Be 'docs/readme/foo.md'
    }

    It 'presents as a read-only dictionary (DictionaryRecord)' {
        $m = [Catzc.Base.Docs.DocMapping]::new(@{ folder = 'a'; source = 'b' })
        $m.Contains('folder') | Should -BeTrue
        $m['source'] | Should -Be 'b'
    }

    It 'throws when folder is missing' {
        { [Catzc.Base.Docs.DocMapping]::new(@{ source = 'docs/readme/foo.md' }) } | Should -Throw '*folder is required*'
    }

    It 'throws when source is missing' {
        { [Catzc.Base.Docs.DocMapping]::new(@{ folder = 'widgets/Catzc.Fixture' }) } |
            Should -Throw '*source is required*'
    }
}
