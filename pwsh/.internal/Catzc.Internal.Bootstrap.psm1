Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

# Wipes every compiled build before import in any context, skipping only a locked DLL; the next import rebuilds from source.
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

function Get-PrivateFunctionFolder {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    # The pre-types reader of the private-function folder row; once types load, LanguagesConfig.FolderOf reads the same row.
    if ($script:privateFunctionFolder -and $script:privateFunctionFolder.Root -ceq $ModulesRoot) {
        return $script:privateFunctionFolder.Folder
    }
    $languagesFolder = Resolve-ModuleName -FullName 'Catzc.Base.Languages' -Namespace (Get-ModuleNamespace -ModulesRoot $ModulesRoot)
    $configPath = [System.IO.Path]::Combine($ModulesRoot, $languagesFolder, 'configs', 'languages.yml')
    if (-not [System.IO.File]::Exists($configPath)) {
        throw "The languages config '$configPath' does not exist; the bootstrap reads the private-function folder from it."
    }
    $config = ConvertFrom-Yaml ([System.IO.File]::ReadAllText($configPath))
    $folder = $null
    if ($config -is [System.Collections.IDictionary] -and $config['languages'] -is [System.Collections.IDictionary] -and
        $config['languages']['powershell'] -is [System.Collections.IDictionary]) {
        foreach ($row in @($config['languages']['powershell']['layout'])) {
            if ($row -is [System.Collections.IDictionary] -and $row['role'] -ceq 'private-function') {
                $folder = [string] $row['folder']
                break
            }
        }
    }
    if ([string]::IsNullOrEmpty($folder)) {
        throw "The languages config '$configPath' has no powershell layout row with role 'private-function'."
    }
    $script:privateFunctionFolder = @{ Root = $ModulesRoot; Folder = $folder }
    $folder
}

# Writes a module's generated .psd1; a module that is not one function per file passes both lists instead of being enumerated.
function New-DynamicManifest {
    [CmdletBinding(DefaultParameterSetName = 'Derived')]
    param(
        [Parameter(Mandatory)]
        [string]$ModulePath,

        [switch]$ExportPrivates,

        # A bundle load: the manifest must already exist, so a read-only install is never written to.
        [switch]$ReadOnly,

        [Parameter(Mandatory, ParameterSetName = 'Explicit')]
        [string[]]$NestedModule,

        [Parameter(Mandatory, ParameterSetName = 'Explicit')]
        [AllowEmptyCollection()]
        [string[]]$FunctionToExport
    )

    # The module's full name, from its folder name under the namespace its track declares ([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
    $moduleName = Resolve-ModuleName -Folder (Split-Path $ModulePath -Leaf) -Namespace (Get-ModuleNamespace -ModulesRoot (Split-Path $ModulePath -Parent))
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
            if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1',
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                $f
            }
        })

    # Collect private .ps1 files (private subfolder)
    $privatePath = Join-Path $ModulePath (Get-PrivateFunctionFolder -ModulesRoot ([System.IO.Path]::GetDirectoryName($ModulePath)))
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

    # Private files first, then public, each ordinal-sorted with forward slashes, so the manifest is the same on every system.
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

# Every derived manifest's one NestedModule, relative to a module folder beside .internal.
$script:moduleFilesLoader = '../.internal/assets/Import-ModuleFiles.ps1'
$script:privateFunctionFolder = $null

# The functions that outgrew this file live one per file beside it; they share its scope.
. (Join-Path $PSScriptRoot 'assets/bootstrap/Resolve-ModuleName.ps1')
. (Join-Path $PSScriptRoot 'assets/bootstrap/Get-ModuleNamespace.ps1')
. (Join-Path $PSScriptRoot 'assets/bootstrap/Import-CSharpTypes.ps1')
. (Join-Path $PSScriptRoot 'assets/bootstrap/Import-AllModules.ps1')

# Writes only when the text differs, so parallel workers never race on an unchanged manifest.
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

# Canonical .psd1 text by construction: formatter-stable, with nothing aligned by hand.
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

    # The '=' column follows the longest key, so a new field re-aligns the block by itself.
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

# PowerShell lets the last import shadow a command silently, so a name collision fails the import instead.
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
            if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1',
                    [System.StringComparison]::OrdinalIgnoreCase)) {
                $files.Add($f)
            }
        }
        if ($ExportPrivates) {
            $privatePath = [System.IO.Path]::Combine($dir.FullName,
                (Get-PrivateFunctionFolder -ModulesRoot $dir.Parent.FullName))
            if ([System.IO.Directory]::Exists($privatePath)) {
                foreach ($f in [System.IO.Directory]::EnumerateFiles($privatePath, '*.ps1')) {
                    if (-not [System.IO.Path]::GetFileName($f).EndsWith('.Tests.ps1',
                            [System.StringComparison]::OrdinalIgnoreCase)) {
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

    # A catzc function may not shadow a shipped command already imported: a vendored one or a built-in.
    $shipped = @{}
    foreach ($m in Get-Module) {
        $base = $m.ModuleBase
        # Shipped means loaded before the catzc modules: built-ins under $PSHOME and vendored modules under .vendor.
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

# The package module belongs to a root whose parent is its ModuleBase, since its code root is pwsh/.
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

Export-ModuleMember -Function 'Import-AllModules', 'Clear-CompiledType', 'Get-ForeignCatzcModule'
