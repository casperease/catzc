<#
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/tests/types/HeadForm.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-CODEMETA#1
---
#>

Describe 'HeadForm' -Tag 'L0', 'logic', 'ADR-REPO-CODEMETA#1' {
    It 'is a line-comment form or a block-comment form, anchored at the start by default' {
        $line = [Catzc.Base.CodeMeta.HeadForm]::ForLine('#')
        $line.Line | Should -Be '#'
        $line.IsBlock | Should -BeFalse
        $line.Anchor | Should -Be ([Catzc.Base.CodeMeta.HeadAnchor]::Start)
        $line.PreambleLines | Should -Be 0
        $block = [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<!--', '-->', [Catzc.Base.CodeMeta.HeadAnchor]::AfterProlog)
        $block.IsBlock | Should -BeTrue
        $block.BlockOpen | Should -Be '<!--'
        $block.BlockClose | Should -Be '-->'
        $block.Line | Should -BeNullOrEmpty
        $block.Anchor | Should -Be ([Catzc.Base.CodeMeta.HeadAnchor]::AfterProlog)
    }

    It 'lists the old head openers the formatter strips, none by default' {
        ([Catzc.Base.CodeMeta.HeadForm]::ForLine('#')).Strip.Count | Should -Be 0
        ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/', [Catzc.Base.CodeMeta.HeadAnchor]::Start, 0, [string[]] @('// catzc:'))).Strip | Should -Be @('// catzc:')
    }

    It 'takes a fixed number of preamble lines only with the anchor that needs them' {
        ([Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterPreamble, 2)).PreambleLines | Should -Be 2
        { [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::AfterPreamble, 0) } | Should -Throw '*preambleLines is required, and only allowed*'
        { [Catzc.Base.CodeMeta.HeadForm]::ForLine('#', [Catzc.Base.CodeMeta.HeadAnchor]::Start, 2) } | Should -Throw '*preambleLines is required, and only allowed*'
    }

    It 'rejects an empty or spaced comment syntax' {
        { [Catzc.Base.CodeMeta.HeadForm]::ForLine('') } | Should -Throw '*non-empty and has no spaces*'
        { [Catzc.Base.CodeMeta.HeadForm]::ForLine('# ') } | Should -Throw '*non-empty and has no spaces*'
        { [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<!--', '') } | Should -Throw '*opening and closing delimiter*'
        { [Catzc.Base.CodeMeta.HeadForm]::ForBlock('<!-- x', '-->') } | Should -Throw '*opening and closing delimiter*'
    }
}
