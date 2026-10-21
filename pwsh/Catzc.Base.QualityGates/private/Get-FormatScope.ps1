<#
---
catzc:
  immutable:
    with_body_sha: "82cac9461e5e"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
    docs: "[Get-FormatScope.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-FormatScope.ps1.md)"
    cites:
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
      - ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY
      - ADR-REPO-CONTRACT-RELEASEDIMMUTABLE
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
#>

function Get-FormatScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).ProviderPath)
            if (Test-Path -LiteralPath $full -PathType Leaf) {
                $files.Add($full)
                continue
            }
            $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
            Assert-False ($relative -eq '..' -or $relative.StartsWith('../')) -ErrorText "Get-FormatScope: the folder '$item' lies outside the repository '$root'; pass its files instead."
            foreach ($tracked in @(Get-GitTrackedPath $relative)) {
                $files.Add([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $tracked)))
            }
        }
    }
    else {
        foreach ($tracked in @(Get-GitTrackedPath '.')) {
            $files.Add([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $tracked)))
        }
    }

    $present = @($files | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -Unique)
    $inside = @($present | Where-Object {
            $relative = [System.IO.Path]::GetRelativePath($root, $_)
            -not ($relative -eq '..' -or $relative.StartsWith('..' + [System.IO.Path]::DirectorySeparatorChar))
        })
    if ($inside.Count -eq 0) {
        return , [string[]] $present
    }
    $relativeOf = @{}
    foreach ($file in $inside) {
        $relativeOf[$file] = [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }
    $exemptClasses = 'linguist-vendored', 'catzc-contract', 'binary'
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path @($relativeOf.Values) -Attribute $exemptClasses
    , [string[]] @($present | Where-Object {
            $classes = if ($relativeOf.ContainsKey($_)) {
                $attributes[$relativeOf[$_]]
            }
            -not $classes -or -not @($exemptClasses | Where-Object { $classes[$_] -in 'set', 'true' })
        })
}
