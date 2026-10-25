<#
---
catzc:
  docs: "../../docs/references/pwsh/internal/Catzc.Internal.Builder.psm1.md"
  warning: "Generated Header"
---
#>

Set-StrictMode -Version Latest

$script:testToolVendorModules = @('Pester', 'PSScriptAnalyzer')

$script:runtimeInternalFiles = @(
    'Catzc.Internal.Bootstrap.psm1'
    'Catzc.Internal.Importer.psm1'
    'Catzc.Internal.Loader.psm1'
    'Catzc.Internal.Types.psm1'
    'Catzc.Internal.Vendor.psm1'
    'assets/ErrorView.format.ps1xml'
    'assets/types-load.yml'
)

$script:fullPolicyInternalFiles = @(
    'Catzc.Internal.TestKit.psm1'
    'assets/PSScriptAnalyzerSettings.psd1'
)

$script:mergedFileSuffix = '.functions.ps1'

function Get-BuildSourceIndex {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.Dictionary[string, bool]])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot
    )

    $listing = Invoke-Executable 'git -c core.quotepath=off ls-files --eol' -WorkingDirectory $SourceRoot -PassThru -Silent -NoAssert
    if ($listing.ExitCode -ne 0) {
        throw "Invoke-ModuleBuild: a bundle is built from the files git tracks, but git cannot list them under '$SourceRoot' ($($listing.Errors))."
    }
    $index = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::Ordinal)
    foreach ($line in ([string] $listing.Output).Split("`n")) {
        $tab = $line.IndexOf("`t")
        if ($tab -lt 0) {
            continue
        }
        $index[$line.Substring($tab + 1).TrimEnd("`r")] = $line.StartsWith('i/lf ', [System.StringComparison]::Ordinal)
    }
    $untracked = Invoke-Executable 'git -c core.quotepath=off ls-files --others --exclude-standard' -WorkingDirectory $SourceRoot -PassThru -Silent
    foreach ($line in ([string] $untracked.Output).Split("`n")) {
        $path = $line.TrimEnd("`r")
        if ($path) {
            $index[$path] = $false   # no stored form to restore: a byte copy
        }
    }
    , $index
}

function Test-BuildSourceDirty {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot
    )

    $changed = Invoke-Executable 'git --no-optional-locks diff --quiet HEAD -- .' -WorkingDirectory $SourceRoot -PassThru -Silent -NoAssert
    if ($changed.ExitCode -ne 0) {
        return $true
    }
    $untracked = Invoke-Executable 'git --no-optional-locks ls-files --others --exclude-standard -- .' -WorkingDirectory $SourceRoot -PassThru -Silent
    -not [string]::IsNullOrWhiteSpace([string] $untracked.Output)
}

