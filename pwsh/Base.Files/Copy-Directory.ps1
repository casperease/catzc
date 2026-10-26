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
    # Every path starts with $source, so cutting its prefix rebases it onto $target; String.Replace would rewrite other occurrences too.
    $sourceLen = $source.Length

    [System.IO.Directory]::CreateDirectory($target) | Out-Null

    # Folders first, so an empty one survives the copy; nothing is pruned, since a copy takes the whole tree.
    foreach ($dir in Get-ChildPath $source -Directory -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.Directory]::CreateDirectory($target + $dir.Substring($sourceLen)) | Out-Null
    }
    foreach ($file in Get-ChildPath $source -File -Depth 64 -Exclude @() -PruneVendor $false) {
        [System.IO.File]::Copy($file, $target + $file.Substring($sourceLen), $true)
    }
}
