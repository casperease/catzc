<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Bootstrap.psm1
    kind: internal-module
---
#>

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

<#
.SYNOPSIS
    Writes a bootstrap/importer console message, prefixed to match Write-Message's [Caller] style.
.DESCRIPTION
    Runs before Write-Message exists, so this is the bootstrap's one writer chokepoint, silent during a Pester run.
    [comment:1](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment1)
.PARAMETER Message
    The message text.
.PARAMETER ForegroundColor
    Optional text color (e.g. DarkGray for diagnostics, Yellow for warnings). Not applied to a -StateChange line.
.PARAMETER StateChange
    The line announces a state change of the importer's own load sequence: write it on the verbose stream.
#>
function Write-ImporterMessage {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__PesterRunning (set by Test-Automation) silences the chokepoint during a test run, as in Write-InformationColored; global is required to cross module session-state boundaries')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Message,

        [System.ConsoleColor] $ForegroundColor,

        [switch] $StateChange
    )

    # Read through Get-Variable: the flag is unset outside a test run, and strict mode rejects an unset variable.
    if (Get-Variable -Name '__PesterRunning' -Scope Global -ValueOnly -ErrorAction Ignore) {
        return
    }
    $line = if ($Message) {
        "[Importer.ps1] $Message"
    }
    else {
        ''
    }
    if ($StateChange) {
        Write-Verbose $line -Verbose:$script:importerVerbose
        return
    }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
        # $PSStyle, not the Writers' Ansi type: this runs before the combined types assembly is loaded.
        $line = "$($PSStyle.Foreground.FromConsoleColor($ForegroundColor))$line$($PSStyle.Reset)"
    }
    Write-Information $line -InformationAction Continue
}

# Module state, so a fresh import starts it false and the importer's teardown removes it with the module.
# [comment:2](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment2)
$script:importerVerbose = $false

<#
.SYNOPSIS
    Sets whether the importer's state-change lines (Write-ImporterMessage -StateChange) are shown.
.DESCRIPTION
    The bootstrap and vendor functions do not inherit -Verbose, so Invoke-Importer hands the setting over here once.
    [comment:3](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment3)
.PARAMETER Enabled
    Show the state-change lines on the verbose stream.
#>
function Set-ImporterVerbosity {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Sets a bootstrap-private output flag for the duration of one import; nothing to confirm')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [bool] $Enabled
    )

    $script:importerVerbose = $Enabled
}

<#
.SYNOPSIS
    Deletes the compiled C# type assembly so the next import rebuilds it from source.
.DESCRIPTION
    Unlike Clear-ModuleTypeCache it wipes every build before import in any context, skipping only locked DLLs.
    [comment:4](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment4)
.PARAMETER ModulesRoot
    Path to the automation directory (the parent of .compiled/).
#>
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
            }
        }
    }

    Write-ImporterMessage "Cleared compiled type cache — building from source (removed $removed, skipped $skipped)"
}

<#
.SYNOPSIS
    Writes a module's generated <Module>.psd1 and returns its path.
.DESCRIPTION
    A caller whose module is not one function per file passes both lists explicitly, and the folder is not enumerated.
    [comment:5](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment5)
.PARAMETER ModulePath
    The module folder; the manifest is <ModulePath>/<leaf>.psd1.
.PARAMETER ExportPrivates
    Export every function ('*'), so tests can reach privates.
.PARAMETER ReadOnly
    Never write: assert the manifest is already present and return its path.
.PARAMETER NestedModule
    Explicit NestedModules, relative to ModulePath with forward slashes, in load order. Requires -FunctionToExport.
.PARAMETER FunctionToExport
    Explicit FunctionsToExport names. Requires -NestedModule.
