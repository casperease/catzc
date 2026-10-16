<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.MarkdownMeta/tests/Get-MarkdownMetaState.Tests.ps1
    folder: tests
    name: get-markdown-meta-state-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#1
---
#>

Describe 'Get-MarkdownMetaState' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#1' {
    It 'reports no front matter and no meta block for a plain file' {
        $state = Get-MarkdownMetaState -Text "# docs/widget.md`n`nbody`n"
        $state.HasFrontMatter | Should -BeFalse
        $state.HasMetaBlock | Should -BeFalse
        $state.Body | Should -BeExactly "# docs/widget.md`n`nbody`n"
        @($state.Sections).Count | Should -Be 0
        @($state.ImmutableKeys).Count | Should -Be 0
        @($state.EdgeKeys).Count | Should -Be 0
    }

    It 'reads the sections, the place keys, the edge names and the authored config lines of a meta block' {
        $text = "---`nname: widget`ncatzc:`n  immutable:`n    kind: gadget`n  edges:`n    cites:`n      - ADR-WIDGET#1`n  config:`n    gadgets:`n      one: 1`n  other: 2`n---`nbody`n"
        $state = Get-MarkdownMetaState -Text $text
        $state.HasFrontMatter | Should -BeTrue
        $state.HasMetaBlock | Should -BeTrue
        $state.Sections | Should -Be @('immutable', 'edges', 'config', 'other')
        $state.ImmutableKeys | Should -Be @('kind')
        $state.EdgeKeys | Should -Be @('cites')
        $state.ConfigLines | Should -Be @('    gadgets:', '      one: 1')
        $state.Body | Should -BeExactly "body`n"
    }

    It 'does not count a key of another front matter field' {
        $state = Get-MarkdownMetaState -Text "---`nname: widget`ntools: Bash`n---`nbody`n"
        $state.HasFrontMatter | Should -BeTrue
        $state.HasMetaBlock | Should -BeFalse
        @($state.ImmutableKeys).Count | Should -Be 0
    }

    It 'gives a hash that ignores the front matter and the blank line after it' {
        $plain = (Get-MarkdownMetaState -Text "# docs/widget.md`n`nbody`n").BodyHash
        $framed = (Get-MarkdownMetaState -Text "---`ncatzc:`n  immutable:`n    kind: gadget`n---`n`n# docs/widget.md`n`nbody`n").BodyHash
        $framed | Should -BeExactly $plain
        $plain | Should -Match '^[0-9a-f]{12}$'
    }

    It 'accepts an empty text' {
        (Get-MarkdownMetaState -Text '').HasFrontMatter | Should -BeFalse
    }
}
