<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Folders/Get-ChildPath.ps1
    name: get-child-path
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Folders
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Folders/tests/Get-ChildPath.Tests.ps1
  config:
    synopsis: Lists the files and folders below a folder, to a bounded depth, without loading the tree.
    description: |-
      The one way to enumerate children and deeper. It walks lazily in .NET, stops at the depth, never follows a link, and prunes
      the named folders while it walks, so a pruned folder is never entered. The result is full paths in ordinal order.
    parameters:
      Path: The folder to list below. It must exist.
      Depth: 'How many levels to list: 1 is the direct children only. The default is the folder-walk config''s depth.'
      Filter: |-
        Simple wildcard patterns matched against each name; an entry is listed when any pattern matches. A folder that does not match is
        still entered.
      Directory: List folders only. With -File, or with neither, both are listed.
      File: List files only. With -Directory, or with neither, both are listed.
      Exclude: Folder names to prune. The default is the folder-walk config's exclude list.
      PruneVendor: |-
        Whether the .vendor folder is pruned as well. The default is the folder-walk config's prune_vendor_in_searches, also readable as
        global.folder-walk.prune_vendor_in_searches.
    outputs: '[string[]] Full paths of the matching entries.'
    examples:
      - Get-ChildPath $modulePath -File -Filter '*.ps1'
      - Get-ChildPath $automationRoot -Depth 3 -File -Filter '*.yml' -PruneVendor $true
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
