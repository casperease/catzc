# Catzc.Internal.Builder — the build-mode engine (Invoke-ModuleBuild).
#
# Builds the selected modules into one installable, versioned Catzc package
# ([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md),
# [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): every module stays its own PowerShell module of the same name, its
# function files
# merged into one <Module>.functions.ps1 behind a generated manifest, beside the runtime loader (.internal), the vendored
# dependencies (.vendor), the full combined-types DLL and its sources (.compiled) and the package entry points. It
# is a .internal multi-function module (the one-function-per-file convention does not apply), loaded on demand
# (Import-InternalModule Builder) by Build-Modules after a normal source-mode import, so it calls catzc public
# functions (Get-ModuleProfile, Write-FileIfChanged, Get-InternalAssetDependency, Get-CatzcContentHash, ...). It
# reads the per-function source tree, so it never ships in a build itself.

Set-StrictMode -Version Latest

# Vendored modules that serve only the quality gates — the two the importer loads lazily. vendor_policy 'runtime'
# leaves them out; every other vendored module is a runtime dependency and always ships.
$script:testToolVendorModules = @('Pester', 'PSScriptAnalyzer')

# The runtime loader a build carries under .internal/: Import-Catzc.ps1 boots Invoke-Importer -Bundle, which loads
# Bootstrap, Types and Vendor and applies the error view. Builder and the tests never ship.
$script:runtimeInternalFiles = @(
    'Catzc.Internal.Bootstrap.psm1'
    'Catzc.Internal.Importer.psm1'
    'Catzc.Internal.Loader.psm1'
    'Catzc.Internal.Types.psm1'
    'Catzc.Internal.Vendor.psm1'
    'assets/ErrorView.format.ps1xml'
)

# What a test-capable build (vendor_policy 'full') adds: the analyzer settings, which travel with the analyzer like
# .scriptanalyzer/, and the TestKit the test files load (Import-InternalModule TestKit) — the build run executes them.
$script:fullPolicyInternalFiles = @(
    'Catzc.Internal.TestKit.psm1'
    'assets/PSScriptAnalyzerSettings.psd1'
)

# The merged function file of a built module is <Module>.functions.ps1, never <Module>.ps1: a nested script
# module is named for its file, so <Module>.ps1 would load a second module named <Module> under the manifest's,
# and Get-Module <Module>, Mock -ModuleName and InModuleScope would each see two modules of that name.
$script:mergedFileSuffix = '.functions.ps1'

# A module's side folders that ship verbatim; everything else in the module folder (private/, tests/, README.md,
# the source-mode manifest) does not.
$script:shippedSideFolders = @('assets', 'configs', 'types')

