<#
.SYNOPSIS
    Lists the repository-relative Markdown files whose title is their path.
.DESCRIPTION
    Every git-tracked *.md file — the repository as committed, so a gitignored generated file (a README link, the ADR
    index) is never in scope while its tracked source is — minus what the repository already declares is not
    authored here: the files .gitattributes marks linguist-vendored or linguist-generated, and the test fixture trees
    (**/tests/assets/**, data on purpose). No list of its own: a new exception is declared in the .gitattributes source
    like every other file class.
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

    $markdown = @(Get-GitTrackedPath $lookup | Where-Object { $_ -like '*.md' -and $_ -notmatch '(^|/)tests/assets/' })
    if ($markdown.Count -eq 0) {
        return , [string[]] @()
    }

    # The vendored and generated classes come from .gitattributes, in batches that keep each command line short.
    $excluded = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    for ($index = 0; $index -lt $markdown.Count; $index += 100) {
        $batch = $markdown[$index..([Math]::Min($index + 99, $markdown.Count - 1))]
        $quotedPaths = foreach ($item in $batch) {
            "`"$item`""
        }
        $listing = Invoke-Executable "git -C `"$root`" -c core.quotepath=off check-attr linguist-vendored linguist-generated -- $($quotedPaths -join ' ')" -PassThru -Silent
        foreach ($line in ($listing.Output -split "`r?`n")) {
            if ($line -match '^(?<path>.+): linguist-(vendored|generated): (set|true)$') {
                [void] $excluded.Add($Matches['path'])
            }
        }
    }

    , [string[]] @($markdown | Where-Object { -not $excluded.Contains($_) })
}
