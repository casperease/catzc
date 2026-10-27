Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

. (Join-Path $PSScriptRoot 'assets/bootstrap/Resolve-ModuleName.ps1')
. (Join-Path $PSScriptRoot 'assets/bootstrap/Get-ModuleNamespace.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-TypeSourceBody.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-CombinedTypeHash.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-LoadedTypeDrift.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Build-CombinedTypeAssembly.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-TypesAssemblyManifest.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Write-TypesAssemblyManifest.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-TypesContractPath.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Save-BurstJournalWrite.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Write-TypesContract.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-TypesContractDrift.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-TypesShadowRoot.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Get-TypesPruneAfter.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Register-TypesHold.ps1')
. (Join-Path $PSScriptRoot 'assets/types/Test-TypesHeld.ps1')

function Get-TypesStampPath {
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot
    )

    # One memo per modules root, named by a digest of its full path, beside the shadow copies (machine-local like them).
    $normalized = [System.IO.Path]::GetFullPath($ModulesRoot).TrimEnd('\', '/')
    $digest = [System.Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($normalized))).Substring(0, 12).ToLowerInvariant()
    [System.IO.Path]::Combine((Get-TypesShadowRoot), "stamp-$digest.json")
}

function Import-TypesAssembly {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Writes only the per-user shadow cache, an internal load-time detail of the importer; the load itself is announced by the caller (Import-CSharpTypes).')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The binary load is announced by the caller: Import-CSharpTypes writes "Loaded types <dll>" through Write-ImporterMessage -StateChange; the analyzer rule SpellOutIdentifiers runs inside the analyzer engine, where only diagnostic records may be emitted.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [string] $ShadowRoot = (Get-TypesShadowRoot),

        [TimeSpan] $PruneAfter = (Get-TypesPruneAfter),

        # False loads the file in place: a system that does not lock a loaded file needs no copy.
        [bool] $ShadowCopy = $true
    )

    if (-not [System.IO.File]::Exists($Path)) {
        throw "Cannot load the types assembly: '$Path' does not exist."
    }

    if (-not $ShadowCopy) {
        Add-Type -Path $Path
        return $Path
    }

    [System.IO.Directory]::CreateDirectory($ShadowRoot) | Out-Null
    # A build made in the shadow root is its own shadow copy.
    $shadow = [System.IO.Path]::Combine($ShadowRoot, [System.IO.Path]::GetFileName($Path))
    $name = [System.IO.Path]::GetFileNameWithoutExtension($shadow)
    if ($name.StartsWith('Catzc.Types.')) {
        Register-TypesHold -Hash $name.Substring('Catzc.Types.'.Length) -ShadowRoot $ShadowRoot | Out-Null
    }
    if (-not [System.IO.File]::Exists($shadow)) {
        $tmp = "$shadow.$PID.tmp"
        try {
            [System.IO.File]::Copy($Path, $tmp, $true)
            [System.IO.File]::Move($tmp, $shadow)
        }
        catch {
            # A concurrent load that won the race left an equivalent copy; anything else is a real failure.
            if (-not [System.IO.File]::Exists($shadow)) {
                throw
            }
        }
        finally {
            if ([System.IO.File]::Exists($tmp)) {
                [System.IO.File]::Delete($tmp)
            }
        }
    }

    # Mark this copy as in use (best-effort: a copy another process has loaded may refuse the attribute write).
    try {
        [System.IO.File]::SetLastWriteTimeUtc($shadow, [DateTime]::UtcNow)
    }
    catch {
        Write-Verbose "Could not refresh the shadow copy's write time: $shadow"
    }

    # The prune leaves a build that a live process holds: one it loaded, or one it found on disk and is about to load (Register-TypesHold).
    $staleBefore = [DateTime]::UtcNow - $PruneAfter
    foreach ($other in [System.IO.Directory]::EnumerateFiles($ShadowRoot, 'Catzc.Types.*.dll')) {
        if ($other -eq $shadow -or [System.IO.File]::GetLastWriteTimeUtc($other) -ge $staleBefore) {
            continue
        }
        if (Test-TypesHeld -Hash ([System.IO.Path]::GetFileNameWithoutExtension($other).Substring('Catzc.Types.'.Length)) -ShadowRoot $ShadowRoot) {
            Write-Verbose "Skipped a shadow copy a live process holds: $other"
            continue
        }
        try {
            [System.IO.File]::Delete($other)
        }
        catch {
            Write-Verbose "Skipped a shadow copy still in use: $other"
        }
    }

    Add-Type -Path $shadow
    $shadow
}

