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
  config:
    synopsis: Computes the durable content hash of a directory tree — the bundle's content-addressed identity.
    description: |-
      The same durable-SHA recipe the globsets use
      ([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)), applied to every file under
      -Path: per file a
      SHA-256 over its bytes with every CR stripped (so a CRLF vs LF tree yields the same identity on any
      machine), folded as <relative-path>|<digest> lines in ordinal path order, then one combined SHA-256 over
      the fold — 64 lowercase hex chars. The relative path is forward-slashed and taken from -Path, so the hash
      is stable wherever the tree is copied. This is the reproducibility proof an exported bundle carries
      (build twice from one commit -> identical hash).
    parameters:
      Path: The root directory whose file tree to hash (recursively).
      Exclude: |-
        Path-relative, forward-slashed file paths to omit from the hash — e.g. a build.json sidecar that itself
        carries the hash, so it cannot be part of the content it identifies.
    examples:
      - Get-CatzcContentHash -Path (Join-Path (Get-OutputRoot) 'automation/built/full/Catzc/6.6.666') -Exclude 'build.json'
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
    # [comment:3](/docs/references/automation/catzc-base-exporter/Get-CatzcContentHash.ps1.md#comment3)
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
