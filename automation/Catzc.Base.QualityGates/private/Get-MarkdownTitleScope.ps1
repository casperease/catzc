<#
.SYNOPSIS
    Lists the repository-relative Markdown files whose title is their path.
.DESCRIPTION
    A gitignored generated README is out of scope while its tracked source is in, because only tracked files count.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleScope.ps1.md#comment1)
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

    # Get-ContentExemptPath returns one array, so it is assigned first and the set holds paths, not the array.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleScope.ps1.md#comment2)
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $markdown
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path $markdown -Attribute catzc-path-title
    , [string[]] @($markdown | Where-Object {
            $classes = $attributes[$_]
            -not $exempt.Contains($_) -and -not ($classes -and $classes['catzc-path-title'] -eq 'unset')
        })
}
