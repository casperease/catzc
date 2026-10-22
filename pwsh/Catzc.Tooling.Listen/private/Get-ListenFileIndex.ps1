<#
---
catzc:
  immutable:
    with_body_sha: "352eef5b25d6"
---
#>

function Get-ListenFileIndex {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.SortedDictionary[string, object]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Root,

        [Parameter(Mandatory)]
        [string] $Prefix
    )

    $rootFull = [System.IO.Path]::GetFullPath($Root)
    $index = [System.Collections.Generic.SortedDictionary[string, object]]::new([System.StringComparer]::Ordinal)
    foreach ($file in Get-ChildPath $rootFull -File -Depth 64 -Exclude @() -PruneVendor $false) {
        $relative = [System.IO.Path]::GetRelativePath($rootFull, $file).Replace('\', '/')
        $info = [System.IO.FileInfo]::new($file)
        $index["$Prefix/$relative"] = [ordered]@{
            length = $info.Length
            ticks  = $info.LastWriteTimeUtc.Ticks
            hash   = [Catzc.Base.Globs.DurableHash]::HashFile($file)
        }
    }
    , $index
}
