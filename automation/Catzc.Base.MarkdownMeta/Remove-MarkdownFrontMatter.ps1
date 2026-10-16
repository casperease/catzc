<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.MarkdownMeta/Remove-MarkdownFrontMatter.ps1
    name: remove-markdown-front-matter
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.MarkdownMeta/tests/Remove-MarkdownFrontMatter.Tests.ps1
  config:
    synopsis: Returns a Markdown text without its YAML front matter.
    description: |-
      For a copy that carries the content but not the file's meta: a generated README, which a reader opens with its title first. The
      blank line that separates written front matter from the body goes with it. A text with no front matter comes back unchanged.
      Pure: it reads no file and no config.
    parameters:
      Text: The whole Markdown file as text.
    outputs: '[string] the text from its first body line on.'
    examples:
      - Remove-MarkdownFrontMatter -Text $text
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
