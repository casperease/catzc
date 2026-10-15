<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Folders/Get-ChildPath.ps1
    kind: public-function
    module: Catzc.Base.Folders
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Lists the files and folders below a folder, to a bounded depth, without loading the tree.
.DESCRIPTION
    The one way to enumerate children and deeper.
.PARAMETER Path
    The folder to list below. It must exist.
.PARAMETER Depth
    How many levels to list: 1 is the direct children only. The default is the folder-walk config's depth.
.PARAMETER Filter
    Simple wildcard patterns matched against each name; an entry is listed when any pattern matches.
.PARAMETER Directory
    List folders only. With -File, or with neither, both are listed.
.PARAMETER File
    List files only. With -Directory, or with neither, both are listed.
.PARAMETER Exclude
    Folder names to prune. The default is the folder-walk config's exclude list.
.PARAMETER PruneVendor
    Whether the vendor folder is pruned as well.
.OUTPUTS
    [string[]] Full paths of the matching entries.
.EXAMPLE
    Get-ChildPath $modulePath -File -Filter '*.ps1'
.EXAMPLE
    Get-ChildPath $automationRoot -Depth 3 -File -Filter '*.yml' -PruneVendor $true
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
