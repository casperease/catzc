<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/Get-MarkdownMetaState.ps1
    kind: automation-function
    module: Catzc.Base.MarkdownMeta
    visibility: public
    adrs:
      - ADR-REPO-FILEMETA#1
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: Reads what a Markdown text says about its own meta block, without changing it.
    description: |-
      Pure: it takes the text, reads no file and no config. The body is what follows the front matter, and its hash drops the
      blank line that separates written front matter from it, so imprinting never changes the hash it records
      ([ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
    parameters:
      Text: The whole Markdown file as text.
    outputs: |-
      [pscustomobject] @{ HasFrontMatter; HasMetaBlock; Body; BodyHash; Sections; DerivedKeys; ConfigLines } — Sections are the keys
      directly under `catzc`, DerivedKeys the keys under `derived`, and ConfigLines the authored lines under `config`, as written.
    examples:
      - (Get-MarkdownMetaState -Text $text).BodyHash
---
#>

function Get-MarkdownMetaState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text
    )

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text)
    $block = $document.MetaBlock
    [pscustomobject]@{
        HasFrontMatter = $document.HasFrontMatter
        HasMetaBlock   = $document.HasMetaBlock
        Body           = $document.Body
        BodyHash       = $document.BodyHash()
        Sections       = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::SectionKeys($block))
        DerivedKeys    = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::DerivedKeys($block))
        ConfigLines    = [string[]] @([Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($block))
    }
}
