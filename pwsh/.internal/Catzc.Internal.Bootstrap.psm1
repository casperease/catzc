<#
---
catzc:
  docs: "../../docs/references/pwsh/internal/Catzc.Internal.Bootstrap.psm1.md"
  header: "generated"
---
#>

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

function Clear-CompiledType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot
    )

    $removed = 0
    $skipped = 0
    $compiledDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled')
    if ([System.IO.Directory]::Exists($compiledDir)) {
        foreach ($dll in [System.IO.Directory]::EnumerateFiles($compiledDir, '*.dll')) {
            try {
                [System.IO.File]::Delete($dll); $removed++
            }
            catch {
                $skipped++; Write-Verbose "Could not delete (in use?): $dll"
                continue
            }
            # The manifest belongs to its assembly's build: it goes with it, and stays with a locked one.
            [System.IO.File]::Delete([System.IO.Path]::ChangeExtension($dll, 'json'))
        }
    }

    Write-ImporterMessage "Cleared compiled type cache — building from source (removed $removed, skipped $skipped)"
}

function New-DynamicManifest {
    [CmdletBinding(DefaultParameterSetName = 'Derived')]
    param(
        [Parameter(Mandatory)]
        [string]$ModulePath,

        [switch]$ExportPrivates,

        [switch]$ReadOnly,

        [Parameter(Mandatory, ParameterSetName = 'Explicit')]
        [string[]]$NestedModule,

        [Parameter(Mandatory, ParameterSetName = 'Explicit')]
        [AllowEmptyCollection()]
        [string[]]$FunctionToExport
    )

    $moduleName = Split-Path $ModulePath -Leaf
    $manifestPath = Join-Path $ModulePath "$moduleName.psd1"

    if ($ReadOnly) {
        if (-not [System.IO.File]::Exists($manifestPath)) {
            throw "Read-only load: module '$moduleName' is missing its generated manifest ($manifestPath). Rebuild the bundle — Build-Modules pre-generates every module manifest."
        }
        return $manifestPath
    }

    if ($PSCmdlet.ParameterSetName -eq 'Explicit') {
        $content = Get-DynamicManifestContent -NestedModule $NestedModule -FunctionToExport $FunctionToExport -ExportAll:$ExportPrivates
        return (Write-DynamicManifest -Path $manifestPath -Content $content)
    }

    $pathPrefixLength = $ModulePath.Length + 1

    # Collect public .ps1 files (root level) — .NET API avoids Get-ChildItem pipeline overhead
    $publicFiles = @(foreach ($f in [System.IO.Directory]::EnumerateFiles($ModulePath, '*.ps1')) {
            if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $f
            }
        })

    # Collect private .ps1 files (private subfolder)
    $privatePath = Join-Path $ModulePath 'private'
    $privateFiles = @()
    if ([System.IO.Directory]::Exists($privatePath)) {
        foreach ($f in [System.IO.Directory]::GetFiles($privatePath, '*.ps1')) {
            $privateFiles += $f
        }
    }

    if ($publicFiles.Count -eq 0 -and $privateFiles.Count -eq 0) {
        Write-Verbose "No .ps1 files found in '$ModulePath'"
        return $null
    }

    $privateRelative = [string[]] @(foreach ($f in $privateFiles) {
            $f.Substring($pathPrefixLength).Replace('\', '/')
        })
    $publicRelative = [string[]] @(foreach ($f in $publicFiles) {
            $f.Substring($pathPrefixLength).Replace('\', '/')
        })
    [System.Array]::Sort($privateRelative, [System.StringComparer]::Ordinal)
    [System.Array]::Sort($publicRelative, [System.StringComparer]::Ordinal)
    $moduleFiles = [string[]] @($privateRelative + $publicRelative)

    $exportNames = [string[]] @(foreach ($f in $publicFiles) {
            [System.IO.Path]::GetFileNameWithoutExtension($f)
        })
    [System.Array]::Sort($exportNames, [System.StringComparer]::Ordinal)

    $content = Get-DynamicManifestContent -NestedModule $script:moduleFilesLoader -ModuleFile $moduleFiles -FunctionToExport $exportNames -ExportAll:$ExportPrivates
    Write-DynamicManifest -Path $manifestPath -Content $content
}

$script:moduleFilesLoader = '../.internal/assets/Import-ModuleFiles.ps1'

function Write-DynamicManifest {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Content
    )

    if ([System.IO.File]::Exists($Path) -and [System.IO.File]::ReadAllText($Path) -ceq $Content) {
        return $Path
    }
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $Content, $utf8NoBom)
    return $Path
}

