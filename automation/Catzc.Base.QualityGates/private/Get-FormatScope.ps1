<#
.SYNOPSIS
    The files Format-Code formats: the repository's tracked files, or the given paths, minus vendored code.
.DESCRIPTION
    One scope for every formatter engine ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)):
    without -Path, every file git tracks (Get-GitTrackedPath); with -Path, each given file as it is (tracked or not,
    inside the repository or not — a build output manifest is formatted the same way), and each given folder's
    tracked files. Fixture files are formatted like any other file. Third-party code that .gitattributes marks
    `linguist-vendored` is never formatted: it stays as its publisher shipped it, and the class is declared once, in
    the .gitattributes source ([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)).
    A tracked file deleted from the working tree is left out.
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
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path @($relativeOf.Values) -Attribute linguist-vendored
    , [string[]] @($present | Where-Object {
            -not $relativeOf.ContainsKey($_) -or -not $attributes[$relativeOf[$_]] -or
            $attributes[$relativeOf[$_]]['linguist-vendored'] -notin 'set', 'true'
        })
}
