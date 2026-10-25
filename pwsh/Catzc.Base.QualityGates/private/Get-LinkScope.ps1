<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-LinkScope.ps1.md"
  header: "generated"
---
#>

function Get-LinkScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path
    )

    $isDiskRoot = {
        param([string] $FullPath)
        $FullPath.TrimEnd('\', '/') -eq ([System.IO.Path]::GetPathRoot($FullPath)).TrimEnd('\', '/')
    }

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    Assert-False (& $isDiskRoot $root) -ErrorText "Get-LinkScope: the repository root '$root' is a disk root — refusing to scan a whole drive."
    $files = if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).Path)
            Assert-False (& $isDiskRoot $full) -ErrorText "Get-LinkScope: -Path '$item' resolves to the disk root '$full' — refusing to scan a whole drive."
            $found = if (Test-Path -LiteralPath $full -PathType Container) {
                # A scope as wide as the repository: tracked files reach nine levels below the root, so ten leaves one level of headroom.
                Get-ChildPath $full -File -Depth 10
            }
            else {
                $full
            }
            foreach ($file in $found) {
                [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
            }
        }
    }
    else {
        # A tracked file deleted or moved on disk but not yet staged has nothing to scan, so it is left out.
        Get-GitTrackedPath '.' | Where-Object { [System.IO.File]::Exists([System.IO.Path]::Combine($root, $_)) }
    }

    $inRepository = @($files | Where-Object { $_ -notmatch '^\.\./' })
    # Get-ContentExemptPath returns its paths as one array: assign it, so the set holds the paths, not the array.
    $exemptPaths = Get-ContentExemptPath -RepositoryRoot $root -Path $inRepository
    $exempt = [System.Collections.Generic.HashSet[string]]::new([string[]] @($exemptPaths))
    @($inRepository | Where-Object { -not $exempt.Contains($_) })
}
