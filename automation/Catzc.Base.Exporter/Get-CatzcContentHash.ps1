<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/Get-CatzcContentHash.ps1
    kind: public-function
    module: Catzc.Base.Exporter
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS#5
      - ADR-PWSH-ENUM#3
---
#>

<#
.SYNOPSIS
    Computes the durable content hash of a directory tree — the bundle's content-addressed identity.
.DESCRIPTION
    CRs are stripped before hashing, so a CRLF and an LF checkout of one tree give the same identity.
.PARAMETER Path
    The root directory whose file tree to hash (recursively).
.PARAMETER Exclude
    Exclude the file that stores the hash, such as build.json: it cannot be part of the content it identifies.
.EXAMPLE
    Get-CatzcContentHash -Path (Join-Path (Get-OutputRoot) 'automation/built/full/Catzc/6.6.666') -Exclude 'build.json'
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
    # A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the hash
    # covers every file, so nothing is pruned and no depth drops one.
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
        $absolute = [System.IO.Path]::Combine($rootFull, $relativePath.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
        $digest = [Catzc.Base.Globs.DurableHash]::HashFile($absolute)
        [void]$stringBuilder.Append($relativePath).Append('|').Append($digest).Append("`n")
    }

    [Catzc.Base.Globs.DurableHash]::HashFold($stringBuilder.ToString())
}