function Get-DynamicManifestContent {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string[]] $NestedModule = @(),

        [string[]] $ModuleFile = @(),

        [string[]] $FunctionToExport = @(),

        [switch] $ExportAll
    )

    if ($NestedModule.Count) {
        $quoted = foreach ($m in $NestedModule) {
            "'$m'"
        }
        $nested = '@(' + ($quoted -join ', ') + ')'
    }
    else {
        $nested = '@()'
    }

    if ($ExportAll) {
        $exports = "@('*')"
    }
    elseif ($FunctionToExport.Count) {
        $quotedExports = foreach ($fn in $FunctionToExport) {
            "'$fn'"
        }
        $exports = '@(' + ($quotedExports -join ', ') + ')'
    }
    else {
        $exports = '@()'
    }

    $fields = [ordered]@{
        RootModule        = "''"
        ModuleVersion     = "'0.1.0'"
        PowerShellVersion = "'7.4'"
        NestedModules     = $nested
        FunctionsToExport = $exports
        CmdletsToExport   = '@()'
        VariablesToExport = '@()'
        AliasesToExport   = "@('*')"
    }
    if ($ModuleFile.Count) {
        $quotedFiles = foreach ($file in $ModuleFile) {
            "'$file'"
        }
        $fields['PrivateData'] = '@{ CatzcFiles = @(' + ($quotedFiles -join ', ') + ') }'
    }
    $width = 0
    foreach ($key in $fields.Keys) {
        if ($key.Length -gt $width) {
            $width = $key.Length
        }
    }

    $lines = foreach ($key in $fields.Keys) {
        '    {0} = {1}' -f $key.PadRight($width), $fields[$key]
    }
    "@{`n" + ($lines -join "`n") + "`n}`n"
}

