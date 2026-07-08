<#
.SYNOPSIS
    Computes the durable content hash of a directory tree — the bundle's content-addressed identity.
.DESCRIPTION
    The same durable-SHA recipe the globsets use (ADR-GLOBS:5), applied to every file under -Path: per file a
    SHA-256 over its bytes with every CR stripped (so a CRLF vs LF tree yields the same identity on any
    machine), folded as <relative-path>|<digest> lines in ordinal path order, then one combined SHA-256 over
    the fold — 64 lowercase hex chars. The relative path is forward-slashed and taken from -Path, so the hash
    is stable wherever the tree is copied. This is the reproducibility proof an exported bundle carries
    (build twice from one commit -> identical hash).
.PARAMETER Path
    The root directory whose file tree to hash (recursively).
.PARAMETER Exclude
    Path-relative, forward-slashed file paths to omit from the hash — e.g. a build.json sidecar that itself
    carries the hash, so it cannot be part of the content it identifies.
.EXAMPLE
    Get-CatzcContentHash -Path (Join-Path (Get-OutputRoot) 'catzc/6.6.666') -Exclude 'build.json'
#>
function Get-CatzcContentHash {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [string[]] $Exclude = @()
    )

    Assert-PathExist $Path -PathType Container

    $rootFull = [System.IO.Path]::GetFullPath($Path)
    $files = [System.IO.Directory]::EnumerateFiles($rootFull, '*', [System.IO.SearchOption]::AllDirectories)

    $relativePaths = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        $relativePath = [System.IO.Path]::GetRelativePath($rootFull, $file).Replace('\', '/')
        if ($relativePath -notin $Exclude) {
            $relativePaths.Add($relativePath)
        }
    }
    $relativePaths.Sort([System.StringComparer]::Ordinal)

    $stringBuilder = [System.Text.StringBuilder]::new()
    foreach ($relativePath in $relativePaths) {
        $absolute = [System.IO.Path]::Combine($rootFull, $relativePath.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
        $digest = [Catzc.Base.Globs.DurableHash]::HashFile($absolute)
        [void]$stringBuilder.Append($relativePath).Append('|').Append($digest).Append("`n")
    }

    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