function Test-BuildSourceLfOnly {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $isLfOnly = $false
    [void] $Index.TryGetValue([System.IO.Path]::GetRelativePath($SourceRoot, $Path).Replace('\', '/'), [ref] $isLfOnly)
    $isLfOnly
}

function Test-BuildSourceShippable {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $Index.ContainsKey([System.IO.Path]::GetRelativePath($SourceRoot, $Path).Replace('\', '/'))
}

function Resolve-BuildModuleSet {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Module,

        [string] $ModuleProfile
    )

    $selected = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    if ($ModuleProfile) {
        foreach ($name in @(Get-ModuleProfile -Name $ModuleProfile -NoInfrastructure)) {
            [void] $selected.Add($name)
        }
    }
    # An empty -Modules seed resolves to every module, so it is only passed when names were given.
    $named = @($Module | Where-Object { $_ })
    if ($named.Count -gt 0) {
        foreach ($name in @(Get-ModuleProfile -Modules $named -NoInfrastructure)) {
            [void] $selected.Add($name)
        }
    }

    $result = [string[]] @($selected)
    [System.Array]::Sort($result, [System.StringComparer]::Ordinal)
    $result
}

function Get-BuildClosureViolation {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Module,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    $sourceFolder = [System.IO.Path]::GetFileName($SourceRoot.TrimEnd('\', '/'))
    $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::Ordinal)

    foreach ($call in @(Get-FunctionDependency -ModulesRoot $SourceRoot -ParsedScripts $ParsedScripts)) {
        if ($call.CrossModule -and $selected.Contains($call.CallerModule) -and -not $selected.Contains($call.TargetModule)) {
            "$sourceFolder/$($call.CallerModule)/$($call.CallerFile):$($call.CallerLine): $($call.CallerFunction) calls $($call.TargetFunction), which $($call.TargetModule) owns"
        }
    }

    foreach ($name in $Module) {
        $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, $name)
        if (-not [System.IO.Directory]::Exists($moduleDirectory)) {
            continue
        }
        # A module's scripts sit at most three levels below its folder (tests/types/ is the deepest).
        foreach ($file in Get-ChildPath $moduleDirectory -File -Filter '*.ps1' -Depth 3) {
            $relativePath = [System.IO.Path]::GetRelativePath($SourceRoot, $file).Replace('\', '/')
            if ($relativePath.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase) -or
                $relativePath.StartsWith("$name/tests/", [System.StringComparison]::Ordinal) -or
                -not $Index.ContainsKey($relativePath)) {
                continue
            }
            $syntaxTree = $ParsedScripts.Get($file).Ast
            foreach ($read in [Catzc.Base.Repository.SyntaxSearch]::CommandsNamed($syntaxTree, 'Get-Config', $false)) {
                $elements = $read.CommandElements
                $isOwnerScoped = @($elements | Where-Object {
                        $_ -is [System.Management.Automation.Language.CommandParameterAst] -and $_.ParameterName -in 'ListOwners', 'Module'
                    }).Count -gt 0
                if ($isOwnerScoped) {
                    continue
                }
                $argument = $null
                for ($position = 1; $position -lt $elements.Count; $position++) {
                    $element = $elements[$position]
                    if ($element -is [System.Management.Automation.Language.CommandParameterAst]) {
                        if ($element.ParameterName -ieq 'Config' -and $position + 1 -lt $elements.Count) {
                            $argument = $elements[$position + 1]
                        }
                        break
                    }
                    $argument = $element
                    break
                }
                if ($argument -isnot [System.Management.Automation.Language.StringConstantExpressionAst]) {
                    continue
                }
                $config = $argument.Value
                $owners = @(foreach ($directory in [System.IO.Directory]::GetDirectories($SourceRoot)) {
                        $owner = [System.IO.Path]::GetFileName($directory)
                        if (-not $owner.StartsWith('.') -and [System.IO.File]::Exists([System.IO.Path]::Combine($directory, 'configs', "$config.yml"))) {
                            $owner
                        }
                    })
                if ($owners.Count -gt 0 -and -not @($owners | Where-Object { $selected.Contains($_) })) {
                    "$sourceFolder/${relativePath}:$($read.Extent.StartLineNumber): reads config '$config', which $($owners -join ', ') owns"
                }
            }
        }
    }
}

function Get-MergedModule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [Catzc.Base.Repository.ParsedScripts] $ParsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    )

    $sourceFolder = [System.IO.Path]::GetFileName($SourceRoot.TrimEnd('\', '/'))
    $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, $Name)
    $privateDirectory = [System.IO.Path]::Combine($moduleDirectory, 'private')

    $privateFiles = [string[]] @(if ([System.IO.Directory]::Exists($privateDirectory)) {
            foreach ($file in [System.IO.Directory]::GetFiles($privateDirectory, '*.ps1')) {
                if (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $file) {
                    $file
                }
            }
        })
    $publicFiles = [string[]] @(foreach ($file in [System.IO.Directory]::GetFiles($moduleDirectory, '*.ps1')) {
            if (-not $file.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase) -and
                (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $file)) {
                $file
            }
        })
    [System.Array]::Sort($privateFiles, [System.StringComparer]::Ordinal)
    [System.Array]::Sort($publicFiles, [System.StringComparer]::Ordinal)

    $violations = [System.Collections.Generic.List[string]]::new()
    if ($privateFiles.Count + $publicFiles.Count -eq 0) {
        $violations.Add("$sourceFolder/${Name}: has no function files, so there is nothing to build into a module")
    }

    $ordered = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $privateFiles) {
        $ordered.Add(@{ Path = $file; Relative = "$sourceFolder/$Name/private/$([System.IO.Path]::GetFileName($file))" })
    }
    foreach ($file in $publicFiles) {
        $ordered.Add(@{ Path = $file; Relative = "$sourceFolder/$Name/$([System.IO.Path]::GetFileName($file))" })
    }

    $blocks = [System.Collections.Generic.List[string]]::new()
    $blocks.Add("# $Name — generated by Invoke-ModuleBuild from the source module $Name/ (private/*.ps1, then *.ps1); do not edit.")
    foreach ($entry in $ordered) {
        foreach ($violation in @(Get-FunctionFileViolation -Path $entry.Path -RelativePath $entry.Relative -ParsedScripts $ParsedScripts)) {
            $violations.Add($violation)
        }
        $text = [System.IO.File]::ReadAllText($entry.Path).Replace("`r", '').TrimEnd("`n")
        $blocks.Add("# source: $($entry.Relative)`n$text")
    }

    $publics = [string[]] @(foreach ($file in $publicFiles) {
            [System.IO.Path]::GetFileNameWithoutExtension($file)
        })

    [pscustomobject]@{
        Name       = $Name
        Content    = ($blocks -join "`n`n") + "`n"
        Publics    = $publics
        Violations = $violations.ToArray()
    }
}

