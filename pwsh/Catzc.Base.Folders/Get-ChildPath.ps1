<#
---
catzc:
  immutable:
    with_body_sha: a92a67a3aa33
  edges:
    test: pwsh/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
    docs: "[Get-ChildPath.ps1.md](../../docs/references/pwsh/catzc-base-folders/Get-ChildPath.ps1.md)"
---
#>

function Get-ChildPath {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path,

        [int] $Depth = (Get-Config -Config folder-walk).depth,

        [string[]] $Filter = '*',

        [switch] $Directory,

        [switch] $File,

        [string[]] $Exclude = (Get-Config -Config folder-walk).exclude,

        [bool] $PruneVendor = (Get-Config -Config folder-walk).prune_vendor_in_searches
    )

    # Neither switch, or both, lists both kinds; the vendor folder joins the pruned names only when it is pruned.
    $listFiles = $File -or -not $Directory
    $listDirectories = $Directory -or -not $File
    $pruned = if ($PruneVendor) {
        @($Exclude) + [Catzc.Base.Folders.FolderWalkConfig]::VendorFolder
    }
    else {
        @($Exclude)
    }

    [Catzc.Base.Folders.FolderWalker]::Walk($Path, $Depth, $Filter, $listFiles, $listDirectories, [string[]] $pruned)
}
