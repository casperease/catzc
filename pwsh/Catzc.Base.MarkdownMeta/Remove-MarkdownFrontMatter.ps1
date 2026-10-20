<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1
    name: remove-markdown-front-matter
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.MarkdownMeta/tests/Remove-MarkdownFrontMatter.Tests.ps1
    docs: "[Remove-MarkdownFrontMatter.ps1.md](docs/references/pwsh/catzc-base-markdownmeta/Remove-MarkdownFrontMatter.ps1.md)"
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
