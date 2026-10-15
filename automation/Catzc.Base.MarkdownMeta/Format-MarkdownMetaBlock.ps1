<#
.SYNOPSIS
    Returns a Markdown text with its meta block imprinted from the given facts
    ([ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
.DESCRIPTION
    The `derived` part is written from -Fact in the order given, one canonical form, so the same facts always give the same bytes.
    The authored `config` part and every other byte of the text are kept as written. With no facts and no config lines the block is
    removed. Pure: it reads no file and no config, and it returns the text rather than writing it.
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
