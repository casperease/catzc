<#
---
catzc:
  immutable:
    with_body_sha: "5ccacec947f1"
  edges:
    test: pwsh/Catzc.Base.Exporter/tests/Get-CatzcContentHash.Tests.ps1
    docs: "[Get-CatzcContentHash.ps1.md](docs/references/pwsh/catzc-base-exporter/Get-CatzcContentHash.ps1.md)"
    cites:
      - ADR-PWSH-ENUM-ALWAYSBOUNDED
      - FDR-CD-GLOBS-DURABLESHAIDENTITY
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