function Test-TypesAssemblyContent {
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [object[]] $Expected
    )

    if (-not [System.IO.File]::Exists($Path)) {
        throw "Cannot verify the types assembly: '$Path' does not exist."
    }

    $declared = [System.Collections.Generic.HashSet[string]]::new([string[]] @((Get-TypesAssemblyManifest -Path $Path).Types.Name), [System.StringComparer]::Ordinal)
    foreach ($source in $Expected) {
        if (-not $declared.Contains("$($source.Module).$($source.Base)")) {
            throw "Compiled C# types but '$($source.Module).$($source.Base)' was not produced. $($source.Module)/types/$($source.Base).cs must declare a public class named '$($source.Base)' (the module namespace '$($source.Module)' is added automatically)."
        }
    }
}


$script:typesLoadDefault = [ordered]@{ Load = 'lazy'; Trigger = 'lookup-hook'; EagerTypes = @(); ShadowCopy = $true; Generations = 1 }
$script:typesLoadHosts = 'console', 'headless'
$script:typesLoadSystems = 'windows', 'unix'
$script:typesLoadRunModes = 'source', 'build'
$script:typesLoadLoads = 'lazy', 'eager'
$script:typesLoadTriggers = 'lookup-hook', 'none'
$script:typesLoadKeys = 'load', 'trigger', 'shadowCopy', 'eagerTypes', 'generations'

