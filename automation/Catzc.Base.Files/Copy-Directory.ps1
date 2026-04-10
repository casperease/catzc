<#
.SYNOPSIS
    Recursively copies the contents of a directory into a destination directory.
.DESCRIPTION
    A fast replacement for `Copy-Item -Recurse`, built on [System.IO]. The PowerShell file
    cmdlets carry heavy per-item provider overhead on Windows (~15x slower per file/dir here),
    which dominates when copying a tree of many small files; the raw .NET APIs avoid it.

    Mirrors the tree under -Path into -Destination — the equivalent of
    `Copy-Item (Join-Path $Path '*') $Destination -Recurse`. The destination is created if it
    does not exist, files are overwritten, and empty subdirectories are preserved.
.PARAMETER Path
    The source directory whose contents are copied. Must exist.
.PARAMETER Destination
    The target directory the contents are copied into (created if missing).
.EXAMPLE
    Copy-Directory $fixtureTemplates $sandbox
#>
function Copy-Directory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory, Position = 1)]
        [string] $Destination
    )

    $source = [System.IO.Path]::GetFullPath($Path)
    Assert-PathExist $source -PathType Container -ErrorText "Copy-Directory: source directory '$Path' does not exist."
    $target = [System.IO.Path]::GetFullPath($Destination)
    $sourceLen = $source.Length

    [System.IO.Directory]::CreateDirectory($target) | Out-Null

    # Recreate the directory structure first (so empty directories survive), then copy the files.
    # Each enumerated path starts with $source, so substring-after-prefix rebases it under $target
    # (safer than String.Replace, which would rewrite any other occurrence of the prefix).
    foreach ($dir in [System.IO.Directory]::EnumerateDirectories($source, '*', [System.IO.SearchOption]::AllDirectories)) {
        [System.IO.Directory]::CreateDirectory($target + $dir.Substring($sourceLen)) | Out-Null
    }
    foreach ($file in [System.IO.Directory]::EnumerateFiles($source, '*', [System.IO.SearchOption]::AllDirectories)) {
        [System.IO.File]::Copy($file, $target + $file.Substring($sourceLen), $true)
    }
}
