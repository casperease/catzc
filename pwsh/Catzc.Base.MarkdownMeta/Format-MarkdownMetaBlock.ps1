<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.MarkdownMeta/Format-MarkdownMetaBlock.ps1
    name: format-markdown-meta-block
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.MarkdownMeta/tests/Format-MarkdownMetaBlock.Tests.ps1
    docs: "[Format-MarkdownMetaBlock.ps1.md](docs/references/pwsh/catzc-base-markdownmeta/Format-MarkdownMetaBlock.ps1.md)"
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
