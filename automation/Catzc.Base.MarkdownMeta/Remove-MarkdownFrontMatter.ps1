<#
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1
    kind: function
    module: Catzc.Base.MarkdownMeta
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns a Markdown text without its YAML front matter.
.DESCRIPTION
    A generated README copies the content but not the source's meta block, so a reader opens it at its title.
    [comment:1](/docs/references/automation/catzc-base-markdownmeta/Remove-MarkdownFrontMatter.ps1.md#comment1)
.PARAMETER Text
    The whole Markdown file as text.
.OUTPUTS
    [string] the text from its first body line on.
.EXAMPLE
    Remove-MarkdownFrontMatter -Text $text
#>
function Remove-MarkdownFrontMatter {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Text
    )

    $document = [Catzc.Base.MarkdownMeta.MarkdownDocument]::Parse($Text)
    if (-not $document.HasFrontMatter) {
        return $Text
    }
    $document.Body.TrimStart("`r", "`n")
}