function Get-BuildSourceIndex {
    <#
    .SYNOPSIS
        Returns the files a build may ship — the tracked files and the untracked files git does not ignore — each
        marked with whether git stores it with LF-only line endings.
    .DESCRIPTION
        Ignored files (bin/, obj/, local scratch) never reach a bundle. An untracked file that is not ignored is new
        work on a devbox, so it ships, and it makes the tree dirty; a pipeline refuses a dirty tree, so a released
        bundle is always exactly its commit's tracked files. The mark drives the one normalisation rule
        ([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)): a file whose index
        form is LF-only is written LF-only, which undoes whatever line-ending conversion the checkout applied;
        every other file (CRLF-stored, mixed, binary, no line ending, untracked) is a byte copy. On a clean tree the
        build therefore ships exactly the bytes git stores, on any OS and under any core.autocrlf.
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
        Content decides, not file metadata: git diff compares each file as git would store it with HEAD, so a
        checkout whose line endings differ from another checkout's is still the same commit. (git status goes by
        stat data first and calls such a file modified until the index is refreshed.) --no-optional-locks keeps
        both calls read-only. A tree with no commit to compare against counts as dirty.
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
        The declared closure (dependencies.yml) leaves a module it does not list unconstrained, so a partial
        build can miss a module the code really needs; this proves the closure from the code itself
        ([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)):

          commands  every call a selected module makes to a catzc function (Get-FunctionDependency) targets a
                    selected module
          configs   every Get-Config whose config name is a literal (-Config <name>, or the first positional
                    argument) reads a config that a selected module owns (<Module>/configs/<name>.yml); a
                    read scoped by owner (-ListOwners, -Module) reads only the owners present, so it is exempt

        A config name that no module owns is left to Get-Config itself, which fails the same way in source mode.
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
        [System.Collections.Generic.Dictionary[string, bool]] $Index
    )

    $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::Ordinal)

    foreach ($call in @(Get-FunctionDependency -AutomationRoot $SourceRoot)) {
        if ($call.CrossModule -and $selected.Contains($call.CallerModule) -and -not $selected.Contains($call.TargetModule)) {
            "automation/$($call.CallerModule)/$($call.CallerFile):$($call.CallerLine): $($call.CallerFunction) calls $($call.TargetFunction), which $($call.TargetModule) owns"
        }
    }

    $isConfigRead = {
        param($node)
        $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -ieq 'Get-Config'
    }
    foreach ($name in $Module) {
        $moduleDirectory = [System.IO.Path]::Combine($SourceRoot, $name)
        if (-not [System.IO.Directory]::Exists($moduleDirectory)) {
            continue
        }
        foreach ($file in [System.IO.Directory]::EnumerateFiles($moduleDirectory, '*.ps1', [System.IO.SearchOption]::AllDirectories)) {
            $relativePath = [System.IO.Path]::GetRelativePath($SourceRoot, $file).Replace('\', '/')
            if ($relativePath.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase) -or
                $relativePath.StartsWith("$name/tests/", [System.StringComparison]::Ordinal) -or
                -not $Index.ContainsKey($relativePath)) {
                continue
            }
            $tokens = $null
            $parseErrors = $null
            $syntaxTree = [System.Management.Automation.Language.Parser]::ParseFile($file, [ref] $tokens, [ref] $parseErrors)
            foreach ($read in $syntaxTree.FindAll($isConfigRead, $true)) {
                $elements = $read.CommandElements
                # -ListOwners / -Module read a config that many modules may ship, owner by owner: only the owners
                # present are read, so an owner missing from the build is not a gap.
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
        Order is private/*.ps1 ordinal, then the root *.ps1 ordinal — the order the source manifest's NestedModules
        uses, so load semantics are identical. Files git ignores are never merged. Each file is taken verbatim (CR
        stripped, trailing newlines trimmed) behind one '# source: automation/<Module>/<path>' marker line.
        Returns the canonical text, the public (exported) function names, and every precondition violation of
        every file.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRoot,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, bool]] $Index
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
        # The one function-file check (Catzc.Base.Overlay), shared with the consumer overlay, which loads a function
        # file into a built module the same way the merge does.
        foreach ($violation in @(Get-FunctionFileViolation -Path $entry.Path -RelativePath $entry.Relative)) {
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
        Copy untracked files too. Only the types/ folders take it: their sources must equal the type set the DLL's
        name (typesHash) proves, and that set is every types/*.cs on disk, tracked or not. A pipeline builds a
        clean tree, where the two are the same.
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
    foreach ($file in [System.IO.Directory]::EnumerateFiles($sourceFull, '*', [System.IO.SearchOption]::AllDirectories)) {
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
        Pure with respect to the build destination: reads the source modules and infrastructure, writes nothing.
        Returns the plan entries (build-relative Path, Kind Text/Copy/Manifest/Types, Content or Source), the
        type-source hash, the union of the public functions, and the collected violations — merge preconditions
        ([ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), missing modules, missing
        infrastructure.
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
        [System.Collections.Generic.Dictionary[string, bool]] $Index
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
        $merged = Get-MergedModule -SourceRoot $SourceRoot -Name $name -Index $Index
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

    # The combined-types assembly is always the FULL type set, whatever modules are selected, so a build loads the
    # same types as source mode. The committed <source>/.compiled/Catzc.Types.<hash>.dll is reused by copy — its
    # name is the hash proof — and compiled into the build only when it is missing. A selected module's sources
    # ship in its own types/ folder (copied above); every other module's ship verbatim under
    # .compiled/types/<Module>/<File>.cs, a dot folder the importer never takes for a module. Together the two hold
    # the full set the hash covers; build.json lists every source by its build-relative path, in hash order.
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
        # The DLL is proven by its name, the hash of the type sources, not by git: a devbox that changed a
        # types/*.cs holds the matching DLL before it is committed. It is binary, so a byte copy.
        $dllPath = ".compiled/Catzc.Types.$typeHash.dll"
        $committed = [System.IO.Path]::Combine($SourceRoot, '.compiled', "Catzc.Types.$typeHash.dll")
        if ([System.IO.File]::Exists($committed)) {
            $entries.Add([pscustomobject]@{ Path = $dllPath; Kind = 'Copy'; Source = $committed; Content = $null; Exports = $null; Normalize = $false })
        }
        else {
            $entries.Add([pscustomobject]@{ Path = $dllPath; Kind = 'Types'; Source = $null; Content = $null; Exports = $null })
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
        Rendered here rather than by New-ModuleManifest, whose output carries a generation date and so differs on
        every build; the same commit must yield the same bytes
        ([ADR-AUTO-BUNDLE#5](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle5)). Values are single-quoted
        with
        embedded quotes doubled. Blank ProjectUri/LicenseUri are left out.
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
        A byte copy, except under -Normalize, which turns every CRLF into LF first: the bytes git stores for a
        file it holds LF-only (Get-BuildSourceIndex), whatever line endings the checkout wrote. The Latin-1
        round trip maps each byte to one char and back, so nothing but the CR bytes changes.
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
        What makes a rebuild converge instead of accumulate: a removed module, a dropped vendor module, a stale
        types DLL of an earlier hash. A file that cannot be deleted (a DLL loaded by another process) fails the
        build with its path, rather than leaving a second types DLL beside the current one.
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
    foreach ($file in @([System.IO.Directory]::EnumerateFiles($BuildRoot, '*', [System.IO.SearchOption]::AllDirectories))) {
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
    $folders = [string[]] @([System.IO.Directory]::EnumerateDirectories($BuildRoot, '*', [System.IO.SearchOption]::AllDirectories))
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

    # The manifests come from the bootstrap's canonical emitter (New-DynamicManifest -NestedModule
    # -FunctionToExport). The bootstrap leaves the session after an import, so it is loaded for the build and
    # removed again when this call loaded it.
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

    # Fallback when the committed DLL is missing: the one compile path (Build-CombinedTypeAssembly) over the full
    # type set. An existing DLL of the same hash is kept, so a rebuild of the same sources compiles nothing.
    if (@($Entries | Where-Object { $_.Kind -eq 'Types' }).Count -gt 0) {
        Build-CombinedTypeAssembly -AutomationRoot $SourceRoot -OutputDirectory ([System.IO.Path]::Combine($BuildRoot, '.compiled'))
    }
}

function Invoke-ModuleBuild {
    <#
    .SYNOPSIS
        Builds the selected modules into one installable, versioned Catzc package — build mode's code root.
    .DESCRIPTION
        The engine behind Build-Modules (Catzc.Base.Exporter;
        [ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). Resolves
        the module set (-Module and/or -ModuleProfile, closure-expanded over dependencies.yml), then converges
        <Destination>/Catzc/<Version>/ to:

          Catzc.psd1, Catzc.psm1, Import-Catzc.ps1   the package manifest, its RootModule, the initializer
          build.json                                 provenance: bundle, version, hashes, type sources, commit, dirty,
                                                     modules
          .internal/                                 the runtime loader (Loader, Importer, Types, Vendor, Bootstrap)
          .compiled/Catzc.Types.<hash>.dll           the full type set (the committed DLL, copied)
          .compiled/types/<Module>/<File>.cs         type sources of the modules not selected
          .vendor/                                   vendored modules per -VendorPolicy, verbatim
          <Module>/<Module>.psd1                     per module: generated manifest (NestedModules = the merged file)
          <Module>/<Module>.functions.ps1            per module: merged function files
          <Module>/{configs,assets,types}/           shipped side folders, verbatim — never tests/

        A build ships the files git tracks under the source root, plus the untracked files git does not ignore
        (new work on a devbox), never an ignored one, and writes each as git stores it: a file git holds LF-only
        is written LF-only whatever the checkout's line endings, every other file is a byte copy
        (Get-BuildSourceIndex). The same commit therefore yields the same bytes on any OS. A source tree that
        differs from its commit — an untracked file included — is recorded as dirty in build.json; a pipeline
        refuses to build one, so a released bundle is exactly its commit.

        Every check runs before anything is written, and each collects every violation before it throws: the
        merge preconditions of every source file
        ([ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), the closure check —
        every catzc call and literal config read of the selected modules lands in a selected module
        (Get-BuildClosureViolation) — and the presence
        check — every internal asset dependency of the selected modules (Get-InternalAssetDependency) is present in the planned output
        ([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)). Writes are
        converging: text through Write-FileIfChanged, copies only on a byte
        difference, and files the plan omits removed — so a rebuild of an unchanged commit writes nothing.

        The types assembly is always the full type set: the committed <source>/.compiled/Catzc.Types.<hash>.dll
        is copied (compiled into the build only when missing). Selected modules' sources ship in <Module>/types/,
        every other module's under .compiled/types/<Module>/<File>.cs. Because the DLL is a byte copy, the content
        hash (Get-CatzcContentHash) covers every file except build.json, the DLL included. The engine writes no
        console output; its caller reports the result.
    .PARAMETER Module
        Explicit module names. Combined with -ModuleProfile; at least one of the two is required.
    .PARAMETER ModuleProfile
        A profiles.yml key.
    .PARAMETER Version
        The resolved MAJOR.MINOR.PATCH version (the engine never resolves 'auto').
    .PARAMETER VendorPolicy
        runtime ships the runtime vendored modules only; full also ships Pester, PSScriptAnalyzer and the analyzer
        rules and settings, which the build run needs.
    .PARAMETER Destination
        The parent folder; the build goes to <Destination>/Catzc/<Version>/.
    .PARAMETER Bundle
        The named bundle this build is (an exporter.yml bundles key), recorded in build.json.
    .PARAMETER PackageMetadata
        Catzc.psd1 metadata: Guid, Author, CompanyName, Description, Tags, ProjectUri, LicenseUri.
    .PARAMETER DryRun
        Return the plan and write nothing
        ([ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)).
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
    $plan = Get-ModuleBuildPlan -SourceRoot $sourceRoot -Module $modules -Version $Version -VendorPolicy $VendorPolicy -PackageMetadata $PackageMetadata -Index $index
    if ($plan.Violations.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($plan.Violations.Count) problem(s) in the source tree prevent the build (merge preconditions, ADR-PWSH-MANIFEST#5):`n  " +
            ($plan.Violations -join "`n  "))
    }

    # The closure check: the code itself, not only dependencies.yml, must be satisfied by the selection.
    $outside = @(Get-BuildClosureViolation -SourceRoot $sourceRoot -Module $modules -Index $index)
    if ($outside.Count -gt 0) {
        throw ("Invoke-ModuleBuild: $($outside.Count) call(s) or config read(s) of the selected modules land outside the build (ADR-AUTO-BUNDLE#5). " +
            "Declare the dependency in dependencies.yml so the closure brings the owner in, or add the owning module to the build:`n  " + ($outside -join "`n  "))
    }

    # The presence check
    # ([ADR-AUTO-ASSETDEP#4](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep4)), checked
    # against the plan so a missing asset fails before any write.
    $plannedPaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $plan.Entries) {
        [void] $plannedPaths.Add($entry.Path)
    }
    $missing = [System.Collections.Generic.List[string]]::new()
    $dependencies = @(if ($modules.Count -gt 0) {
            Get-InternalAssetDependency -AutomationRoot $sourceRoot -Module $modules
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
        throw ("Invoke-ModuleBuild: $($missing.Count) internal asset dependenc(ies) would be missing from the build (ADR-AUTO-ASSETDEP#4). " +
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