function Get-BuildFileCopy {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceDirectory,

        [Parameter(Mandatory)]
        [string] $TargetPath,

        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index,

        [string[]] $ExcludeDirectory = @(),

        [switch] $IncludeUntracked
    )

    if (-not [System.IO.Directory]::Exists($SourceDirectory)) {
        return
    }
    $sourceFull = [System.IO.Path]::GetFullPath($SourceDirectory)
    foreach ($file in Get-ChildPath $sourceFull -File -Depth 64 -Exclude @() -PruneVendor $false) {
        $relativePath = [System.IO.Path]::GetRelativePath($sourceFull, $file).Replace('\', '/')
        $segments = $relativePath.Split('/')
        $excluded = $false
        for ($position = 0; $position -lt $segments.Count - 1; $position++) {
            if ($segments[$position] -in $ExcludeDirectory) {
                $excluded = $true
                break
            }
        }
        if (-not $excluded -and ($IncludeUntracked -or (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $file))) {
            $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $file
            [pscustomobject]@{ Path = "$TargetPath/$relativePath"; Kind = 'Copy'; Source = $file; Content = $null; Exports = $null; Normalize = $normalize }
        }
    }
}

function Get-ModuleBuildPlan {
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
        $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, $name)
        if (-not [System.IO.Directory]::Exists($moduleDirectory)) {
            $violations.Add("$sourceFolder/${name}: the module folder does not exist")
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
            $copies = Get-BuildFileCopy -SourceDirectory ([System.IO.Path]::Combine($moduleDirectory, $folder)) -TargetPath "$name/$folder" -SourceRoot $SourceRoot -Index $Index -IncludeUntracked:($folder -eq 'types')
            foreach ($copy in @($copies)) {
                $entries.Add($copy)
            }
        }
    }

    # The runtime loader and its assets, plus the analyzer settings and rules under the full vendor policy.
    $internalFiles = @($script:runtimeInternalFiles) + @(if ($VendorPolicy -eq 'full') {
            $script:fullPolicyInternalFiles
        })
    foreach ($relativePath in $internalFiles) {
        $source = [System.IO.Path]::Combine($SourceRoot, '.internal', $relativePath)
        if (-not [System.IO.File]::Exists($source)) {
            $violations.Add("$sourceFolder/.internal/${relativePath}: the runtime loader file does not exist")
            continue
        }
        if (-not (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $source)) {
            $violations.Add("$sourceFolder/.internal/${relativePath}: the runtime loader file is ignored by git, and a bundle never ships an ignored file")
            continue
        }
        $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $source
        $entries.Add([pscustomobject]@{ Path = ".internal/$relativePath"; Kind = 'Copy'; Source = $source; Content = $null; Exports = $null; Normalize = $normalize })
    }
    if ($VendorPolicy -eq 'full') {
        foreach ($copy in @(Get-BuildFileCopy -SourceDirectory ([System.IO.Path]::Combine($SourceRoot, '.scriptanalyzer')) -TargetPath '.scriptanalyzer' -SourceRoot $SourceRoot -Index $Index -ExcludeDirectory 'tests')) {
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
            foreach ($copy in @(Get-BuildFileCopy -SourceDirectory ([System.IO.Path]::Combine($vendorRoot, $vendorName)) -TargetPath ".vendor/$vendorName" -SourceRoot $SourceRoot -Index $Index)) {
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

    $typeHash = $null
    $typeSources = [string[]] @()
    $hashResult = Get-CombinedTypeHash -ModulesRoot $SourceRoot
    if ($hashResult.CombinedHash) {
        $typeHash = $hashResult.CombinedHash
        $selectedModules = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::OrdinalIgnoreCase)
        $typeSources = [string[]] @(foreach ($file in $hashResult.Files) {
                if ($selectedModules.Contains($file.Module)) {
                    "$($file.Module)/types/$($file.Base).cs"
                }
                else {
                    ".compiled/types/$($file.Module)/$($file.Base).cs"
                }
            })
        foreach ($file in $hashResult.Files) {
            if (-not $selectedModules.Contains($file.Module)) {
                $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $file.Path
                $entries.Add([pscustomobject]@{ Path = ".compiled/types/$($file.Module)/$($file.Base).cs"; Kind = 'Copy'; Source = $file.Path; Content = $null; Exports = $null; Normalize = $normalize })
            }
        }
        $dllPath = ".compiled/Catzc.Types.$typeHash.dll"
        $committed = [System.IO.Path]::Combine($SourceRoot, '.compiled', "Catzc.Types.$typeHash.dll")
        $manifestPath = ".compiled/Catzc.Types.$typeHash.json"
        $committedManifest = [System.IO.Path]::Combine($SourceRoot, '.compiled', "Catzc.Types.$typeHash.json")
        if ([System.IO.File]::Exists($committed)) {
            $entries.Add([pscustomobject]@{ Path = $dllPath; Kind = 'Copy'; Source = $committed; Content = $null; Exports = $null; Normalize = $false })
            if ([System.IO.File]::Exists($committedManifest)) {
                $entries.Add([pscustomobject]@{ Path = $manifestPath; Kind = 'Copy'; Source = $committedManifest; Content = $null; Exports = $null; Normalize = $false })
            }
            else {
                $violations.Add("$sourceFolder/.compiled/Catzc.Types.$typeHash.json: the types manifest beside the committed assembly does not exist; run the importer")
            }
        }
        else {
            $entries.Add([pscustomobject]@{ Path = $dllPath; Kind = 'Types'; Source = $null; Content = $null; Exports = $null })
            $entries.Add([pscustomobject]@{ Path = $manifestPath; Kind = 'Types'; Source = $null; Content = $null; Exports = $null })
        }
    }

    [pscustomobject]@{
        Entries     = $entries.ToArray()
        Violations  = $violations.ToArray()
        TypesHash   = $typeHash
        TypeSources = $typeSources
    }
}

function Format-CatzcPackageManifest {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [hashtable] $PackageMetadata,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $FunctionToExport
    )

    $quote = {
        param([string] $Value)
        "'" + $Value.Replace("'", "''") + "'"
    }
    $listLiteral = {
        param([string[]] $Values)
        if ($Values.Count -eq 0) {
            return '@()'
        }
        $quoted = foreach ($value in $Values) {
            & $quote $value
        }
        '@(' + (@($quoted) -join ', ') + ')'
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('@{')
    $lines.Add("    RootModule        = 'Catzc.psm1'")
    $lines.Add("    ModuleVersion     = $(& $quote $Version)")
    $lines.Add("    GUID              = $(& $quote ([string] $PackageMetadata['Guid']))")
    $lines.Add("    Author            = $(& $quote ([string] $PackageMetadata['Author']))")
    $lines.Add("    CompanyName       = $(& $quote ([string] $PackageMetadata['CompanyName']))")
    $lines.Add("    Description       = $(& $quote ([string] $PackageMetadata['Description']))")
    $lines.Add("    PowerShellVersion = '7.4'")
    if ($FunctionToExport.Count -eq 0) {
        $lines.Add('    FunctionsToExport = @()')
    }
    else {
        $lines.Add('    FunctionsToExport = @(')
        foreach ($name in $FunctionToExport) {
            $lines.Add("        $(& $quote $name)")
        }
        $lines.Add('    )')
    }
    $lines.Add('    CmdletsToExport   = @()')
    $lines.Add('    VariablesToExport = @()')
    $lines.Add('    AliasesToExport   = @()')
    $lines.Add('    PrivateData       = @{')
    $lines.Add('        PSData = @{')
    $lines.Add("            Tags       = $(& $listLiteral ([string[]] @($PackageMetadata['Tags'] | Where-Object { $_ })))")
    foreach ($key in 'ProjectUri', 'LicenseUri') {
        $value = [string] $PackageMetadata[$key]
        if (-not [string]::IsNullOrWhiteSpace($value)) {
            $lines.Add("            $($key.PadRight(10)) = $(& $quote $value)")
        }
    }
    $lines.Add('        }')
    $lines.Add('    }')
    $lines.Add('}')
    ($lines -join "`n") + "`n"
}

function Copy-BuildFileIfChanged {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $Source,

        [Parameter(Mandatory)]
        [string] $Destination,

        [switch] $Normalize
    )

    [byte[]] $bytes = [System.IO.File]::ReadAllBytes($Source)
    if ($Normalize -and [System.Array]::IndexOf($bytes, [byte] 13) -ge 0) {
        $bytes = [System.Text.Encoding]::Latin1.GetBytes([System.Text.Encoding]::Latin1.GetString($bytes).Replace("`r`n", "`n"))
    }
    if ([System.IO.File]::Exists($Destination)) {
        if ([System.Linq.Enumerable]::SequenceEqual($bytes, [byte[]] [System.IO.File]::ReadAllBytes($Destination))) {
            return $false
        }
        [System.IO.File]::Delete($Destination)
    }
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Destination)) | Out-Null
    [System.IO.File]::WriteAllBytes($Destination, $bytes)
    $true
}

