<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/tests/types/DocMapping.Tests.ps1
    folder: tests/types
    name: doc-mapping-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/tests/types/DocMapping.Tests.ps1.md
---
#>

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
