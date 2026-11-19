function Get-BuildSourceInput {
    # .SYNOPSIS
    #     Lists the repository-relative folders (each ending in a slash) and files a build of one module selection reads, the input roots
    #     Get-BuildSourceStamp counts.
    # .DESCRIPTION
    #     Each input and the code that reads it:
    #     - the folder of every selected module: Get-ModuleBuildPlan merges its function files (Get-MergedModule) and copies its shipped
    #       folders (Get-BuildFileCopy over ShippedFolders());
    #     - the internal folder: Get-ModuleBuildPlan copies the exporter-globbed internal files and the initializer Import-Catzc.ps1, and
    #       the builder itself runs from it;
    #     - the vendor folder: Get-ModuleBuildPlan copies the vendored modules verbatim;
    #     - the analyzer folder and the vendored bats runner, when the selection holds the gates module: Get-ModuleBuildPlan copies both;
    #     - the types folder of every module, selected or not: Get-CombinedTypeHash hashes the full type set, Get-ModuleBuildPlan ships the
    #       other modules' sources under .compiled/types and Write-ModuleBuildOutput compiles them;
    #     - the folders of the engine modules, whose configs and commands decide what a build writes: Config (Get-Config, every config
    #       read), Exporter (exporter.yml), Languages (languages.yml, file-carriers.yml, the package handlers Invoke-ModuleBuild runs),
    #       ModuleSystem (dependencies.yml, profiles.yml, Get-ModuleProfile, Get-InternalAssetDependency), Modules (Get-CatzcModule),
    #       Overlay (Get-FunctionFileViolation in Get-MergedModule), Variants (Get-Track, variants.yml, track-types.yml,
    #       module-types.yml) and VSCode (Export-VsCodeExtensionFolder, which Export-JavaScriptModule renders an extension with);
    #     - the tools pin file of the Execution module: the Python and Go package handlers refuse a tool off its pin
    #       (Resolve-ToolExecutable);
    #     - the repository's config overlay fragments for the modules folder: Get-Config merges them onto a config in source mode
    #       (Get-ConfigOverlayRoot);
    #     - the language modules the selection packages: every place of a language track whose primary language has a package handler
    #       when the selection is the whole repository, else the language module paths a selected module declares in dependencies.yml
    #       (Get-ModuleBuildPlan's language rows).
    #     No root file of the repository is an input: the build copies none, and the root importer an install writes is rendered from
    #     the RootConfig module's assets. The contracts are no input either: they decide no byte of a build, and the types-contract
    #     check that reads them guards the commit that changes them.
    # .OUTPUTS
    #     [string[]] The input roots, ordinally sorted.
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Module,

        [switch] $AllLanguageModule
    )

    $engineModules = @(
        'Catzc.Base.Config', 'Catzc.Base.Exporter', 'Catzc.Base.Languages', 'Catzc.Base.ModuleSystem', 'Catzc.Base.Modules',
        'Catzc.Base.Overlay', 'Catzc.Base.Variants', 'Catzc.Base.VSCode'
    )
    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $sourceFull = [System.IO.Path]::GetFullPath($SourceRoot).TrimEnd('\', '/')
    $modulesFolder = [System.IO.Path]::GetRelativePath($root, $sourceFull).Replace('\', '/')
    $namespace = Get-ModuleNamespace -ModulesRoot $sourceFull
    $inputs = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)

    foreach ($name in @(@($Module) + $engineModules)) {
        [void] $inputs.Add("$modulesFolder/$(Resolve-ModuleName -FullName $name -Namespace $namespace)/")
    }
    [void] $inputs.Add("$modulesFolder/.internal/")
    [void] $inputs.Add("$modulesFolder/.vendor/")
    if ('Catzc.Base.QualityGates' -in $Module) {
        [void] $inputs.Add("$modulesFolder/.scriptanalyzer/")
        $batsRoot = [System.IO.Path]::Combine([System.IO.Path]::GetDirectoryName($sourceFull), 'bash', '.vendor', 'bats-core')
        [void] $inputs.Add("$([System.IO.Path]::GetRelativePath($root, $batsRoot).Replace('\', '/'))/")
    }
    foreach ($directory in [System.IO.Directory]::GetDirectories($sourceFull)) {
        $folder = [System.IO.Path]::GetFileName($directory)
        if (-not $folder.StartsWith('.')) {
            [void] $inputs.Add("$modulesFolder/$folder/types/")
        }
    }
    [void] $inputs.Add("$modulesFolder/$(Resolve-ModuleName -FullName 'Catzc.Base.Execution' -Namespace $namespace)/configs/tools.yml")
    [void] $inputs.Add(".catzc/$modulesFolder/")

    if ($AllLanguageModule) {
        $languages = (Get-Config -Config languages).languages
        foreach ($track in @(Get-Track)) {
            if ($track.type -cne 'modules' -or $track.languages.Count -eq 0) {
                continue
            }
            $primary = @($languages.Where({ $_.name -ceq $track.languages[0] }))
            if ($primary.Count -eq 0 -or $null -eq $primary[0].package) {
                continue
            }
            foreach ($place in $track.places) {
                [void] $inputs.Add("$(([string] $place).TrimEnd('/'))/")
            }
        }
    }
    else {
        $declared = (Get-Config -Config dependencies).modules
        foreach ($name in $Module) {
            if (-not $declared.Contains($name)) {
                continue
            }
            foreach ($target in @($declared[$name])) {
                if (([string] $target).Contains('/')) {
                    [void] $inputs.Add("$(([string] $target).TrimEnd('/'))/")
                }
            }
        }
    }

    [string[]] @($inputs)
}