function Clear-StaleBuildFile {
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [System.Collections.Generic.HashSet[string]] $KeepPath
    )

    $removed = 0
    if (-not [System.IO.Directory]::Exists($BuildRoot)) {
        return $removed
    }
    foreach ($file in @(Get-ChildPath $BuildRoot -File -Depth 64 -Exclude @() -PruneVendor $false)) {
        $relativePath = [System.IO.Path]::GetRelativePath($BuildRoot, $file).Replace('\', '/')
        if (-not $KeepPath.Contains($relativePath)) {
            try {
                [System.IO.File]::Delete($file)
            }
            catch {
                throw "Invoke-ModuleBuild: cannot remove the stale build file '$file' ($($_.Exception.Message)). Close the session that loaded it, then rebuild."
            }
            $removed++
        }
    }
    # Deepest folders first, so a parent empties after its children.
    $folders = [string[]] @(Get-ChildPath $BuildRoot -Directory -Depth 64 -Exclude @() -PruneVendor $false)
    [System.Array]::Sort($folders, [System.Comparison[string]] { param($left, $right) $right.Length.CompareTo($left.Length) })
    foreach ($folder in $folders) {
        if (-not [System.IO.Directory]::EnumerateFileSystemEntries($folder).GetEnumerator().MoveNext()) {
            [System.IO.Directory]::Delete($folder)
        }
    }
    $removed
}

