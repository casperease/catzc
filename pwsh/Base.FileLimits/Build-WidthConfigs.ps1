function Build-WidthConfigs {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet('.editorconfig', '.prettierrc.yml', '.markdownlint.yml')]
        [string] $Target
    )

    $template = Join-Path (Get-CatzcModuleRoot 'assets/root' -Module Catzc.Base.RootConfig) $Target
    Assert-PathExist $template -PathType Leaf -ErrorText "Build-WidthConfigs: no template for '$Target' at '$template'."
    $text = [System.IO.File]::ReadAllText($template)
    $widths = @{}
    # A token names an extension, so each tool's width is the one file-limits.yml declares for the files it formats.
    [regex]::Replace($text, '[$]width(?<extension>[.][A-Za-z0-9]+)', {
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
