<#
.SYNOPSIS
    Turns the optional files or folders of a scope into the repository-relative paths git is asked about.
.DESCRIPTION
    No path means the whole repository; a path outside the repository root is refused.
.PARAMETER RepositoryRoot
    The repository root the returned paths are relative to.
.PARAMETER Path
    Optional files or folders (absolute or relative to the current location).
.PARAMETER Command
    The name of the calling command, for the refusal message.
.OUTPUTS
    [string[]] repository-relative, '/'-separated paths, or '.' for the whole repository.
#>
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
    $lookup = foreach ($item in $Path) {
        $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
        $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
        Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "${Command}: -Path '$item' lies outside the repository '$root'."
        $relative
    }
    , [string[]] @($lookup)
}