function Get-BuildSourceCommit {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        Get-GitCurrentCommit
    }
    catch {
        Write-Verbose "No source commit recorded: $($_.Exception.Message)"
        $null
    }
}

function Write-ModuleBuildOutput {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $BuildRoot,

        [Parameter(Mandatory)]
        [object[]] $Entries
    )

    $keep = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $Entries) {
        [void] $keep.Add($entry.Path)
    }
    [void] $keep.Add('build.json')
    [void] (Clear-StaleBuildFile -BuildRoot $BuildRoot -KeepPath $keep)
    [System.IO.Directory]::CreateDirectory($BuildRoot) | Out-Null

    $hadBootstrap = [bool] (Get-Module Catzc.Internal.Bootstrap)
    Import-InternalModule Bootstrap
    try {
        $bootstrap = Get-Module Catzc.Internal.Bootstrap
        foreach ($entry in $Entries) {
            $target = [System.IO.Path]::Combine($BuildRoot, $entry.Path)
            switch ($entry.Kind) {
                'Text' {
                    [void] (Write-FileIfChanged -Path $target -Content $entry.Content)
                }
                'Copy' {
                    [void] (Copy-BuildFileIfChanged -Source $entry.Source -Destination $target -Normalize:$entry.Normalize)
                }
                'Manifest' {
                    $moduleFolder = [System.IO.Path]::GetDirectoryName($target)
                    $nestedModule = [System.IO.Path]::GetFileName($moduleFolder) + $script:mergedFileSuffix
                    $exports = [string[]] @($entry.Exports)
                    & $bootstrap {
                        param($ModulePath, $NestedModule, $FunctionToExport)
                        New-DynamicManifest -ModulePath $ModulePath -NestedModule $NestedModule -FunctionToExport $FunctionToExport
                    } $moduleFolder $nestedModule $exports | Out-Null
                }
            }
        }
    }
    finally {
        if (-not $hadBootstrap) {
            Remove-Module Catzc.Internal.Bootstrap -Force -ErrorAction Ignore
        }
    }

    if (@($Entries | Where-Object { $_.Kind -eq 'Types' }).Count -gt 0) {
        Build-CombinedTypeAssembly -ModulesRoot $SourceRoot -OutputDirectory ([System.IO.Path]::Combine($BuildRoot, '.compiled'))
    }
}