function Import-CSharpTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Session-global by design: $global:__CatzcTypes (per-ModulesRoot hash+snapshot) must survive module reimport to detect C# source changes across the session, and $global:__CatzcLoadTimings collects import diagnostics')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$DiagnoseLoadTime,

        [switch]$PrebuiltOnly,

        # Only an interactive dot-source is console; a caller that says nothing gets the eager load (types-load.yml).
        [ValidateSet('console', 'headless')]
        [string]$HostKind = 'headless'
    )

    Import-InternalModule Types
    # The hash memo lives beside the shadow copies, machine-local like them; a bundle is read-only and hashes every file.
    $hashArguments = @{ ModulesRoot = $ModulesRoot }
    if (-not $PrebuiltOnly) {
        $hashArguments['StampPath'] = Get-TypesStampPath -ModulesRoot $ModulesRoot
    }
    $hashResult = Get-CombinedTypeHash @hashArguments
    if ($hashResult.Files.Count -eq 0) {
        return
    }

    $arr = [object[]]@(foreach ($file in $hashResult.Files) {
            $moduleName = $file.Module
            $base = $file.Base
            if ($base.Contains('.')) {
                throw "C# type file 'types/$base.cs' in module '$moduleName' must be named for the bare type only (e.g. 'CliResult.cs'); the namespace is derived from the module. Remove the dotted prefix."
            }
            $content = [System.IO.File]::ReadAllText($file.Path)
            if ($content -match '(?m)^\s*namespace\s+(\S+?)\s*;\s*$') {
                if ($Matches[1] -ne $moduleName) {
                    throw "C# type file 'types/$base.cs' in module '$moduleName' declares namespace '$($Matches[1])' but must declare 'namespace $moduleName;' (its module folder). Run Format-Types."
                }
            }
            elseif ($content -match '(?m)^\s*namespace\s+(\S+?)\s*\{') {
                throw "C# type file 'types/$base.cs' in module '$moduleName' uses a block-scoped namespace '$($Matches[1])'; it must declare a file-scoped 'namespace $moduleName;'. Run Format-Types."
            }
            else {
                throw "C# type file 'types/$base.cs' in module '$moduleName' declares no namespace; it must declare 'namespace $moduleName;' (its module folder). Run Format-Types."
            }
            [pscustomobject]@{
                Module = $moduleName
                Base   = $base
                Type   = "$moduleName.$base"
                Key    = $file.Key
                File   = "$moduleName/types/$base.cs"
                Path   = $file.Path
            }
        })
    $snapshot = $hashResult.Snapshot
    $combinedHash = $hashResult.CombinedHash

    if (-not (Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly -ErrorAction Ignore)) {
        $global:__CatzcTypes = @{}
    }
    $typeState = Get-LoadedTypeDrift -ModulesRoot $ModulesRoot -HashResult $hashResult
    $loaded = $typeState.Loaded
    $rootKey = $typeState.RootKey
    if (-not $typeState.Current) {
        $changeSummary = $typeState.Summary
        if ($typeState.Drift.Count) {
            $changeSummary += ' Drifted: ' + ($typeState.Drift -join '; ') + '.'
        }
        if (Test-IsRunningInPipeline) {
            throw "$changeSummary Restart PowerShell to pick up the change."
        }
        # A throw cannot restart VS Code's terminal or host, so the session keeps the loaded assembly, whatever drifted, and names it.
        if (Test-IsRunningInVsCode) {
            $loadedDll = if ($typeState.LoadedHash) {
                $typeState.LoadedHash
            }
            else {
                'loaded for another root'
            }
            Write-ImporterMessage "Loaded inside VS Code with non-current types dll: $loadedDll (sources $($typeState.SourceHash); a new terminal loads them)" -ForegroundColor Yellow
            return
        }
        if ($typeState.MissingTypes.Count) {
            throw "$changeSummary Restart PowerShell to pick up the change."
        }
        $names = @($typeState.Drift | ForEach-Object { $_ -replace '^.*/', '' })
        $shown = ($names | Select-Object -First 5) -join ', '
        if ($names.Count -gt 5) {
            $shown += " and $($names.Count - 5) more"
        }
        Write-ImporterMessage "Using the old C# types, restart PowerShell to pick up the change: $shown" -ForegroundColor Yellow
        return
    }

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }
    $compiledDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled')
    $dll = [System.IO.Path]::Combine($compiledDir, ('Catzc.Types.{0}.dll' -f $combinedHash))

    $didCompile = $false
    if (-not [System.IO.File]::Exists($dll)) {
        if ($PrebuiltOnly) {
            throw "Bundle is missing its prebuilt combined-types assembly ($dll). The bundle is incomplete or corrupt — rebuild it (Build-Modules ships the DLL); a bundle never compiles types."
        }
        $built = Build-CombinedTypeAssembly -ModulesRoot $ModulesRoot -OutputDirectory $compiledDir
        if ($built.Hash -ne $combinedHash) {
            throw "C# type sources changed during the import ($combinedHash -> $($built.Hash)). Re-run the importer."
        }
        $didCompile = $true

        foreach ($old in [System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll')) {
            if ($old -eq $dll) {
                continue
            }
            try {
                [System.IO.File]::Delete($old)
            }
            catch {
                Write-Verbose "Skipped locked stale type DLL: $old"
                continue
            }
            [System.IO.File]::Delete([System.IO.Path]::ChangeExtension($old, 'json'))
        }

        $relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll)) -replace '\\', '/'
        Write-ImporterMessage "Built $relativeDll"
    }

    # The manifest is generated beside its DLL, so a DLL that predates it gets one here; a bundle never writes.
    $manifest = [System.IO.Path]::ChangeExtension($dll, 'json')
    if (-not [System.IO.File]::Exists($manifest)) {
        if ($PrebuiltOnly) {
            throw "Bundle is missing its prebuilt types manifest ($manifest). The bundle is incomplete or corrupt — rebuild it (Build-Modules ships the manifest beside the DLL)."
        }
        Write-TypesAssemblyManifest -Path $dll | Out-Null
    }

    $deferred = $false
    if (-not $loaded) {
        Test-TypesAssemblyContent -Path $dll -Expected $arr
        $policy = Get-TypesLoadPolicy -HostKind $HostKind -RunMode $(if ($PrebuiltOnly) {
                'build'
            }
            else {
                'source'
            })
        foreach ($eagerType in $policy.EagerTypes) {
            if ($eagerType -notin $arr.Type) {
                throw "The types-load config names eager type '$eagerType' for $($policy.Cell), but no module declares it."
            }
        }
        Register-DeferredTypes -RootKey $rootKey -Path $dll -ShadowCopy $policy.ShadowCopy
        $relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll)) -replace '\\', '/'
        if ($policy.Load -eq 'eager' -or $policy.EagerTypes.Count -gt 0) {
            foreach ($result in @(Initialize-Types)) {
                Write-ImporterMessage "Loaded types $relativeDll" -StateChange
                if ($result.Displayed -gt 0) {
                    Write-ImporterMessage "Registered default display properties for $($result.Displayed) type(s)" -StateChange
                }
            }
        }
        else {
            $deferred = $true
            Write-ImporterMessage "Deferred types $relativeDll (loaded by the first use)" -StateChange
        }
    }

    $global:__CatzcTypes[$rootKey] = [pscustomobject]@{ Hash = $combinedHash; Snapshot = $snapshot }

    if ($DiagnoseLoadTime) {
        $ms = [int]$sw.Elapsed.TotalMilliseconds
        $label = if ($deferred) {
            'verified, load deferred'
        }
        elseif ($didCompile -and $loaded) {
            'recompiled DLL, already loaded'
        }
        elseif ($didCompile) {
            'compile+load'
        }
        elseif ($loaded) {
            'already loaded'
        }
        else {
            'cache load'
        }
        Write-ImporterMessage ('    {0,6}ms  types (combined, {1} files) ({2})' -f $ms, $arr.Count, $label) -ForegroundColor DarkGray
        if ($null -ne (Get-Variable -Name '__CatzcLoadTimings' -Scope Global -ValueOnly -ErrorAction Ignore)) {
            $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = 'types (combined)'; Ms = $ms; ReadMs = 0; ImportMs = 0; FileCount = $arr.Count })
        }
    }
}

