function Get-ScopeLookup {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $Command
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    if (-not $Path) {
        return , [string[]] @('.')
    }
    # A relative path is the caller's own inside this repository, else the repository's: a snapshot run stands elsewhere.
    $here = (Get-Location).ProviderPath
    $hereRelative = [System.IO.Path]::GetRelativePath($root, $here) -replace '\\', '/'
    $base = if ($hereRelative -eq '..' -or $hereRelative.StartsWith('../') -or
        [System.IO.Path]::IsPathRooted($hereRelative)) {
        $root
    }
    else {
        $here
    }
    $lookup = foreach ($item in $Path) {
        $full = [System.IO.Path]::GetFullPath($item, $base)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        Assert-False ($relative -eq '..' -or
            $relative.StartsWith('../')) -ErrorText "${Command}: -Path '$item' lies outside the repository '$root'."
        # A listed path the tree has lost, an unstaged deletion, stays in scope; the reader skips it.
        if (-not (Test-Path -LiteralPath $full)) {
            Assert-True (@(Get-GitTrackedPath $relative).Count -gt 0) -ErrorText "${Command}: -Path '$item' does not exist and is not tracked."
        }
        $relative
    }
    , [string[]] @($lookup)
}
