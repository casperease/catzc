<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-markdown-meta/Remove-MarkdownFrontMatter.ps1.md"
  warning: "Generated Header"
---
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
