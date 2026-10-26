function Get-ModuleBuildPlan {
    # .SYNOPSIS
    #     Computes every file a build writes, from the source tree alone, and collects every reason it cannot.
    # .DESCRIPTION
    #     Reads the sources and writes nothing, so the plan can be checked or returned before any write.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-NoBareCacheEntryRead', '',
        Justification = 'The module constants are assigned once in Catzc.Internal.Builder.psm1, whose shared scope this file is dot-sourced into, before any call.')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Module,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $VendorPolicy,

        [Parameter(Mandatory)]
        [hashtable] $PackageMetadata,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    $sourceFolder = [System.IO.Path]::GetFileName($SourceRoot.TrimEnd('\', '/'))
    $entries = [System.Collections.Generic.List[object]]::new()
    $violations = [System.Collections.Generic.List[string]]::new()
    $allPublics = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

    foreach ($name in $Module) {
        # The source folder drops the namespace; the built folder keeps the full name, which PowerShell's module path needs.
        $folderName = (Resolve-ModuleName -FullName $name -Namespace (Get-ModuleNamespace -ModulesRoot $SourceRoot))
        $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, $folderName)
        if (-not [System.IO.Directory]::Exists($moduleDirectory)) {
            $violations.Add("$sourceFolder/${folderName}: the module folder does not exist")
            continue
        }
        $merged = Get-MergedModule -SourceRoot $SourceRoot -Name $name -Index $Index -ParsedScripts $ParsedScripts
        foreach ($violation in $merged.Violations) {
            $violations.Add($violation)
        }
        foreach ($public in $merged.Publics) {
            [void] $allPublics.Add($public)
        }
        $exports = [string[]] @($merged.Publics)
        [System.Array]::Sort($exports, [System.StringComparer]::Ordinal)
        $entries.Add([pscustomobject]@{ Path = "$name/$name$($script:mergedFileSuffix)"; Kind = 'Text'; Source = $null; Content = $merged.Content; Exports = $null })
        $entries.Add([pscustomobject]@{ Path = "$name/$name.psd1"; Kind = 'Manifest'; Source = $null; Content = $null; Exports = $exports })
        # The folders a build copies verbatim are the layout's shipped rows.
        foreach ($folder in (Get-Config -Config languages).ShippedFolders()) {
            $copies = Get-BuildFileCopy -SourceDirectory ([System.IO.Path]::Combine($moduleDirectory,
                    $folder)) -TargetPath "$name/$folder" -SourceRoot $SourceRoot -Index $Index -IncludeUntracked:($folder -eq 'types')
            foreach ($copy in @($copies)) {
                $entries.Add($copy)
            }
        }
    }

    # The runtime loader and its assets, plus the analyzer settings and rules under the full vendor policy.
    # A file ships only when an exporter glob names it, so a new asset in a shipped folder needs no row and a new tool
    # outside them never ships.
    $exporter = Get-Config -Config exporter
    $globs = [string[]] @(@($exporter.runtime_internal_files) + @(if ($VendorPolicy -eq 'full') {
                $exporter.full_internal_files
            }))
    $internalRoot = [System.IO.Path]::Combine($SourceRoot, '.internal')
    $present = [string[]] @(if ([System.IO.Directory]::Exists($internalRoot)) {
            foreach ($file in [System.IO.Directory]::EnumerateFiles($internalRoot, '*', [System.IO.SearchOption]::AllDirectories)) {
                [System.IO.Path]::GetRelativePath($internalRoot, $file).Replace('\', '/')
            }
        })
    $internalFiles = [string[]] [Catzc.Base.Objects.GlobPattern]::MatchingPaths($globs, $present)
    [System.Array]::Sort($internalFiles, [System.StringComparer]::Ordinal)
    foreach ($relativePath in $internalFiles) {
        $source = [System.IO.Path]::Combine($internalRoot, $relativePath)
        if (-not (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $source)) {
            continue
        }
        $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $source
        $entries.Add([pscustomobject]@{ Path = ".internal/$relativePath"; Kind = 'Copy'; Source = $source; Content = $null; Exports = $null; Normalize = $normalize })
    }
    if ($VendorPolicy -eq 'full') {
        foreach ($copy in @(Get-BuildFileCopy -SourceDirectory ([System.IO.Path]::Combine($SourceRoot,
                        '.scriptanalyzer')) -TargetPath '.scriptanalyzer' -SourceRoot $SourceRoot -Index $Index -ExcludeDirectory 'tests')) {
            $entries.Add($copy)
        }
    }

    # Vendored modules, verbatim (never re-downloaded): every one under 'full', the runtime ones under 'runtime'.
    $vendorRoot = [System.IO.Path]::Combine($SourceRoot, '.vendor')
    if ([System.IO.Directory]::Exists($vendorRoot)) {
        $vendorNames = [string[]] @(foreach ($vendorDirectory in [System.IO.Directory]::GetDirectories($vendorRoot)) {
                [System.IO.Path]::GetFileName($vendorDirectory)
            })
        [System.Array]::Sort($vendorNames, [System.StringComparer]::Ordinal)
        foreach ($vendorName in $vendorNames) {
            if ($VendorPolicy -eq 'runtime' -and $vendorName -in $script:testToolVendorModules) {
                continue
            }
            foreach ($copy in @(Get-BuildFileCopy -SourceDirectory ([System.IO.Path]::Combine($vendorRoot,
                            $vendorName)) -TargetPath ".vendor/$vendorName" -SourceRoot $SourceRoot -Index $Index)) {
                $entries.Add($copy)
            }
        }
    }

    # The package entry points: the authored initializer (verbatim), its RootModule wrapper, and the manifest.
    $initializer = [System.IO.Path]::Combine($SourceRoot, '.internal', 'assets', 'Import-Catzc.ps1')
    if (-not [System.IO.File]::Exists($initializer)) {
        $violations.Add("$sourceFolder/.internal/assets/Import-Catzc.ps1: the build initializer does not exist")
    }
    elseif (-not (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $initializer)) {
        $violations.Add("$sourceFolder/.internal/assets/Import-Catzc.ps1: the build initializer is ignored by git, and a bundle never ships an ignored file")
    }
    else {
        $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $initializer
        $entries.Add([pscustomobject]@{ Path = 'Import-Catzc.ps1'; Kind = 'Copy'; Source = $initializer; Content = $null; Exports = $null; Normalize = $normalize })
    }
    $rootModule = @(
        '# Catzc root module — generated by Invoke-ModuleBuild; do not edit. Import-Module Catzc runs the same initializer'
        '# a caller can dot-source, Import-Catzc.ps1 (docs/drs/automation/platform-bundle.md).'
        ". (Join-Path `$PSScriptRoot 'Import-Catzc.ps1')"
    ) -join "`n"
    $entries.Add([pscustomobject]@{ Path = 'Catzc.psm1'; Kind = 'Text'; Source = $null; Content = $rootModule; Exports = $null })
    $packageExports = [string[]] @($allPublics)
    [System.Array]::Sort($packageExports, [System.StringComparer]::Ordinal)
    $packageManifest = Format-CatzcPackageManifest -Version $Version -PackageMetadata $PackageMetadata -FunctionToExport $packageExports
    $entries.Add([pscustomobject]@{ Path = 'Catzc.psd1'; Kind = 'Text'; Source = $null; Content = $packageManifest; Exports = $null })

    # The combined-types assembly is always the FULL type set, whatever modules are selected, so a build loads the
    # same types as source mode. It is compiled into the build's .compiled. A selected module's sources
    # ship in its own types/ folder (copied above); every other module's ship verbatim under
    # .compiled/types/<Module>/<File>.cs, a dot folder the importer never takes for a module. Together the two hold
    # the full set the hash covers; build.json lists every source by its build-relative path, in hash order.
    $typeHash = $null
    $typeSources = [string[]] @()
    $hashResult = Get-CombinedTypeHash -ModulesRoot $SourceRoot
    if ($hashResult.CombinedHash) {
        $typeHash = $hashResult.CombinedHash
        $selectedModules = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module),
            [System.StringComparer]::OrdinalIgnoreCase)
        # The hash names each source by its folder; the build names it by the module's full name, the folder a bundle ships.
        $moduleNamespace = Get-ModuleNamespace -ModulesRoot $SourceRoot
        $typeSources = [string[]] @(foreach ($file in $hashResult.Files) {
                $fullName = Resolve-ModuleName -Folder $file.Module -Namespace $moduleNamespace
                if ($selectedModules.Contains($fullName)) {
                    "$fullName/types/$($file.Base).cs"
                }
                else {
                    ".compiled/types/$fullName/$($file.Base).cs"
                }
            })
        foreach ($file in $hashResult.Files) {
            $fullName = Resolve-ModuleName -Folder $file.Module -Namespace $moduleNamespace
            if (-not $selectedModules.Contains($fullName)) {
                $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $file.Path
                $entries.Add([pscustomobject]@{ Path = ".compiled/types/$fullName/$($file.Base).cs"; Kind = 'Copy'; Source = $file.Path; Content = $null; Exports = $null; Normalize = $normalize })
            }
        }
        # The bcl carrier's head form is an input of the hash, so the build ships the carriers beside the type sources: a reduced
        # build without the Languages module still hashes the bodies the source does.
        $carriers = [System.IO.Path]::Combine($SourceRoot, (Resolve-ModuleName -FullName 'Catzc.Base.Languages' -Namespace $moduleNamespace),
            'configs', 'file-carriers.yml')
        if ([System.IO.File]::Exists($carriers)) {
            $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $carriers
            $entries.Add([pscustomobject]@{ Path = '.compiled/types/file-carriers.yml'; Kind = 'Copy'; Source = $carriers; Content = $null; Exports = $null; Normalize = $normalize })
        }
        # Git keeps no DLL
        # ([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](/docs/drs/automation/caching.md#rule-adr-auto-cache-compiledtypeprebuild)), so the build compiles it, and its manifest, into the bundle.
        $entries.Add([pscustomobject]@{ Path = ".compiled/Catzc.Types.$typeHash.dll"; Kind = 'Types'; Source = $null; Content = $null; Exports = $null })
        $entries.Add([pscustomobject]@{ Path = ".compiled/Catzc.Types.$typeHash.json"; Kind = 'Types'; Source = $null; Content = $null; Exports = $null })
    }

    [pscustomobject]@{
        Entries     = $entries.ToArray()
        Violations  = $violations.ToArray()
        TypesHash   = $typeHash
        TypeSources = $typeSources
    }
}
