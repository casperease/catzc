<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/tests/Format-MarkdownMetaBlock.Tests.ps1
    folder: tests
    name: format-markdown-meta-block-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

Describe 'Format-MarkdownMetaBlock' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    It 'creates front matter above a text with none' {
        Format-MarkdownMetaBlock -Text "# docs/widget.md`n" -Fact ([ordered]@{ kind = 'gadget' }) |
            Should -BeExactly "---`ncatzc:`n  derived:`n    kind: gadget`n---`n`n# docs/widget.md`n"
    }

    It 'replaces the derived part and keeps the authored config and the other front matter' {
        $text = "---`nname: widget`ncatzc:`n  derived:`n    kind: old`n  config:`n    gadgets:`n      one: 1`n---`nbody`n"
        Format-MarkdownMetaBlock -Text $text -Fact ([ordered]@{ kind = 'gadget'; adrs = @('ADR-WIDGET#1') }) |
            Should -BeExactly "---`nname: widget`ncatzc:`n  derived:`n    kind: gadget`n    adrs:`n      - ADR-WIDGET#1`n  config:`n    gadgets:`n      one: 1`n---`nbody`n"
    }

    It 'returns identical text when the facts are the ones already written' {
        $once = Format-MarkdownMetaBlock -Text "# docs/widget.md`n" -Fact ([ordered]@{ kind = 'gadget'; body_sha = '3fa91c0d2b7e' })
        Format-MarkdownMetaBlock -Text $once -Fact ([ordered]@{ kind = 'gadget'; body_sha = '3fa91c0d2b7e' }) | Should -BeExactly $once
    }

    It 'removes the block when there are no facts and no config' {
        $text = "---`nname: widget`ncatzc:`n  derived:`n    kind: gadget`n---`nbody`n"
        Format-MarkdownMetaBlock -Text $text | Should -BeExactly "---`nname: widget`n---`nbody`n"
    }

    It 'keeps CRLF line endings' {
        Format-MarkdownMetaBlock -Text "---`r`nname: widget`r`n---`r`nbody`r`n" -Fact ([ordered]@{ kind = 'gadget' }) |
            Should -BeExactly "---`r`nname: widget`r`ncatzc:`r`n  derived:`r`n    kind: gadget`r`n---`r`nbody`r`n"
    }
}
