<#
.SYNOPSIS
    Recursively copies the contents of a directory into a destination directory.
.DESCRIPTION
    A fast replacement for `Copy-Item -Recurse`, built on [System.IO].
    [comment:1](/docs/references/automation/catzc-base-files/Copy-Directory.ps1.md#comment1)
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
    # [comment:2](/docs/references/automation/catzc-base-files/Copy-Directory.ps1.md#comment2)
    foreach ($dir in [System.IO.Directory]::EnumerateDirectories($source, '*', [System.IO.SearchOption]::AllDirectories)) {
        [System.IO.Directory]::CreateDirectory($target + $dir.Substring($sourceLen)) | Out-Null
    }
    foreach ($file in [System.IO.Directory]::EnumerateFiles($source, '*', [System.IO.SearchOption]::AllDirectories)) {
        [System.IO.File]::Copy($file, $target + $file.Substring($sourceLen), $true)
    }
}