function Assert-UniqueModuleFunctionName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [System.IO.DirectoryInfo[]]$ModuleDirs,

        [switch]$ExportPrivates
    )

    # function name -> list of '<Module>/<relative path>' files that export it
    $sources = @{}

    foreach ($dir in $ModuleDirs) {
        $files = [System.Collections.Generic.List[string]]::new()
        foreach ($f in [System.IO.Directory]::EnumerateFiles($dir.FullName, '*.ps1')) {
            if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                $files.Add($f)
            }
        }
        if ($ExportPrivates) {
            $privatePath = [System.IO.Path]::Combine($dir.FullName, 'private')
            if ([System.IO.Directory]::Exists($privatePath)) {
                foreach ($f in [System.IO.Directory]::EnumerateFiles($privatePath, '*.ps1')) {
                    if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                        $files.Add($f)
                    }
                }
            }
        }

        foreach ($f in $files) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($f)
            $relative = $f.Substring($dir.FullName.Length + 1) -replace '\\', '/'
            if (-not $sources.ContainsKey($name)) {
                $sources[$name] = [System.Collections.Generic.List[string]]::new()
            }
            $sources[$name].Add("$($dir.Name)/$relative")
        }
    }

    $violations = [System.Collections.Generic.List[string]]::new()

    # 1) Two catzc modules exporting the same name — the module imported last silently shadows the others.
    foreach ($entry in $sources.GetEnumerator()) {
        if ($entry.Value.Count -gt 1) {
            $violations.Add("  $($entry.Key): defined by $($entry.Value -join ', ')")
        }
    }

    $shipped = @{}
    foreach ($m in Get-Module) {
        $base = $m.ModuleBase
        $isShipped = ($base -like "$PSHOME*") -or ($base -match '[\\/]\.vendor[\\/]') -or ($base -match '[\\/]\.internal([\\/]|$)')
        if (-not $isShipped) {
            continue
        }
        foreach ($cmdName in $m.ExportedCommands.Keys) {
            if (-not $shipped.ContainsKey($cmdName)) {
                $shipped[$cmdName] = $m.Name
            }
        }
    }
    foreach ($entry in $sources.GetEnumerator()) {
        if ($shipped.ContainsKey($entry.Key)) {
            $where = $entry.Value -join ', '
            $violations.Add("  $($entry.Key): $where would shadow imported command from '$($shipped[$entry.Key])'")
        }
    }

    if ($violations.Count) {
        $sorted = $violations | Sort-Object
        $lines = @(
            'Function name collision(s) detected before import. Each module function name must be unique'
            'across modules AND must not shadow an already-imported (vendored/built-in) command:'
        ) + $sorted
        throw ($lines -join "`n")
    }
}

