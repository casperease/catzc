<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/types/DocMapping.Tests.ps1
    kind: pester-test
---
#>

# Validates the compiled DocMapping type directly — the constructor is the gate that stops a malformed readme.yml...
# [comment:1](/docs/references/automation/catzc-base-docs/tests/types/DocMapping.Tests.ps1.md#comment1)
Describe 'DocMapping' -Tag 'L0', 'logic' {
    It 'constructs and exposes folder + source' {
        $m = [Catzc.Base.Docs.DocMapping]::new(@{ folder = 'automation/Catzc.Fixture'; source = 'docs/readme/foo.md' })
        $m.folder | Should -Be 'automation/Catzc.Fixture'
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
        { [Catzc.Base.Docs.DocMapping]::new(@{ folder = 'automation/Catzc.Fixture' }) } | Should -Throw '*source is required*'
    }
}