function Get-TypesLoadPolicy {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Engine = 'pwsh',

        [ValidateSet('console', 'headless')]
        [string] $HostKind = $(if (Test-IsRunningInPipeline) {
                'headless'
            }
            else {
                'console'
            }),

        [ValidateSet('windows', 'unix')]
        [string] $Os = $(if ($IsWindows) {
                'windows'
            }
            else {
                'unix'
            }),

        [ValidateSet('source', 'build')]
        [string] $RunMode = 'source',

        [ValidateSet('lazy', 'eager')]
        [string] $Load,

        [ValidateSet('lookup-hook', 'none')]
        [string] $Trigger,

        [bool] $ShadowCopy,

        [string[]] $EagerType,

        [string] $ConfigPath = [System.IO.Path]::Combine($PSScriptRoot, 'assets', 'types-load.yml')
    )

    if ($Engine -ne 'pwsh') {
        return [pscustomobject]@{ Cell = $null; Engine = $Engine; Load = 'never'; Trigger = 'none'; EagerTypes = @(); ShadowCopy = $false }
    }

    if (-not [System.IO.File]::Exists($ConfigPath)) {
        throw "The types-load config '$ConfigPath' does not exist."
    }
    $config = ConvertFrom-Yaml ([System.IO.File]::ReadAllText($ConfigPath))
    if ($null -eq $config -or -not $config.ContainsKey('cells')) {
        throw "The types-load config '$ConfigPath' has no 'cells' map."
    }

    $valid = foreach ($h in $script:typesLoadHosts) {
        foreach ($o in $script:typesLoadSystems) {
            foreach ($r in $script:typesLoadRunModes) {
                "$h.$o.$r"
            }
        }
    }
    foreach ($key in $config['cells'].Keys) {
        if ($key -cnotin $valid) {
            throw "The types-load config has a row '$key' that is no mode. The modes are: $($valid -join ', ')."
        }
        foreach ($setting in $config['cells'][$key].Keys) {
            if ($setting -cnotin $script:typesLoadKeys) {
                throw "The types-load row '$key' has an unknown setting '$setting'. The settings are: $($script:typesLoadKeys -join ', ')."
            }
        }
    }

    $cell = "$HostKind.$Os.$RunMode"
    $row = if ($config['cells'].ContainsKey($cell)) {
        $config['cells'][$cell]
    }
    else {
        @{}
    }
    # Filled in here, not as defaults: each is relative to the -ConfigPath row, and -ConfigPath is declared after them.
    $policy = [ordered]@{ Cell = $cell; Engine = $Engine }
    foreach ($name in 'Load', 'Trigger', 'ShadowCopy', 'Generations') {
        $fromConfig = $name.Substring(0, 1).ToLowerInvariant() + $name.Substring(1)
        $policy[$name] = if ($PSBoundParameters.ContainsKey($name)) {
            $PSBoundParameters[$name]
        }
        elseif ($row.ContainsKey($fromConfig)) {
            $row[$fromConfig]
        }
        else {
            $script:typesLoadDefault[$name]
        }
    }
    $policy['EagerTypes'] = @(
        if ($PSBoundParameters.ContainsKey('EagerType')) {
            $EagerType
        }
        elseif ($row.ContainsKey('eagerTypes')) {
            $row['eagerTypes']
        }
        else {
            $script:typesLoadDefault['EagerTypes']
        }
    )

    if ($policy.Load -cnotin $script:typesLoadLoads) {
        throw "Row '$cell' has load '$($policy.Load)'; the values are: $($script:typesLoadLoads -join ', ')."
    }
    if ($policy.Trigger -cnotin $script:typesLoadTriggers) {
        throw "Row '$cell' has trigger '$($policy.Trigger)'; the values are: $($script:typesLoadTriggers -join ', ')."
    }
    if ($policy.ShadowCopy -isnot [bool]) {
        throw "Row '$cell' has shadowCopy '$($policy.ShadowCopy)'; it is true or false."
    }
    if ($policy.Generations -isnot [int] -or $policy.Generations -lt 1) {
        throw "Row '$cell' has generations '$($policy.Generations)'; it is a whole number of at least 1."
    }
    # Builds stack only in a developer's interactive session in the source tree; every other cell keeps one.
    if ($policy.Generations -gt 1 -and $cell -notlike 'console.*.source') {
        throw "Row '$cell' has generations $($policy.Generations); only a console.*.source row may stack more than 1 build."
    }
    if ($policy.Trigger -eq 'none' -and $policy.Load -ne 'eager') {
        throw "Row '$cell' has trigger 'none' with load '$($policy.Load)'; nothing would ever load the types. 'none' needs load eager."
    }
    [pscustomobject]$policy
}

# The pending record is session-global, so it survives a re-import of this module; it is keyed by code root.
function Register-DeferredTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = 'Session-global by design: the pending record must survive a re-import of this module, like $global:__CatzcTypes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Records in-memory session state only; the importer announces the deferral')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $RootKey,

        [Parameter(Mandatory)]
        [string] $Path,

        [bool] $ShadowCopy = $true,

        # 1 for the first build of this root, more when changed builds stack.
        [int] $Generation = 1
    )

    if (-not (Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore)) {
        $global:__CatzcDeferredTypes = @{}
    }
    $global:__CatzcDeferredTypes[$RootKey] = @{ Path = $Path; ShadowCopy = $ShadowCopy; Loaded = $false; Generation = $Generation }
}

