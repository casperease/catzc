<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/private/Get-ReadmeContent.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Docs
    visibility: private
    adrs:
      - ADR-REPO-README#6
  config:
    synopsis: 'Composes a generated README: its source article, links rebased to the README''s folder, under a line naming the source.'
    description: |-
      The source link line goes after the source's title when it has one, else at the top of the README. The source's front matter,
      The one composer behind Build-Readme (the writer) and Test-GeneratedReadmes (the quality gate). The source's relative links
      are rebased from the source's folder to the README's (MarkdownLinkRebaser), so every link works where the README is
      opened; a line under the title links back to the source as the one place to edit
      ([ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)). The line goes after the
      source's '# ' title when it opens with one, else at the top. The copy opens with its own meta block,
      `kind: generated-from-source`, above both.
    parameters:
      Mapping: One readme.yml mapping as Get-ReadmeMappings returns it ({ folder; source }, repository-relative).
    outputs: '[string] The README''s content (LF line endings).'
---
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
    $banner = "> Generated from [$($Mapping.source)]($sourceLink) — edit the source;"

    # The copy's own meta block says what it is, in the shape every meta block has, so a tool can tell it from an authored file.
    $meta = "---`ncatzc:`n  derived:`n    kind: $((Get-Config -Config generated-head).tracked_kind)`n---`n`n"

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
