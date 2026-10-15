<#
.SYNOPSIS
    Lists the repository-relative Markdown files that carry a meta block
    ([ADR-REPO-MDMETA#5](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta5)).
.DESCRIPTION
    The file class of the Markdown title, less the files `.gitattributes` marks `-catzc-meta`. Only tracked files count, so a
    gitignored generated README is out of scope while its tracked source is in.
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location) to limit the scope to.
.OUTPUTS
    [string[]] repository-relative, '/'-separated paths.
#>
function Get-MarkdownMetaScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $lookup = if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
            $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
            Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "Get-MarkdownMetaScope: -Path '$item' lies outside the repository '$root'."
            $relative
        }
    }
    else {
        '.'
    }

    $markdown = @(Get-GitTrackedPath $lookup | Where-Object { $_ -like '*.md' })
    if ($markdown.Count -eq 0) {
        return , [string[]] @()
    }

    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $markdown -Attribute catzc-meta
    , [string[]] @($markdown | Where-Object {
            $classes = $attributes[$_]
            -not $exempt.Contains($_) -and -not ($classes -and $classes['catzc-meta'] -eq 'unset')
        })
}
