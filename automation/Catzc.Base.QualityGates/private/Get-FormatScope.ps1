# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Get-FormatScope.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    The files Format-Code formats: the repository's tracked files, or the given paths, minus vendored code and contract
    assets.
.DESCRIPTION
    Vendored code and contract assets stay out, so a formatter upgrade can never rewrite their frozen bytes.
    [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1),
    [ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4),
    [ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5),
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-FormatScope.ps1.md#comment1)
.PARAMETER RepositoryRoot
    The repository root.
.PARAMETER Path
    Files or folders to narrow the scope to. Omitted: every tracked file.
.OUTPUTS
    [string[]] Absolute paths.
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
    $exemptClasses = 'linguist-vendored', 'catzc-contract'
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path @($relativeOf.Values) -Attribute $exemptClasses
    , [string[]] @($present | Where-Object {
            $classes = if ($relativeOf.ContainsKey($_)) {
                $attributes[$relativeOf[$_]]
            }
            -not $classes -or -not @($exemptClasses | Where-Object { $classes[$_] -in 'set', 'true' })
        })
}
