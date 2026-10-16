<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/tests/Remove-MarkdownFrontMatter.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.MarkdownMeta
    relatives:
      source: automation/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1
    adrs:
      - ADR-REPO-FILEMETA#1
---
#>

Describe 'Remove-MarkdownFrontMatter' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#1' {
    It 'returns the text from its first body line, dropping the blank line after written front matter' {
        Remove-MarkdownFrontMatter -Text "---`ncatzc:`n  derived:`n    kind: gadget`n---`n`n# docs/widget.md`n`nbody`n" |
            Should -BeExactly "# docs/widget.md`n`nbody`n"
    }

    It 'drops front matter that is not the meta block too' {
        Remove-MarkdownFrontMatter -Text "---`nname: widget`n---`nbody`n" | Should -BeExactly "body`n"
    }

    It 'returns a text with no front matter unchanged' -ForEach @(
        @{ Text = "# docs/widget.md`n`nbody`n" }
        @{ Text = "`n`nleading blank lines stay`n" }
        @{ Text = '' }
    ) {
        Remove-MarkdownFrontMatter -Text $Text | Should -BeExactly $Text
    }

    It 'does not treat a thematic break in the body as front matter' {
        $text = "# docs/widget.md`n`n---`nnot front matter`n---`n"
        Remove-MarkdownFrontMatter -Text $text | Should -BeExactly $text
    }
}
