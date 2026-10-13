<#
.SYNOPSIS
    Lists the repository-relative Markdown files whose title is their path.
.DESCRIPTION
    Every git-tracked *.md file — the repository as committed, so a gitignored generated README is never in scope while
    its tracked source is — minus the classes .gitattributes declares: linguist-vendored and linguist-generated (not
    authored here), catzc-fixture (test fixture trees, data on purpose), and -catzc-path-title (a file that keeps its
    own title, the repository landing page). No list of its own: a new exception is declared in the .gitattributes
    source like every other file class.
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location) to limit the scope to.
.OUTPUTS
    [string[]] repository-relative, '/'-separated paths.
#>
function Get-MarkdownTitleScope {
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
            Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "Get-MarkdownTitleScope: -Path '$item' lies outside the repository '$root'."
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

    # Every class comes from .gitattributes.
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $markdown -Attribute linguist-vendored, linguist-generated, catzc-fixture, catzc-path-title
    , [string[]] @($markdown | Where-Object {
            $classes = $attributes[$_]
            -not $classes -or -not (
                $classes['linguist-vendored'] -in 'set', 'true' -or
                $classes['linguist-generated'] -in 'set', 'true' -or
                $classes['catzc-fixture'] -in 'set', 'true' -or
                $classes['catzc-path-title'] -eq 'unset')
        })
}
