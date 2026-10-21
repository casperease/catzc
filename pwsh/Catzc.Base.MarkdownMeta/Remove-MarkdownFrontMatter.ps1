<#
---
catzc:
  immutable:
    with_body_sha: "0cbe5abf6779"
  edges:
    test: pwsh/Catzc.Base.MarkdownMeta/tests/Remove-MarkdownFrontMatter.Tests.ps1
    docs: "[Remove-MarkdownFrontMatter.ps1.md](docs/references/pwsh/catzc-base-markdown-meta/Remove-MarkdownFrontMatter.ps1.md)"
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
