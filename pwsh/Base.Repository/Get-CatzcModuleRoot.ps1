function Get-CatzcModuleRoot {
    [CmdletBinding(DefaultParameterSetName = 'Loaded')]
    [OutputType([string])]
    param(
        [Parameter(Position = 0)]
        [string] $ChildPath,

        [Parameter(ParameterSetName = 'Loaded')]
        [Parameter(Mandatory, ParameterSetName = 'Place')]
        [string] $Module,

        [Parameter(Mandatory, ParameterSetName = 'Place')]
        [string] $Place
    )

    if ($PSCmdlet.ParameterSetName -eq 'Place') {
        # A language module is a plain folder at its track's place: under the repository root in source mode, under the code root in build mode.
        $isBuild = (Get-CatzcRunMode) -eq 'build'
        $root = if ($isBuild) {
            Get-CatzcModulesRoot
        }
        else {
            Get-RepositoryRoot
        }
        $folder = [System.IO.Path]::Combine($root, $Place, $Module)
        if (-not [System.IO.Directory]::Exists($folder)) {
            throw "Get-CatzcModuleRoot found no module folder '$Module' at place '$Place' in $(if ($isBuild) { 'the code root' } else { 'the repository root' }) '$root'."
        }
        if (-not $ChildPath) {
            return $folder
        }
        return Join-Path $folder $ChildPath
    }

    # The folder comes from the loaded module, never its name, which carries the namespace the folder drops.
    $loaded = if ($Module) {
        Import-DeferredModule -Name $Module
        Get-Module -Name $Module | Select-Object -First 1
    }
    else {
        $PSCmdlet.SessionState.Module
    }
    Assert-NotNull $loaded -ErrorText "Get-CatzcModuleRoot found no loaded module$(if ($Module) { " '$Module'" } else { '; called from outside a module, pass -Module <name>' })."
    $moduleRoot = $loaded.ModuleBase
    $overlayRoot = Get-OverlayRoot
    $folderName = [System.IO.Path]::GetFileName($moduleRoot)
    $modulesRoot = Get-CatzcModulesRoot
    $isBundled = [System.IO.Path]::GetFullPath([System.IO.Path]::GetDirectoryName($moduleRoot)) -eq [System.IO.Path]::GetFullPath($modulesRoot)
    Assert-PathExist $moduleRoot -PathType Container

    if (-not $ChildPath) {
        return $moduleRoot
    }
    if ($isBundled -and $overlayRoot -and $ChildPath.Replace('\', '/').StartsWith('assets/',
            [System.StringComparison]::Ordinal)) {
        # The overlay folder is bare, while a built root's module folder carries the namespace.
        $override = [System.IO.Path]::Combine($overlayRoot, (Resolve-CodeModuleFolder -BareName $folderName), $ChildPath)
        if ([System.IO.File]::Exists($override)) {
            return $override
        }
    }
    Join-Path $moduleRoot $ChildPath
}