function Invoke-ModuleBuild {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Module,

        [string] $ModuleProfile,

        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,

        [Parameter(Mandatory)]
        [string] $Destination,

        [Parameter(Mandatory)]
        [string] $Bundle,

        [Parameter(Mandatory)]
        [hashtable] $PackageMetadata,

        [switch] $DryRun
    )

    Assert-SourceTree -Command 'Invoke-ModuleBuild'
    if (-not $ModuleProfile -and @($Module | Where-Object { $_ }).Count -eq 0) {
        throw 'Invoke-ModuleBuild: name the modules to build with -Module, -ModuleProfile, or both.'
    }
    if ($Version -notmatch '^\d+\.\d+\.\d+$') {
        throw "Invoke-ModuleBuild: -Version '$Version' is not MAJOR.MINOR.PATCH; resolve 'auto' before calling the engine (Resolve-CatzcBuildVersion)."
    }
    $guid = [guid]::Empty
    if (-not [guid]::TryParse([string] $PackageMetadata['Guid'], [ref] $guid)) {
        throw "Invoke-ModuleBuild: -PackageMetadata Guid '$($PackageMetadata['Guid'])' is not a GUID."
    }
    foreach ($key in 'Author', 'Description') {
        if ([string]::IsNullOrWhiteSpace([string] $PackageMetadata[$key])) {
            throw "Invoke-ModuleBuild: -PackageMetadata $key is required for Catzc.psd1."
        }
    }

    $sourceRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) (Get-CatzcModulesFolder)))
    $buildRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($Destination, 'Catzc', $Version))
    $modules = [string[]] @(Resolve-BuildModuleSet -Module $Module -ModuleProfile $ModuleProfile)

    $index = Get-BuildSourceIndex -SourceRoot $sourceRoot
    $dirty = Test-BuildSourceDirty -SourceRoot $sourceRoot
    if ($dirty -and (Test-IsRunningInPipeline)) {
        throw 'Invoke-ModuleBuild: the source tree differs from its commit (git status lists changes under the modules folder). A pipeline builds only a clean commit, so the bundle is that commit''s bytes.'
    }

    Import-InternalModule Types
    $parsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    $plan = Get-ModuleBuildPlan -SourceRoot $sourceRoot -Module $modules -Version $Version -VendorPolicy $VendorPolicy -PackageMetadata $PackageMetadata -Index $index -ParsedScripts $parsedScripts
    if ($plan.Violations.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($plan.Violations.Count) problem(s) in the source tree prevent the build (merge preconditions, ADR-PWSH-MANIFEST-BUNDLECARRIESMANIFESTS):`n  " +
            ($plan.Violations -join "`n  "))
    }

    # The closure check: the code itself, not only dependencies.yml, must be satisfied by the selection.
    $outside = @(Get-BuildClosureViolation -SourceRoot $sourceRoot -Module $modules -Index $index -ParsedScripts $parsedScripts)
    if ($outside.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($outside.Count) call(s) or config read(s) of the selected modules land outside the build (ADR-AUTO-BUNDLE-IMMUTABLEBUILD). " +
            "Declare the dependency in dependencies.yml so the closure brings the owner in, or add the owning module to the build:`n  " + ($outside -join "`n  "))
    }

    $plannedPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $plan.Entries) {
        [void] $plannedPaths.Add($entry.Path)
    }
    $missing = [System.Collections.Generic.List[string]]::new()
    $dependencies = @(if ($modules.Count -gt 0) {
            Get-InternalAssetDependency -ModulesRoot $sourceRoot -Module $modules -ParsedScripts $parsedScripts
        })
    foreach ($dependency in $dependencies) {
        $childPath = ([string] $dependency.ChildPath).Replace('\', '/').TrimEnd('/')
        while ($childPath.StartsWith('./')) {
            $childPath = $childPath.Substring(2)
        }
        $target = if ($childPath) {
            "$($dependency.Module)/$childPath"
        }
        else {
            [string] $dependency.Module
        }
        $prefix = "$target/"
        $present = $plannedPaths.Contains($target)
        foreach ($plannedPath in $plannedPaths) {
            if ($present) {
                break
            }
            $present = $plannedPath.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)
        }
        if (-not $present) {
            $missing.Add("$target (read by $($dependency.Function), $($dependency.File):$($dependency.Line))")
        }
    }
    if ($missing.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($missing.Count) internal asset dependency path(s) would be missing from the build (ADR-AUTO-ASSETDEP-ENFORCEDMECHANICALLY). " +
            "Ship the asset in the module's configs/ or assets/, or add the owning module to the build:`n  " + ($missing -join "`n  "))
    }

    $fileCount = $plan.Entries.Count + 1
    if ($DryRun) {
        return [pscustomobject]@{
            BuildRoot   = $buildRoot
            Version     = $Version
            Modules     = $modules
            TypesHash   = $plan.TypesHash
            ContentHash = $null
            FileCount   = $fileCount
            Dirty       = $dirty
            DryRun      = $true
        }
    }

    $built = Write-ModuleBuildOutput -SourceRoot $sourceRoot -BuildRoot $buildRoot -Entries $plan.Entries
    if ($null -ne $built -and $built.Hash -ne $plan.TypesHash) {
        throw "Invoke-ModuleBuild: C# type sources changed during the build ($($plan.TypesHash) -> $($built.Hash)). Rebuild."
    }

    $contentHash = Get-CatzcContentHash -Path $buildRoot -Exclude 'build.json'
    $record = [ordered]@{
        name         = 'Catzc'
        bundle       = $Bundle
        version      = $Version
        contentHash  = $contentHash
        typesHash    = $plan.TypesHash
        typeSources  = [string[]] @($plan.TypeSources)
        sourceCommit = Get-BuildSourceCommit
        dirty        = $dirty
        vendorPolicy = $VendorPolicy
        modules      = $modules
    }
    [void] (Write-FileIfChanged -Path ([System.IO.Path]::Combine($buildRoot, 'build.json')) -Content ($record | ConvertTo-Json -Depth 5))

    [pscustomobject]@{
        BuildRoot   = $buildRoot
        Version     = $Version
        Modules     = $modules
        TypesHash   = $plan.TypesHash
        ContentHash = $contentHash
        FileCount   = $fileCount
        Dirty       = $dirty
        DryRun      = $false
    }
}

Export-ModuleMember -Function Invoke-ModuleBuild
