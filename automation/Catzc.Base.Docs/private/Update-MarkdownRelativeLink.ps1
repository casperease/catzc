<#
.SYNOPSIS
    Rebases the relative links in markdown content from a source location to a target location.
.DESCRIPTION
    A copy-in README is generated in a different folder than its authored source, so a relative link that
    was correct at the source (`../../adr/...`, a sibling `catzc-*.md`) would point to the wrong place in the
    generated file. This rebases every inline link and image target so it resolves to the SAME file from the
    target folder: it resolves the link against the source directory, then re-expresses it relative to the
    target directory. Pure path arithmetic ([System.IO.Path]), so no file needs to exist.

    Left untouched: in-page anchors (`#...`), external URLs (any `scheme:`), and root-absolute paths (`/...`).
    A trailing `#fragment` / `?query` and an optional link title are preserved. Reference-style link
    definitions are not rebased — the reference docs use inline links only.
.PARAMETER Content
    The markdown text to rewrite.
.PARAMETER SourceDirectory
    The authored source file's directory, repository-root-relative and forward-slashed (e.g.
    'docs/references/automation').
.PARAMETER TargetDirectory
    The generated README's directory, repository-root-relative and forward-slashed (e.g.
    'automation/Catzc.Base.Repository').
.PARAMETER RepositoryRoot
    The absolute repository root, used only as the anchor for the (existence-free) path arithmetic.
#>
function Update-MarkdownRelativeLink {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Content,

        [Parameter(Mandatory)]
        [string] $SourceDirectory,

        [Parameter(Mandatory)]
        [string] $TargetDirectory,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $sourceAbsoluteDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($RepositoryRoot, $SourceDirectory))
    $targetAbsoluteDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($RepositoryRoot, $TargetDirectory))

    # Inline links and images: [text](target) or ![alt](target).
    $pattern = '(!?\[[^\]]*\])\(([^)]+)\)'

    $ret = [System.Text.StringBuilder]::new()
    $cursor = 0
    foreach ($match in [regex]::Matches($Content, $pattern)) {
        [void] $ret.Append($Content.Substring($cursor, $match.Index - $cursor))
        $cursor = $match.Index + $match.Length

        $label = $match.Groups[1].Value
        $inside = $match.Groups[2].Value

        # Separate the URL token from an optional title (`(path "title")`).
        $urlToken = $inside
        $title = ''
        if ($inside -match '^(\S+)(\s.*)$') {
            $urlToken = $Matches[1]
            $title = $Matches[2]
        }

        # Leave external URLs, in-page anchors, and root-absolute paths untouched.
        $isExternal = $urlToken -match '^[A-Za-z][A-Za-z0-9+.\-]*:' -or $urlToken.StartsWith('#') -or $urlToken.StartsWith('/')
        if ($isExternal) {
            [void] $ret.Append($match.Value)
            continue
        }

        # Separate a trailing #fragment or ?query from the file path.
        $filePart = $urlToken
        $suffix = ''
        $breakIndex = $urlToken.IndexOfAny([char[]] @('#', '?'))
        if ($breakIndex -ge 0) {
            $filePart = $urlToken.Substring(0, $breakIndex)
            $suffix = $urlToken.Substring($breakIndex)
        }
        if ([string]::IsNullOrEmpty($filePart)) {
            [void] $ret.Append($match.Value)
            continue
        }

        # Resolve against the source directory, then re-express relative to the target directory.
        $absoluteTarget = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($sourceAbsoluteDirectory, $filePart))
        $rebased = [System.IO.Path]::GetRelativePath($targetAbsoluteDirectory, $absoluteTarget).Replace('\', '/')

        [void] $ret.Append("$label($rebased$suffix$title)")
    }
    [void] $ret.Append($Content.Substring($cursor))
    $ret.ToString()
}