function Get-ForeignCatzcModule {
    [CmdletBinding()]
    [OutputType([psmoduleinfo])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [switch] $IncludeInternal
    )

    $separators = [char[]] @('\', '/')
    $root = [System.IO.Path]::GetFullPath($ModulesRoot).TrimEnd($separators)
    $rootPrefix = $root + [System.IO.Path]::DirectorySeparatorChar
    $packageRoot = [System.IO.Path]::GetDirectoryName($root)
    $ignoreCase = [System.StringComparison]::OrdinalIgnoreCase

    foreach ($module in Get-Module) {
        if ($module.Name -ne 'Catzc' -and $module.Name -notlike 'Catzc.*') {
            continue
        }
        if (-not $IncludeInternal -and $module.Name -like 'Catzc.Internal.*') {
            continue
        }
        if ([string]::IsNullOrEmpty($module.ModuleBase)) {
            continue
        }
        $base = [System.IO.Path]::GetFullPath($module.ModuleBase).TrimEnd($separators)
        if ($base.Equals($root, $ignoreCase) -or $base.StartsWith($rootPrefix, $ignoreCase)) {
            continue
        }
        if ($module.Name -eq 'Catzc' -and $packageRoot -and $base.Equals($packageRoot, $ignoreCase)) {
            continue
        }
        $module
    }
}

function Import-AllModules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__CatzcLoadTimings is session-global import diagnostics collected across all modules, surfaced by importer.ps1 -DiagnoseLoadTime')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$ExportPrivates,

        [switch]$DiagnoseLoadTime,

        [switch]$Bundle,

        # The importer passes console for an interactive dot-source; the types-load policy decides lazy or eager from it.
        [ValidateSet('console', 'headless')]
        [string]$HostKind = 'headless'
    )

    $moduleDirs = [System.IO.DirectoryInfo]::new($ModulesRoot).GetDirectories() |
        Where-Object { $_.Name -notmatch '^\.' }

    Assert-UniqueModuleFunctionName -ModuleDirs $moduleDirs -ExportPrivates:$ExportPrivates

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }

    $stale = @(Get-Module |
            Where-Object {
                $_.Path -like "$ModulesRoot*" -and $_.Name -ne 'Bootstrap' -and
                $_.Path -notlike '*/.vendor/*' -and $_.Path -notlike '*\.vendor\*' -and
                $_.Path -notlike '*/.internal/*' -and $_.Path -notlike '*\.internal\*'
            })
    foreach ($module in $stale) {
        Write-Verbose "Removing stale module: $($module.Name)"
        Remove-Module $module.Name -Force -ErrorAction SilentlyContinue
    }

    $rootInternal = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($ModulesRoot, '.internal')).TrimEnd('\', '/')
    $evicted = [System.Collections.Generic.List[string]]::new()
    foreach ($foreign in @(Get-ForeignCatzcModule -ModulesRoot $ModulesRoot -IncludeInternal)) {
        $isInternal = $foreign.Name -like 'Catzc.Internal.*'
        $hasLocal = $isInternal -and [bool](Get-Module $foreign.Name | Where-Object {
                $_.ModuleBase -and [System.IO.Path]::GetFullPath($_.ModuleBase).TrimEnd('\', '/') -ieq $rootInternal
            })
        if (-not $hasLocal -and $foreign.Name -in 'Catzc.Internal.Importer', 'Catzc.Internal.Bootstrap') {
            continue
        }
        Write-Verbose "Evicting $($foreign.Name) loaded from another root: $($foreign.ModuleBase)"
        Remove-Module -ModuleInfo $foreign -Force -ErrorAction SilentlyContinue
        $evicted.Add($foreign.Name)
        $internalPath = [System.IO.Path]::Combine($rootInternal, "$($foreign.Name).psm1")
        if ($isInternal -and -not $hasLocal -and [System.IO.File]::Exists($internalPath)) {
            Write-Verbose "Reloading $($foreign.Name) from $rootInternal"
            Import-Module $internalPath -Scope Global -Force
        }
    }
    if ($DiagnoseLoadTime) {
        Write-ImporterMessage ('    {0,6}ms  (remove stale modules)' -f [int]$sw.Elapsed.TotalMilliseconds) -ForegroundColor DarkGray
    }

    Import-CSharpTypes -ModulesRoot $ModulesRoot -DiagnoseLoadTime:$DiagnoseLoadTime -PrebuiltOnly:$Bundle -HostKind $HostKind

    $imported = [System.Collections.Generic.List[string]]::new()
    $commandNames = [System.Collections.Generic.List[string]]::new()
    foreach ($dir in $moduleDirs) {
        if ($DiagnoseLoadTime) {
            $sw.Restart()
        }
        $manifestPath = New-DynamicManifest -ModulePath $dir.FullName -ExportPrivates:$ExportPrivates -ReadOnly:$Bundle
        $manifestMs = if ($DiagnoseLoadTime) {
            [int]$sw.Elapsed.TotalMilliseconds
        }
        else {
            0
        }

        if ($manifestPath) {
            Write-Verbose "Importing module: $($dir.Name)"

            $readMs = 0
            $fileCount = 0
            if ($DiagnoseLoadTime) {
                $sw.Restart()
                foreach ($pf in [System.IO.Directory]::EnumerateFiles($dir.FullName, '*.ps1')) {
                    if (-not $pf.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
                        [void][System.IO.File]::ReadAllText($pf)
                        $fileCount++
                    }
                }
                $privateDir = [System.IO.Path]::Combine($dir.FullName, 'private')
                if ([System.IO.Directory]::Exists($privateDir)) {
                    foreach ($pf in [System.IO.Directory]::GetFiles($privateDir, '*.ps1')) {
                        [void][System.IO.File]::ReadAllText($pf)
                        $fileCount++
                    }
                }
                $readMs = [int]$sw.Elapsed.TotalMilliseconds
            }

            if ($DiagnoseLoadTime) {
                $sw.Restart()
            }
            $importedModule = Import-Module $manifestPath -Scope Global -Force -PassThru | Select-Object -First 1
            . $importedModule { Set-StrictMode -Version Latest }
            $imported.Add($dir.Name)
            $commandNames.AddRange([string[]]@($importedModule.ExportedCommands.Keys))
            if ($DiagnoseLoadTime) {
                $importMs = [int]$sw.Elapsed.TotalMilliseconds
                $total = $manifestMs + $readMs + $importMs
                Write-ImporterMessage ('    {0,6}ms  {1} (manifest {2}ms + raw-read {3}ms + import {4}ms)' -f $total, $dir.Name, $manifestMs, $readMs, $importMs) -ForegroundColor DarkGray
                if ($null -ne (Get-Variable -Name '__CatzcLoadTimings' -Scope Global -ValueOnly -ErrorAction Ignore)) {
                    $global:__CatzcLoadTimings.Add([pscustomobject]@{ Stage = $dir.Name; Ms = $total; ReadMs = $readMs; ImportMs = $importMs; FileCount = $fileCount })
                }
            }
        }
        else {
            # Clean up stale .psd1 if module dir became empty
            $stalePsd1 = Join-Path $dir.FullName "$($dir.Name).psd1"
            if ([System.IO.File]::Exists($stalePsd1)) {
                [System.IO.File]::Delete($stalePsd1)
            }
        }
    }

    # Installed last, once every command name is known: the first lookup of one of them loads the types still pending.
    Enable-DeferredTypesLoad -CommandName $commandNames

    $summary = "Loaded $($imported.Count) modules from '$ModulesRoot'"
    if ($evicted.Count) {
        $summary += "; evicted from another root: $($evicted -join ', ')"
    }
    $gone = @(foreach ($module in $stale) {
            if ($module.Name -notin $imported) {
                $module.Name
            }
        })
    if ($gone.Count) {
        $summary += "; removed, no longer in the tree: $($gone -join ', ')"
    }
    Write-ImporterMessage $summary -StateChange
}

Export-ModuleMember -Function 'Import-AllModules', 'Clear-CompiledType', 'Get-ForeignCatzcModule'
