<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.MarkdownMeta/Format-MarkdownMetaBlock.ps1
    name: format-markdown-meta-block
    filetype: ps1
    kind: function
    subkind: formatter
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.MarkdownMeta/tests/Format-MarkdownMetaBlock.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#3
  config:
    synopsis: Returns a Markdown text with its meta block imprinted from the given facts.
    description: |-
      The `immutable` and `edges` parts are written from -Immutable and -Edges in the order given, one canonical form, so the same facts
      always give the same bytes. The authored `config` part and every other byte of the text are kept as written. With no facts, no
      edges and no config lines the block is removed. Pure: it reads no file and no config, and it returns the text rather than writing it.
    parameters:
      Text: The whole Markdown file as text.
      Immutable: The place facts, an ordered dictionary of key to value; a value is a scalar.
      Edges: The outgoing edges, an ordered dictionary of edge name to value; a value is a scalar or a list of scalars.
      Key: 'The front-matter key path of the block: catzc at the top level (the default), or a dotted path such as metadata.catzc where the carrier nests it under another tool''s keys; a parent key the text lacks is written, a parent that holds a flow or scalar value is an error.'
    outputs: '[string] the whole text, with the meta block replaced.'
    examples:
      - Format-MarkdownMetaBlock -Text $text -Immutable ([ordered]@{ with_body_sha = '3fa91c0d2b7e'; kind = 'adr' }) -Edges ([ordered]@{ cites = @('ADR-WIDGET#1') })
---
#>

function Format-MarkdownMetaBlock {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text,

        [System.Collections.IDictionary] $Immutable = [ordered]@{},

        [System.Collections.IDictionary] $Edges = [ordered]@{},

        [ValidateNotNullOrEmpty()]
        [string] $Key = [Catzc.Base.MarkdownMeta.MarkdownDocument]::MetaKey
    )

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text, $Key)
    $config = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::ConfigLines($document.MetaBlock)
    $block = [Catzc.Base.MarkdownMeta.MarkdownMetaBlock]::Render($Immutable, $Edges, $config)
    $document.WithMetaBlock($block)
}
