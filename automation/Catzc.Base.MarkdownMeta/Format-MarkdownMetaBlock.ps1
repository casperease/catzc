<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/Format-MarkdownMetaBlock.ps1
    kind: function
    subkind: formatter
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Base.MarkdownMeta/tests/Format-MarkdownMetaBlock.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: Returns a Markdown text with its meta block imprinted from the given facts.
    description: |-
      The `derived` part is written from -Fact in the order given, one canonical form, so the same facts always give the same bytes.
      The authored `config` part and every other byte of the text are kept as written. With no facts and no config lines the block is
      removed. Pure: it reads no file and no config, and it returns the text rather than writing it.
    parameters:
      Text: The whole Markdown file as text.
      Fact: The derived facts, an ordered dictionary of key to value; a value is a scalar or a list of scalars.
    outputs: '[string] the whole text, with the meta block replaced.'
    examples:
      - Format-MarkdownMetaBlock -Text $text -Fact ([ordered]@{ kind = 'adr'; body_sha = '3fa91c0d2b7e' })
---
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
