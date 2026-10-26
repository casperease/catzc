<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md"
  header: "generated"
---
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
    # A named whole-tree walk: the hash covers every file, so nothing is pruned and no depth drops one.
    $files = Get-ChildPath $rootFull -File -Depth 64 -Exclude @() -PruneVendor $false

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
        $absolute = [System.IO.Path]::Combine($rootFull, $relativePath.Replace('/',
                [System.IO.Path]::DirectorySeparatorChar))
        $digest = [Catzc.Base.Globs.DurableHash]::HashFile($absolute)
        [void]$stringBuilder.Append($relativePath).Append('|').Append($digest).Append("`n")
    }

    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
