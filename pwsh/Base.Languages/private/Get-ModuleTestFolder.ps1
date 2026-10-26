function Get-ModuleTestFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Language,

        [Parameter(Mandatory, Position = 1)]
        [string] $Module
    )

    # A module's test folder is named from its folder, which drops the namespace its track declares, in the language's folder
    # case; a name no track's namespace prefixes is its own folder.
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
