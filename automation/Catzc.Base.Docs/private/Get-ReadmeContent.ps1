function Get-ReadmeContent {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [object] $Mapping
    )

    $sourcePath = Resolve-RepoPath $Mapping.source
    Assert-PathExist $sourcePath -PathType Leaf
    # The copy carries the article, not the source's meta block, so it opens with its title as a reader expects.
    $text = Remove-MarkdownFrontMatter -Text ([System.IO.File]::ReadAllText($sourcePath) -replace "`r", '')
    $body = [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase($text, $Mapping.source, $Mapping.folder)

    $sourceLink = [Catzc.Base.Docs.MarkdownLinkRebaser]::RelativeLink($Mapping.folder, $Mapping.source)
    $banner = "> Generated from [$($Mapping.source)]($sourceLink) — edit the source;"

    # The copy's own meta block says what it is, in the shape every meta block has, so a tool can tell it from an authored file.
    $meta = "---`ncatzc:`n  immutable:`n    kind: $((Get-FileKind "$($Mapping.folder)/README.md").kind)`n---`n`n"

    $lines = @($body -split "`n", 2)
    if (-not $lines[0].StartsWith('# ')) {
        return "$meta$banner`n`n$body"
    }
    $rest = ''
    if ($lines.Count -gt 1) {
        $rest = $lines[1]
    }
    "$meta$($lines[0])`n`n$banner`n$rest"
}
