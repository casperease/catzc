<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Builder.psm1
    kind: internal-module
---
#>

# It reads the per-function source tree, so it is loaded on demand after a source import and never ships in a build.
# [comment:1](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment1)

Set-StrictMode -Version Latest

# Quality-gate tools only: vendor_policy runtime leaves them out, every other vendored module always ships.
# [comment:2](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment2)
$script:testToolVendorModules = @('Pester', 'PSScriptAnalyzer')

# Only what Invoke-Importer -Bundle needs to boot; Builder and the tests never ship.
# [comment:3](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment3)
$script:runtimeInternalFiles = @(
    'Catzc.Internal.Bootstrap.psm1'
    'Catzc.Internal.Importer.psm1'
    'Catzc.Internal.Loader.psm1'
    'Catzc.Internal.Types.psm1'
    'Catzc.Internal.Vendor.psm1'
    'assets/ErrorView.format.ps1xml'
)

# The build run executes the test files, so a full build must carry the TestKit and the analyzer settings.
# [comment:4](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment4)
$script:fullPolicyInternalFiles = @(
    'Catzc.Internal.TestKit.psm1'
    'assets/PSScriptAnalyzerSettings.psd1'
)

# A nested script module is named for its file, so a plain Module.ps1 would load a second module of that name.
# [comment:5](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment5)
$script:mergedFileSuffix = '.functions.ps1'

# Everything else in a module folder (private, tests, README, the source-mode manifest) stays out of a build.
# [comment:6](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment6)
$script:shippedSideFolders = @('assets', 'configs', 'types')

function Get-BuildSourceIndex {
    <#
    .SYNOPSIS
        Returns the files a build may ship — the tracked files and the untracked files git does not ignore — each
        marked with whether git stores it with LF-only line endings.
    .DESCRIPTION
        An untracked file that is not ignored ships and dirties the tree, which a pipeline refuses.
        [comment:7](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment7)
    .OUTPUTS
        [System.Collections.Generic.Dictionary[string, bool]] source-root-relative, forward-slashed path -> LF-only.
    #>
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
    <#
    .SYNOPSIS
        Returns whether the source root differs from its commit: a modified, staged, deleted or untracked file.
    .DESCRIPTION
        Content decides, not stat data: a checkout with other line endings is still the same commit.
        [comment:8](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment8)
    #>
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
    <#
    .SYNOPSIS
        Returns whether a source file ships LF-normalised: it is tracked and git stores it with LF-only endings.
    #>
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
    <#
    .SYNOPSIS
        Returns whether a source file may ship in a build: tracked by git, or untracked and not ignored.
    #>
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
    <#
    .SYNOPSIS
        Returns the closure-expanded, ordinally sorted module set of a build: the union of a profile and explicit
        module names, each expanded through Get-ModuleProfile (dependencies.yml).
    #>
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
    <#
    .SYNOPSIS
        Returns every call and config read of the selected modules that lands outside the selection.
    .DESCRIPTION
        Proves the closure from the code, because dependencies.yml leaves an unlisted module unconstrained.
        [comment:9](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment9)
    #>
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

    $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::Ordinal)

    foreach ($call in @(Get-FunctionDependency -AutomationRoot $SourceRoot -ParsedScripts $ParsedScripts)) {
        if ($call.CrossModule -and $selected.Contains($call.CallerModule) -and -not $selected.Contains($call.TargetModule)) {
            "automation/$($call.CallerModule)/$($call.CallerFile):$($call.CallerLine): $($call.CallerFunction) calls $($call.TargetFunction), which $($call.TargetModule) owns"
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
                # Only the owners present are read, so an owner missing from the build is not a gap.
                # [comment:10](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment10)
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
                    "automation/${relativePath}:$($read.Extent.StartLineNumber): reads config '$config', which $($owners -join ', ') owns"
                }
            }
        }
    }
}

