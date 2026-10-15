<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/Format-MarkdownMetaBlock.ps1
    kind: function
    module: Catzc.Base.MarkdownMeta
    visibility: public
    adrs:
      - ADR-REPO-FILEMETA#3
---
#>

<#
.SYNOPSIS
    Returns a Markdown text with its meta block imprinted from the given facts.
.DESCRIPTION
    The same facts always give the same bytes, so a second run changes no file and prettier never undoes the block.
    [comment:1](/docs/references/automation/catzc-base-markdownmeta/Format-MarkdownMetaBlock.ps1.md#comment1)
.PARAMETER Text
    The whole Markdown file as text.
.PARAMETER Fact
    The derived facts, an ordered dictionary of key to value; a value is a scalar or a list of scalars.
.OUTPUTS
    [string] the whole text, with the meta block replaced.
.EXAMPLE
    Format-MarkdownMetaBlock -Text $text -Fact ([ordered]@{ kind = 'adr'; body_sha = '3fa91c0d2b7e' })
#>
function Format-MarkdownMetaBlock {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [System.Collections.IDictionary] $Fact = [ordered]@{}
    )

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text)
    $config = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($document.MetaBlock)
    $block = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($Fact, $config)
    $document.WithMetaBlock($block)
}
