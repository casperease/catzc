<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1
    name: remove-markdown-front-matter
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.MarkdownMeta/tests/Remove-MarkdownFrontMatter.Tests.ps1
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