function Get-MergedModule {
    <#
    .SYNOPSIS
        Merges one source module's function files into the text of its built <Module>.functions.ps1.
    .DESCRIPTION
        Same order as the source manifest's NestedModules, so load semantics match source mode.
        [comment:11](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment11)
    #>
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
        $violations.Add("automation/${Name}: has no function files, so there is nothing to build into a module")
    }

    $ordered = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $privateFiles) {
        $ordered.Add(@{ Path = $file; Relative = "automation/$Name/private/$([System.IO.Path]::GetFileName($file))" })
    }
    foreach ($file in $publicFiles) {
        $ordered.Add(@{ Path = $file; Relative = "automation/$Name/$([System.IO.Path]::GetFileName($file))" })
    }

    $blocks = [System.Collections.Generic.List[string]]::new()
    $blocks.Add("# $Name — generated by Invoke-ModuleBuild from automation/$Name/ (private/*.ps1, then *.ps1); do not edit.")
    foreach ($entry in $ordered) {
        # Shared with the consumer overlay, which loads a function file into a built module the same way.
        # [comment:12](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment12)
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
    <#
    .SYNOPSIS
        Lists the plan entries that copy a source folder's tracked files to a build-relative folder.
    .PARAMETER SourceDirectory
        The folder whose files are copied (recursively).
    .PARAMETER TargetPath
        The build-relative, forward-slashed folder the files land in.
    .PARAMETER SourceRoot
        The source root the index paths are relative to.
    .PARAMETER Index
        The files that may ship and their line-ending form (Get-BuildSourceIndex); an ignored file is skipped.
    .PARAMETER ExcludeDirectory
        Folder names (at any depth) whose contents are skipped — e.g. tests.
    .PARAMETER IncludeUntracked
        Only the types folders take it: their sources must equal the type set that the DLL name proves.
        [comment:13](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment13)
    #>
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
    # A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the build
    # copies every shippable file, so nothing is pruned here.
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
    <#
    .SYNOPSIS
        Computes every file a build writes, from the source tree alone, and collects every reason it cannot.
    .DESCRIPTION
        Reads sources and writes nothing, so the plan can be checked or returned before any write.
        [comment:14](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment14)
    #>
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

    $entries = [System.Collections.Generic.List[object]]::new()
    $violations = [System.Collections.Generic.List[string]]::new()
    $allPublics = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

    foreach ($name in $Module) {
        $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, $name)
        if (-not [System.IO.Directory]::Exists($moduleDirectory)) {
            $violations.Add("automation/${name}: the module folder does not exist")
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
        foreach ($folder in $script:shippedSideFolders) {
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
            $violations.Add("automation/.internal/${relativePath}: the runtime loader file does not exist")
            continue
        }
        if (-not (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $source)) {
            $violations.Add("automation/.internal/${relativePath}: the runtime loader file is ignored by git, and a bundle never ships an ignored file")
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
        $violations.Add('automation/.internal/assets/Import-Catzc.ps1: the build initializer does not exist')
    }
    elseif (-not (Test-BuildSourceShippable -Index $Index -SourceRoot $SourceRoot -Path $initializer)) {
        $violations.Add('automation/.internal/assets/Import-Catzc.ps1: the build initializer is ignored by git, and a bundle never ships an ignored file')
    }
    else {
        $normalize = Test-BuildSourceLfOnly -Index $Index -SourceRoot $SourceRoot -Path $initializer
        $entries.Add([pscustomobject]@{ Path = 'Import-Catzc.ps1'; Kind = 'Copy'; Source = $initializer; Content = $null; Exports = $null; Normalize = $normalize })
    }
    $rootModule = @(
        '# Catzc root module — generated by Invoke-ModuleBuild; do not edit. Import-Module Catzc runs the same initializer'
        '# a caller can dot-source, Import-Catzc.ps1 (docs/adr/automation/platform-bundle.md).'
        ". (Join-Path `$PSScriptRoot 'Import-Catzc.ps1')"
    ) -join "`n"
    $entries.Add([pscustomobject]@{ Path = 'Catzc.psm1'; Kind = 'Text'; Source = $null; Content = $rootModule; Exports = $null })
    $packageExports = [string[]] @($allPublics)
    [System.Array]::Sort($packageExports, [System.StringComparer]::Ordinal)
    $packageManifest = Format-CatzcPackageManifest -Version $Version -PackageMetadata $PackageMetadata -FunctionToExport $packageExports
    $entries.Add([pscustomobject]@{ Path = 'Catzc.psd1'; Kind = 'Text'; Source = $null; Content = $packageManifest; Exports = $null })

    # Always the full type set, so a build loads the same types as source mode whatever modules are selected.
    # [comment:15](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment15)
    $typeHash = $null
    $typeSources = [string[]] @()
    $hashResult = Get-CombinedTypeHash -AutomationRoot $SourceRoot
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
        # A devbox that changed a types source holds the matching DLL before commit, so its name, not git, proves it.
        # [comment:16](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment16)
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
                $violations.Add("automation/.compiled/Catzc.Types.$typeHash.json: the types manifest beside the committed assembly does not exist; run the importer")
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
    <#
    .SYNOPSIS
        Renders the package manifest Catzc.psd1 as canonical, deterministic text.
    .DESCRIPTION
        Not New-ModuleManifest, whose generation date would make the same commit yield different bytes.
        [comment:17](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment17)
    #>
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
    <#
    .SYNOPSIS
        Copies a file, only when the target is missing or differs. Returns whether it wrote.
    .DESCRIPTION
        Normalize yields the bytes git stores for an LF-only file, whatever line endings the checkout wrote.
        [comment:18](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment18)
    #>
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
    <#
    .SYNOPSIS
        Deletes every file under the build root that the plan does not name, then every emptied folder.
    .DESCRIPTION
        A file that cannot be deleted fails the build with its path, rather than leave a second types DLL.
        [comment:19](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment19)
    #>
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
    # A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a stale
    # file anywhere under the build root must go, so nothing is pruned.
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
    <#
    .SYNOPSIS
        Returns the commit the build was made from, or $null when git cannot answer (no work tree, no git).
    #>
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
    <#
    .SYNOPSIS
        Converges the build root to a plan: writes what differs, compiles the types, prunes what the plan omits.
    .OUTPUTS
        [pscustomobject] Built — the combined-types build result, or $null when the selection ships no type.
    #>
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

    # The bootstrap leaves the session after an import, so it is loaded for the build and removed if this call did.
    # [comment:20](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment20)
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

    # An existing DLL of the same hash is kept, so a rebuild of the same sources compiles nothing.
    # [comment:21](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment21)
    if (@($Entries | Where-Object { $_.Kind -eq 'Types' }).Count -gt 0) {
        Build-CombinedTypeAssembly -AutomationRoot $SourceRoot -OutputDirectory ([System.IO.Path]::Combine($BuildRoot, '.compiled'))
    }
}

function Invoke-ModuleBuild {
    <#
    .SYNOPSIS
        Builds the selected modules into one installable, versioned Catzc package — build mode's code root.
    .DESCRIPTION
        The engine writes no console output; its caller reports the result.
        [comment:22](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment22)
    .PARAMETER Module
        Explicit module names. Combined with -ModuleProfile; at least one of the two is required.
    .PARAMETER ModuleProfile
        A profiles.yml key.
    .PARAMETER Version
        The resolved MAJOR.MINOR.PATCH version (the engine never resolves 'auto').
    .PARAMETER VendorPolicy
        Full also ships the analyzer rules and settings, because the build run executes the tests.
        [comment:23](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment23)
    .PARAMETER Destination
        The parent folder; the build goes to <Destination>/Catzc/<Version>/.
    .PARAMETER Bundle
        The named bundle this build is (an exporter.yml bundles key), recorded in build.json.
    .PARAMETER PackageMetadata
        Catzc.psd1 metadata: Guid, Author, CompanyName, Description, Tags, ProjectUri, LicenseUri.
    .PARAMETER DryRun
        A dry run still runs every check, since all checks run before anything is written.
        [comment:24](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment24)
    .OUTPUTS
        [pscustomobject] BuildRoot, Version, Modules, TypesHash, ContentHash ($null under -DryRun), FileCount,
        Dirty, DryRun.
    .EXAMPLE
        Invoke-ModuleBuild -ModuleProfile full -Version 6.6.666 -VendorPolicy runtime -Destination (Join-Path (Get-OutputRoot) 'automation/built/full') -Bundle full -PackageMetadata $metadata
    #>
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

    $sourceRoot = [System.IO.Path]::GetFullPath((Join-Path (Get-RepositoryRoot) 'automation'))
    $buildRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($Destination, 'Catzc', $Version))
    $modules = [string[]] @(Resolve-BuildModuleSet -Module $Module -ModuleProfile $ModuleProfile)

    $index = Get-BuildSourceIndex -SourceRoot $sourceRoot
    $dirty = Test-BuildSourceDirty -SourceRoot $sourceRoot
    if ($dirty -and (Test-IsRunningInPipeline)) {
        throw 'Invoke-ModuleBuild: the source tree differs from its commit (git status lists changes under automation/). A pipeline builds only a clean commit, so the bundle is that commit''s bytes.'
    }

    Import-InternalModule Types
    $parsedScripts = [Catzc.Base.Repository.ParsedScripts]::new()
    $plan = Get-ModuleBuildPlan -SourceRoot $sourceRoot -Module $modules -Version $Version -VendorPolicy $VendorPolicy -PackageMetadata $PackageMetadata -Index $index -ParsedScripts $parsedScripts
    if ($plan.Violations.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($plan.Violations.Count) problem(s) in the source tree prevent the build (merge preconditions, ADR-PWSH-MANIFEST#5):`n  " +
            ($plan.Violations -join "`n  "))
    }

    # The closure check: the code itself, not only dependencies.yml, must be satisfied by the selection.
    $outside = @(Get-BuildClosureViolation -SourceRoot $sourceRoot -Module $modules -Index $index -ParsedScripts $parsedScripts)
    if ($outside.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($outside.Count) call(s) or config read(s) of the selected modules land outside the build (ADR-AUTO-BUNDLE#5). " +
            "Declare the dependency in dependencies.yml so the closure brings the owner in, or add the owning module to the build:`n  " + ($outside -join "`n  "))
    }

    # Checked against the plan, not the disk, so a missing asset fails before any write.
    # [comment:25](/docs/references/automation/internal/Catzc.Internal.Builder.psm1.md#comment25)
    $plannedPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $plan.Entries) {
        [void] $plannedPaths.Add($entry.Path)
    }
    $missing = [System.Collections.Generic.List[string]]::new()
    $dependencies = @(if ($modules.Count -gt 0) {
            Get-InternalAssetDependency -AutomationRoot $sourceRoot -Module $modules -ParsedScripts $parsedScripts
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
        throw ("Invoke-ModuleBuild: $($missing.Count) internal asset dependency path(s) would be missing from the build (ADR-AUTO-ASSETDEP#4). " +
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
