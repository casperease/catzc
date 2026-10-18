Describe 'Format-MarkdownMetaBlock' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#3' {
    It 'creates front matter above a text with none' {
        Format-MarkdownMetaBlock -Text "# docs/widget.md`n" -Immutable ([ordered]@{ kind = 'gadget' }) |
            Should -BeExactly "---`ncatzc:`n  immutable:`n    kind: gadget`n---`n`n# docs/widget.md`n"
    }

    It 'replaces the immutable and edges parts and keeps the authored config and the other front matter' {
        $text = "---`nname: widget`ncatzc:`n  immutable:`n    kind: old`n  edges:`n    cites:`n      - ADR-OLD#1`n  config:`n    gadgets:`n      one: 1`n---`nbody`n"
        Format-MarkdownMetaBlock -Text $text -Immutable ([ordered]@{ kind = 'gadget' }) -Edges ([ordered]@{ cites = @('ADR-WIDGET#1') }) |
            Should -BeExactly "---`nname: widget`ncatzc:`n  immutable:`n    kind: gadget`n  edges:`n    cites:`n      - ADR-WIDGET#1`n  config:`n    gadgets:`n      one: 1`n---`nbody`n"
    }

    It 'returns identical text when the facts are the ones already written' {
        $immutable = [ordered]@{ with_body_sha = '3fa91c0d2b7e'; kind = 'gadget' }
        $edges = [ordered]@{ links = @('docs/gadget.md') }
        $once = Format-MarkdownMetaBlock -Text "# docs/widget.md`n" -Immutable $immutable -Edges $edges
        Format-MarkdownMetaBlock -Text $once -Immutable $immutable -Edges $edges | Should -BeExactly $once
    }

    It 'removes the block when there are no facts, no edges and no config' {
        $text = "---`nname: widget`ncatzc:`n  immutable:`n    kind: gadget`n---`nbody`n"
        Format-MarkdownMetaBlock -Text $text | Should -BeExactly "---`nname: widget`n---`nbody`n"
    }

    It 'nests the block at the key path the carrier names, and keeps its authored config there' -Tag 'ADR-REPO-FILEMETA#1' {
        $text = "---`nname: widget`nmetadata:`n  catzc:`n    immutable:`n      kind: old`n    config:`n      floor: low`n---`nbody`n"
        Format-MarkdownMetaBlock -Text $text -Immutable ([ordered]@{ kind = 'gadget' }) -Key 'metadata.catzc' |
            Should -BeExactly "---`nname: widget`nmetadata:`n  catzc:`n    immutable:`n      kind: gadget`n    config:`n      floor: low`n---`nbody`n"
        Format-MarkdownMetaBlock -Text "---`nname: widget`n---`nbody`n" -Immutable ([ordered]@{ kind = 'gadget' }) -Key 'metadata.catzc' |
            Should -BeExactly "---`nname: widget`nmetadata:`n  catzc:`n    immutable:`n      kind: gadget`n---`nbody`n"
        { Format-MarkdownMetaBlock -Text "---`nmetadata: { a: 1 }`n---`nbody`n" -Immutable ([ordered]@{ kind = 'gadget' }) -Key 'metadata.catzc' } |
            Should -Throw "*'metadata' holds a flow or scalar value*"
    }

    It 'keeps CRLF line endings' {
        Format-MarkdownMetaBlock -Text "---`r`nname: widget`r`n---`r`nbody`r`n" -Immutable ([ordered]@{ kind = 'gadget' }) |
            Should -BeExactly "---`r`nname: widget`r`ncatzc:`r`n  immutable:`r`n    kind: gadget`r`n---`r`nbody`r`n"
    }
}
