<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/private/Get-ModuleTestFolder.ps1.md"
  header: "generated"
---
#>

function Get-ModuleTestFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Language,

        [Parameter(Mandatory, Position = 1)]
        [string] $Module
    )

    $folder = $Module
    foreach ($track in @(Get-Track)) {
        $stripped = $track.FolderNameOf($Module)
        if ($stripped -cne $Module) {
            $folder = $stripped
            break
        }
    }
    (Get-Config -Config languages).TestFolderOf($Language, $folder)
}
