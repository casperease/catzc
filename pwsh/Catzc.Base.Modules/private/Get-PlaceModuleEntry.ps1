<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Modules/private/Get-PlaceModuleEntry.ps1
    folder: private
    name: get-place-module-entry
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Modules
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-PlaceModuleEntry.ps1.md](docs/references/pwsh/catzc-base-modules/private/Get-PlaceModuleEntry.ps1.md)"
    cites:
      - ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE
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
