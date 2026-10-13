<#
.SYNOPSIS
    Composes a generated README: its source article, links rebased to the README's folder, under a line naming the source.
.DESCRIPTION
    The one composer behind Build-Readme (the writer) and Test-GeneratedReadmes (the quality gate). The source's relative links
    are rebased from the source's folder to the README's (MarkdownLinkRebaser), so every link works where the README is
    opened; a line under the title links back to the source as the one place to edit
    ([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)). The line goes after the
    source's '# ' title when it opens with one, else at the top.
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
    $text = [System.IO.File]::ReadAllText($sourcePath) -replace "`r", ''
    $body = [Catzc.Base.Docs.MarkdownLinkRebaser]::Rebase($text, $Mapping.source, $Mapping.folder)

    $sourceLink = [Catzc.Base.Docs.MarkdownLinkRebaser]::RelativeLink($Mapping.folder, $Mapping.source)
    $banner = "> Generated from [$($Mapping.source)]($sourceLink) — edit the source; this copy is rewritten on every import."

    $lines = @($body -split "`n", 2)
    if (-not $lines[0].StartsWith('# ')) {
        return "$banner`n`n$body"
    }
    $rest = ''
    if ($lines.Count -gt 1) {
        $rest = $lines[1]
    }
    "$($lines[0])`n`n$banner`n$rest"
}