#>
function New-DynamicManifest {
    [CmdletBinding(DefaultParameterSetName = 'Derived')]
    param(
        [Parameter(Mandatory)]
        [string]$ModulePath,

        [switch]$ExportPrivates,

        # A read-only install store is never written to, so the build must pre-generate every manifest.
        # [comment:6](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment6)
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

    # Ordinal order and forward slashes make the emitted manifest byte-identical on every platform and build.
    # [comment:7](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment7)
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

    # Formatter-stable text with no hand-padded alignment; the L2 tests guard that invariant.
    # [comment:8](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment8)
    $content = Get-DynamicManifestContent -NestedModule $script:moduleFilesLoader -ModuleFile $moduleFiles -FunctionToExport $exportNames -ExportAll:$ExportPrivates
    Write-DynamicManifest -Path $manifestPath -Content $content
}

# The module folder sits directly under the modules root beside .internal, hence this relative path.
# [comment:9](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment9)
$script:moduleFilesLoader = '../.internal/assets/Import-ModuleFiles.ps1'

function Write-DynamicManifest {
    <#
    .SYNOPSIS
        Writes rendered manifest text to its .psd1 only when it differs, and returns the path.
    .DESCRIPTION
        An unchanged module yields identical bytes and no write, so parallel workers never race on the manifest files.
        [comment:10](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment10)
    #>
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
    <#
    .SYNOPSIS
        Renders a module manifest hashtable as canonical .psd1 text.
    .DESCRIPTION
        Canonical by construction: the alignment column derives from the longest key and the text is formatter-stable.
        [comment:11](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment11)
    #>
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

    # A new field re-aligns the equals column automatically, so no alignment is kept by hand.
    # [comment:12](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment12)
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

<#
.SYNOPSIS
    Compiles and loads EVERY module's native C# types (types/*.cs) into ONE hash-keyed assembly.
.DESCRIPTION
    One assembly lets a type in one module reference a type in another; the module graph is policed by tests.
    [comment:13](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment13)
.PARAMETER ModulesRoot
    The automation directory. Its non-dot subfolders are the modules; the assembly is written to its .compiled/.
.PARAMETER DiagnoseLoadTime
    Emit a single combined compile/cache-load timing line (surfaced by importer.ps1 -DiagnoseLoadTime).
#>
function Import-CSharpTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Session-global by design: $global:__CatzcTypes (per-ModulesRoot hash+snapshot) must survive module reimport to detect C# source changes across the session, and $global:__CatzcLoadTimings collects import diagnostics')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$DiagnoseLoadTime,

        # A bundle ships the DLL, so a read-only install never invokes Roslyn and never writes.
        # [comment:14](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment14)
        [switch]$PrebuiltOnly
    )

    # One shared implementation for loader and janitor, so the committed DLL key can never drift between them.
    # [comment:15](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment15)
    Import-InternalModule Types
    $hashResult = Get-CombinedTypeHash $ModulesRoot
    if ($hashResult.Files.Count -eq 0) {
        return
    }

    # Validation lives in the loader, not the shared enumerator, because the janitor must never throw on a bad source.
    # [comment:16](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment16)
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

    # The session record is keyed by ModulesRoot, so a fixture root never poisons the real tree's drift guard.
    # [comment:17](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment17)
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
        # A changed or removed type only warns and skips recording the hash, so the warning repeats until restart.
        # [comment:18](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment18)
        if ((Test-IsRunningInPipeline) -or $typeState.MissingTypes.Count) {
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

    # Output-only compile writes without loading, so a re-import restores a deleted DLL even when the types are loaded.
    # [comment:19](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment19)
    $didCompile = $false
    if (-not [System.IO.File]::Exists($dll)) {
        if ($PrebuiltOnly) {
            throw "Bundle is missing its prebuilt combined-types assembly ($dll). The bundle is incomplete or corrupt — rebuild it (Build-Modules ships the DLL); a bundle never compiles types."
        }
        # It re-derives the hash from disk, so a source edited mid-import throws instead of mis-keying the DLL.
        # [comment:20](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment20)
        $built = Build-CombinedTypeAssembly -AutomationRoot $ModulesRoot -OutputDirectory $compiledDir
        if ($built.Hash -ne $combinedHash) {
            throw "C# type sources changed during the import ($combinedHash -> $($built.Hash)). Re-run the importer."
        }
        $didCompile = $true

        # A locked DLL (the live build, a concurrent process) is skipped and never fails the import.
        # [comment:21](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment21)
        foreach ($old in [System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll')) {
            if ($old -eq $dll) {
                continue
            }
            try {
                [System.IO.File]::Delete($old)
            }
            catch {
                Write-Verbose "Skipped locked stale type DLL: $old"
            }
        }

        # Bootstrap code runs only from the importer, where Write-Message may not be loaded yet.
        # [comment:22](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment22)
        $relativeDll = ([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll)) -replace '\\', '/'
        Write-ImporterMessage "Built $relativeDll"
    }

    # Loads go through a per-user shadow copy, so no session ever locks a build inside the repository.
    # [comment:23](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment23)
    if (-not $loaded) {
        Test-TypesAssemblyContent -Path $dll -Expected $arr
        Import-TypesAssembly -Path $dll | Out-Null
        Write-ImporterMessage "Loaded types $(([System.IO.Path]::GetRelativePath($env:RepositoryRoot, $dll)) -replace '\\', '/')" -StateChange

        # Registration only, idempotent by remove then add, so a re-import never throws on a duplicate key.
        # [comment:24](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment24)
        $aliasAttrType = ([System.Management.Automation.PSTypeName]'Catzc.Base.Objects.PSTypeAliasAttribute').Type
        if ($aliasAttrType) {
            $accelerators = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
            foreach ($tf in $arr) {
                $type = ([System.Management.Automation.PSTypeName]$tf.Type).Type
                foreach ($alias in $type.GetCustomAttributes($aliasAttrType, $false)) {
                    [void] $accelerators::Remove($alias.Name)
                    $accelerators::Add($alias.Name, $type)
                }
            }
        }

        # Formatting honours type data where interpolation does not, so this half is registered here, not in C#.
        # [comment:25](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment25)
        $displayAttrType = ([System.Management.Automation.PSTypeName]'Catzc.Base.Objects.ConsoleDisplayAttribute').Type
        if ($displayAttrType) {
            $displayed = 0
            foreach ($tf in $arr) {
                $type = ([System.Management.Automation.PSTypeName]$tf.Type).Type
                $display = [System.Attribute]::GetCustomAttribute($type, $displayAttrType, $true)
                if ($display) {
                    Update-TypeData -TypeName $type.FullName -DefaultDisplayPropertySet $display.Properties -Force
                    $displayed++
                }
            }
            if ($displayed -gt 0) {
                Write-ImporterMessage "Registered default display properties for $displayed type(s)" -StateChange
            }
        }
    }

    $global:__CatzcTypes[$rootKey] = [pscustomobject]@{ Hash = $combinedHash; Snapshot = $snapshot }

    if ($DiagnoseLoadTime) {
        $ms = [int]$sw.Elapsed.TotalMilliseconds
        $label = if ($didCompile -and $loaded) {
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

<#
.SYNOPSIS
    Fails the import when an exported function name collides — across automation modules, or with a shipped
    (vendored/built-in) command that is already imported.
.DESCRIPTION
    PowerShell silently lets the last imported command shadow the rest, so this turns a clash into a loud failure.
    [comment:26](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment26)
.PARAMETER ModuleDirs
    The discovered module directories (dot-prefixed infrastructure already excluded).
.PARAMETER ExportPrivates
    When set, private/ functions are exported too, so they join the uniqueness check.
#>
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

    # 1) Two automation modules exporting the same name — the module imported last silently shadows the others.
    foreach ($entry in $sources.GetEnumerator()) {
        if ($entry.Value.Count -gt 1) {
            $violations.Add("  $($entry.Key): defined by $($entry.Value -join ', ')")
        }
    }

    # Vendor modules and built-ins import first, so a clash would be silently shadowed by our global import.
    # [comment:27](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment27)
    $shipped = @{}
    foreach ($m in Get-Module) {
        $base = $m.ModuleBase
        # The .internal modules sit directly in the folder, so their ModuleBase ends at .internal with no separator.
        # [comment:28](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment28)
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
            'Function name collision(s) detected before import. Each automation function name must be unique'
            'across modules AND must not shadow an already-imported (vendored/built-in) command:'
        ) + $sorted
        throw ($lines -join "`n")
    }
}

<#
.SYNOPSIS
    Returns every loaded catzc module that does not come from the given code root.
.DESCRIPTION
    The package module also belongs when its ModuleBase is the root's parent, since its code root is automation/.
    [comment:29](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment29)
.PARAMETER ModulesRoot
    The active code root (CatzcModulesRoot).
.PARAMETER IncludeInternal
    Include the Catzc.Internal.* loader modules (they belong to a root through its .internal folder).
#>
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

<#
.SYNOPSIS
    Imports all module directories under a given root path.
.DESCRIPTION
    Running importer modules are never touched mid-load; the exclusivity assert reports any that are foreign.
    [comment:30](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment30)
.PARAMETER ModulesRoot
    Path to the directory containing module folders.
#>
function Import-AllModules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = '$global:__CatzcLoadTimings is session-global import diagnostics collected across all modules, surfaced by importer.ps1 -DiagnoseLoadTime')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ModulesRoot,

        [switch]$ExportPrivates,

        # Shows whether a slow module costs file I/O (raw-read) or parse (import); off means no overhead.
        # [comment:31](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment31)
        [switch]$DiagnoseLoadTime,

        # A bundle must ship its manifests and DLL, because a read-only load never generates or compiles them.
        # [comment:32](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment32)
        [switch]$Bundle
    )

    $moduleDirs = Get-ChildItem -Path $ModulesRoot -Directory |
        Where-Object { $_.Name -notmatch '^\.' }

    # A collision would otherwise be silent, since the module imported last shadows the others.
    # [comment:33](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment33)
    Assert-UniqueModuleFunctionName -ModuleDirs $moduleDirs -ExportPrivates:$ExportPrivates

    $sw = if ($DiagnoseLoadTime) {
        [Diagnostics.Stopwatch]::StartNew()
    }
    else {
        $null
    }

    # The .internal modules must survive into the session, yet they match this sweep because they sit under the root.
    # [comment:34](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment34)
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

    # Remove by module instance, never by name, because a forced same-named import leaves a second instance.
    # [comment:35](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment35)
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

    # Types load once before any module function, so the import order below is irrelevant and types may cross-reference.
    # [comment:36](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment36)
    Import-CSharpTypes -ModulesRoot $ModulesRoot -DiagnoseLoadTime:$DiagnoseLoadTime -PrebuiltOnly:$Bundle

    $imported = [System.Collections.Generic.List[string]]::new()
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

            # Pays the cold file-open cost first, so Import-Module reads a warm cache and its time is mostly parse.
            # [comment:37](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment37)
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
            # A session-level strict mode does not reach module code, so each module sets its own script scope.
            # [comment:38](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment38)
            . $importedModule { Set-StrictMode -Version Latest }
            $imported.Add($dir.Name)
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

    # A re-import's remove then reload of the same modules is not a departure and is not listed.
    # [comment:39](/docs/references/automation/internal/Catzc.Internal.Bootstrap.psm1.md#comment39)
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

Export-ModuleMember -Function 'Import-AllModules', 'Write-ImporterMessage', 'Set-ImporterVerbosity', 'Clear-CompiledType', 'Get-ForeignCatzcModule'
