<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Modules/private/Get-PlaceModuleEntry.ps1
    folder: private
    name: get-place-module-entry
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Modules
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-MODULE#1
  config:
    synopsis: Lists the modules one place of a module type holds on disk, each as its root, shape, name and folder.
    description: |-
      A folder place yields each non-dot folder under it, a file place each file of its extension, and a root place the place itself; the
      module name is the one the place gives the path (ModulePlace.NameOf), so the prefix and the dot rule live in that one type. The
      folder is where the module's files are listed: the folder itself, or nothing for a file module. Private: Get-CatzcModule is the
      one caller.
    parameters:
      Place: The ModulePlace of the module type.
      Directory: The directory on disk that holds the place's root.
    outputs: '[pscustomobject] Root (repository-relative), Shape (folder, file or root), Name and Folder (the module directory, or null).'
    examples:
      - Get-PlaceModuleEntry -Place $place -Directory $directory
---
#>

function Get-PlaceModuleEntry {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [Catzc.Base.Variants.ModulePlace] $Place,

        [Parameter(Mandatory)]
        [string] $Directory
    )

    if ($Place.name -ceq 'root') {
        [pscustomobject]@{ Root = $Place.root; Shape = 'root'; Name = $Place.NameOf($Place.root); Folder = $Directory }
        return
    }

    if ($Place.name -ceq 'file') {
        foreach ($path in Get-ChildPath $Directory -File -Depth 1 -Filter "*.$($Place.extension)") {
            $leaf = [System.IO.Path]::GetFileName($path)
            $name = $Place.NameOf("$($Place.root)/$leaf")
            if ($name) {
                [pscustomobject]@{ Root = "$($Place.root)/$leaf"; Shape = 'file'; Name = $name; Folder = $null }
            }
        }
        return
    }

    foreach ($path in Get-ChildPath $Directory -Directory -Depth 1) {
        $leaf = [System.IO.Path]::GetFileName($path)
        $name = $Place.NameOf("$($Place.root)/$leaf/_")
        if ($name) {
            [pscustomobject]@{ Root = "$($Place.root)/$leaf"; Shape = 'folder'; Name = $name; Folder = $path }
        }
    }
}
