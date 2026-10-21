<#
---
catzc:
  immutable:
    with_body_sha: "8b628a6a7229"
  edges:
    test: pwsh/Catzc.Base.MarkdownMeta/tests/Format-MarkdownMetaBlock.Tests.ps1
    docs: "[Format-MarkdownMetaBlock.ps1.md](docs/references/pwsh/catzc-base-markdown-meta/Format-MarkdownMetaBlock.ps1.md)"
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
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
