<#
.SYNOPSIS
    Composes a generated README: its source article, links rebased to the README's folder, under a line naming the source.
.DESCRIPTION
    The source link line goes after the source's title when it has one, else at the top of the README. The source's front matter,
    its meta block included, is left out of the copy, and the README opens with its own meta block, `kind: generated-from-source`.
    [ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)
    [comment:1](/docs/references/automation/catzc-base-docs/private/Get-ReadmeContent.ps1.md#comment1)
.PARAMETER Mapping
    One readme.yml mapping as Get-ReadmeMappings returns it ({ folder; source }, repository-relative).
.OUTPUTS
    [string] The README's content (LF line endings).
#>
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
    $banner = "> Generated from [$($Mapping.source)]($sourceLink) — edit the source; this copy is rewritten on every import."

    # The copy's own meta block says what it is, in the shape every meta block has, so a tool can tell it from an authored file.
    $meta = "---`ncatzc:`n  derived:`n    kind: generated-from-source`n---`n`n"

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
