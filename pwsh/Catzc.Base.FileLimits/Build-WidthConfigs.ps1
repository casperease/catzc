<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-file-limits/Build-WidthConfigs.ps1.md"
  header: "generated"
---
#>

function Build-WidthConfigs {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('.editorconfig', '.prettierrc.yml', '.markdownlint.yml')]
        [string] $Target
    )

    $template = Get-CatzcModuleRoot "assets/root/$Target" -Module Catzc.Base.RootConfig
    Assert-PathExist $template -PathType Leaf -ErrorText "Build-WidthConfigs: no template for '$Target' at '$template'."
    $text = [System.IO.File]::ReadAllText($template)
    $widths = @{}
    # A token names an extension, so each tool's width is the one file-limits.yml declares for the files it formats.
    [regex]::Replace($text, '\$width(?<extension>\.[A-Za-z0-9]+)', {
            param($match)
            $extension = $match.Groups['extension'].Value
            if (-not $widths.ContainsKey($extension)) {
                $widths[$extension] = (Get-FileLimit -Path "width$extension").width
                if ($null -eq $widths[$extension]) {
                    throw "Build-WidthConfigs: file-limits.yml declares no width for '$extension' files, which '$Target' names."
                }
            }
            "$($widths[$extension])"
        })
}
