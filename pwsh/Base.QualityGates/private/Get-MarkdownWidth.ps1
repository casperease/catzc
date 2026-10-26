<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-MarkdownWidth.ps1.md"
  header: "generated"
---
#>

function Get-MarkdownWidth {
    [CmdletBinding()]
    [OutputType([int])]
    param()

    # The one declaration Build-WidthConfigs renders into prettier's printWidth, so a written page is born in the formatter's shape.
    $width = (Get-Config -Config file-limits).Resolve('markdown').width
    Assert-True ($null -ne $width) -ErrorText 'Get-MarkdownWidth: file-limits.yml resolves no width for markdown.'
    [int] $width
}