# The first use of a catzc command calls it through the lookup hook, so a session that never uses a type never loads one.
function Initialize-Types {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = 'Reads and marks $global:__CatzcDeferredTypes, the session-global pending record')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Loads the assembly the importer already verified and announced; there is nothing to confirm')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '',
        Justification = 'The importer announces the change: an eager load writes "Registered default display properties" through Write-ImporterMessage -StateChange, and a deferred load was announced as "Deferred types" when the importer registered it; Write-ImporterMessage is gone once the lazy load runs')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
    $records = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
    if (-not $records) {
        return
    }

    foreach ($key in @($records.Keys)) {
        $entry = $records[$key]
        if ($entry.Loaded) {
            continue
        }
        $manifestPath = [System.IO.Path]::ChangeExtension($entry.Path, 'json')
        if (-not [System.IO.File]::Exists($manifestPath)) {
            throw "Cannot load the types assembly: its manifest '$manifestPath' does not exist. Restart PowerShell to rebuild it."
        }
        $manifest = [System.IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json

        $loadedFrom = Import-TypesAssembly -Path $entry.Path -ShadowCopy $entry.ShadowCopy
        $entry.Loaded = $true

        $aliases = 0
        $displayed = 0
        $accelerators = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
        # A full type name keeps resolving to the first-loaded build, so each accelerator takes this build's type.
        $assembly = @([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { -not $_.IsDynamic -and $_.Location -eq $loadedFrom }) | Select-Object -Last 1
        foreach ($type in $manifest.types) {
            $resolved = if ($assembly) {
                $assembly.GetType($type.name)
            }
            else {
                ([System.Management.Automation.PSTypeName]$type.name).Type
            }
            foreach ($alias in @($type.aliases)) {
                [void] $accelerators::Remove($alias)
                $accelerators::Add($alias, $resolved)
                $aliases++
            }
            if (@($type.display).Count -gt 0) {
                Update-TypeData -TypeName $type.name -DefaultDisplayPropertySet @($type.display) -Force
                $displayed++
            }
        }
        Write-Verbose "Loaded types $loadedFrom ($aliases alias(es), default display for $displayed type(s))"
        [pscustomobject]@{ Path = $entry.Path; Loaded = $loadedFrom; Aliases = $aliases; Displayed = $displayed }
    }
}

$script:deferredTypesCommands = [System.Collections.Generic.HashSet[string]]::new()

# A guard in the body is too late: a typed parameter resolves before it runs, so the hook fires before binding.
function Enable-DeferredTypesLoad {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = 'Reads $global:__CatzcDeferredTypes, the session-global pending record')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Installs an in-memory lookup hook for this session only; the importer announces the deferral')]
    [CmdletBinding()]
    param(
        [AllowEmptyCollection()]
        [string[]] $CommandName = @()
    )

    $records = Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore
    $pending = $false
    if ($records) {
        foreach ($entry in $records.Values) {
            if (-not $entry.Loaded) {
                $pending = $true
            }
        }
    }
    if (-not $pending) {
        $ExecutionContext.InvokeCommand.PreCommandLookupAction = $null
        return
    }

    $script:deferredTypesCommands = [System.Collections.Generic.HashSet[string]]::new([string[]]$CommandName,
        [System.StringComparer]::OrdinalIgnoreCase)
    $ExecutionContext.InvokeCommand.PreCommandLookupAction = {
        param($commandName)
        if ($script:deferredTypesCommands.Contains($commandName)) {
            Initialize-Types | Out-Null
        }
    }
}

Export-ModuleMember -Function Get-TypeSourceBody, Get-CombinedTypeHash, Get-LoadedTypeDrift, Build-CombinedTypeAssembly, Get-TypesShadowRoot, Get-TypesPruneAfter, Register-TypesHold, Test-TypesHeld, Get-TypesStampPath, Import-TypesAssembly, Test-TypesAssemblyContent, Get-TypesAssemblyManifest, Write-TypesAssemblyManifest, Get-TypesContractPath, Write-TypesContract, Save-BurstJournalWrite, Get-TypesContractDrift, Get-TypesLoadPolicy, Register-DeferredTypes, Initialize-Types, Enable-DeferredTypesLoad
