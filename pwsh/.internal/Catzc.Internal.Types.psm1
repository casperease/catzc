Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

function Get-CombinedTypeHash {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ModulesRoot,

        [string[]] $Module,

        [string] $StampPath
    )

    $selected = $null
    if ($PSBoundParameters.ContainsKey('Module')) {
        $selected = [System.Collections.Generic.HashSet[string]]::new([string[]] @($Module), [System.StringComparer]::OrdinalIgnoreCase)
    }

    $files = [System.Collections.Generic.List[object]]::new()
    foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($ModulesRoot)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDir)
        if ($moduleName.StartsWith('.') -or ($null -ne $selected -and -not $selected.Contains($moduleName))) {
            continue
        }
        $typesDir = [System.IO.Path]::Combine($moduleDir, 'types')
        if (-not [System.IO.Directory]::Exists($typesDir)) {
            continue
        }
        foreach ($sourcePath in [System.IO.Directory]::EnumerateFiles($typesDir, '*.cs')) {
            $base = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
            $files.Add([pscustomobject]@{
                    Module = $moduleName
                    Base   = $base
                    Key    = "$moduleName/$base"
                    Path   = $sourcePath
                })
        }
    }

    $compiledTypesDir = [System.IO.Path]::Combine($ModulesRoot, '.compiled', 'types')
    if ($null -eq $selected -and [System.IO.Directory]::Exists($compiledTypesDir)) {
        foreach ($moduleDir in [System.IO.Directory]::EnumerateDirectories($compiledTypesDir)) {
            $moduleName = [System.IO.Path]::GetFileName($moduleDir)
            foreach ($sourcePath in [System.IO.Directory]::EnumerateFiles($moduleDir, '*.cs')) {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($sourcePath)
                $files.Add([pscustomobject]@{
                        Module = $moduleName
                        Base   = $base
                        Key    = "$moduleName/$base"
                        Path   = $sourcePath
                    })
            }
        }
    }

    if ($files.Count -eq 0) {
        return [pscustomobject]@{ CombinedHash = $null; Snapshot = [ordered]@{}; Files = @() }
    }

    $sortedFiles = [object[]]$files.ToArray()
    [System.Array]::Sort($sortedFiles, [System.Comparison[object]] { param($a, $b) [System.StringComparer]::Ordinal.Compare($a.Key, $b.Key) })

    $stamped = @{}
    if ($StampPath -and [System.IO.File]::Exists($StampPath)) {
        try {
            $document = [System.IO.File]::ReadAllText($StampPath) | ConvertFrom-Json -AsHashtable
            if ($document -is [hashtable] -and $document['files'] -is [hashtable]) {
                $stamped = $document['files']
            }
        }
        catch {
            Write-Verbose "Ignoring the unreadable types stamp '$StampPath': $($_.Exception.Message)"
        }
    }

    $latin1 = [System.Text.Encoding]::Latin1
    $snapshot = [ordered]@{}
    $memo = [ordered]@{}
    $rehashed = 0
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        $stringBuilder = [System.Text.StringBuilder]::new()
        foreach ($file in $sortedFiles) {
            $info = [System.IO.FileInfo]::new($file.Path)
            $known = $stamped[$file.Key]
            if ($known -is [hashtable] -and $known['length'] -eq $info.Length -and $known['ticks'] -eq $info.LastWriteTimeUtc.Ticks -and $known['hash'] -is [string]) {
                $fileHash = $known['hash']
            }
            else {
                $normalizedBytes = $latin1.GetBytes($latin1.GetString([System.IO.File]::ReadAllBytes($file.Path)).Replace("`r", ''))
                $fileHash = [System.BitConverter]::ToString($sha.ComputeHash($normalizedBytes)) -replace '-', ''
                $rehashed++
            }
            $snapshot[$file.Key] = $fileHash
            $memo[$file.Key] = [ordered]@{ length = $info.Length; ticks = $info.LastWriteTimeUtc.Ticks; hash = $fileHash }
            [void]$stringBuilder.Append($file.Key).Append('|').Append($fileHash).Append("`n")
        }
        $bytes = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($stringBuilder.ToString()))
    }
    finally {
        $sha.Dispose()
    }
    $combinedHash = ([System.BitConverter]::ToString($bytes) -replace '-', '').Substring(0, 8).ToLowerInvariant()

    if ($StampPath -and ($rehashed -gt 0 -or $stamped.Count -ne $memo.Count)) {
        $folder = [System.IO.Path]::GetDirectoryName($StampPath)
        if ($folder) {
            [System.IO.Directory]::CreateDirectory($folder) | Out-Null
        }
        $json = [ordered]@{ combined = $combinedHash; files = $memo } | ConvertTo-Json -Depth 4 -Compress
        $temporary = "$StampPath.$([guid]::NewGuid().ToString('N')).tmp"
        [System.IO.File]::WriteAllText($temporary, $json)
        # The stamp is a cache that parallel imports share: a replace that loses to another process's read or replace leaves the next import to rehash.
        try {
            [System.IO.File]::Move($temporary, $StampPath, $true)
        }
        catch [System.UnauthorizedAccessException], [System.IO.IOException] {
            Write-Verbose "Skipped the types stamp write; another process holds '$StampPath': $($_.Exception.Message)"
            [System.IO.File]::Delete($temporary)
        }
    }

    [pscustomobject]@{
        CombinedHash = $combinedHash
        Snapshot     = $snapshot
        Files        = $sortedFiles
        Rehashed     = $rehashed
    }
}

function Get-LoadedTypeDrift {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Reads $global:__CatzcTypes, the per-root session record of loaded types the loader keeps (ADR-AUTO-TYPES-STALETYPESGUARD)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $ModulesRoot,

        [pscustomobject] $HashResult
    )

    if (-not $HashResult) {
        $HashResult = Get-CombinedTypeHash $ModulesRoot
    }
    $rootKey = [System.IO.Path]::GetFullPath($ModulesRoot)
    $snapshot = $HashResult.Snapshot
    $records = Get-Variable -Name '__CatzcTypes' -Scope Global -ValueOnly -ErrorAction Ignore
    $prior = if ($records) {
        $records[$rootKey]
    }
    else {
        $null
    }

    $typeNames = @(foreach ($file in $HashResult.Files) {
            "$($file.Module).$($file.Base)"
        })
    $loaded = $false
    foreach ($typeName in $typeNames) {
        if (([System.Management.Automation.PSTypeName]$typeName).Type) {
            $loaded = $true
            break
        }
    }

    $drift = [System.Collections.Generic.List[string]]::new()
    $summary = $null
    if ($loaded -and $prior -and $prior.Hash -ne $HashResult.CombinedHash) {
        foreach ($key in $snapshot.Keys) {
            if (-not $prior.Snapshot.Contains($key)) {
                $drift.Add("added $key")
            }
            elseif ($prior.Snapshot[$key] -ne $snapshot[$key]) {
                $drift.Add("changed $key")
            }
        }
        foreach ($key in $prior.Snapshot.Keys) {
            if (-not $snapshot.Contains($key)) {
                $drift.Add("removed $key")
            }
        }
        $summary = "C# types changed since they were loaded ($($prior.Hash) -> $($HashResult.CombinedHash))."
    }
    elseif ($loaded -and -not $prior) {
        $otherRoots = [System.Collections.Generic.List[string]]::new()
        $recordEntries = if ($records) {
            @($records.GetEnumerator())
        }
        else {
            @()
        }
        foreach ($key in $snapshot.Keys) {
            foreach ($entry in $recordEntries) {
                if ($entry.Key -ne $rootKey -and $entry.Value.Snapshot.Contains($key)) {
                    if ($entry.Value.Snapshot[$key] -ne $snapshot[$key]) {
                        $drift.Add("changed $key")
                    }
                    if (-not $otherRoots.Contains($entry.Key)) {
                        $otherRoots.Add($entry.Key)
                    }
                    break
                }
            }
        }
        foreach ($file in $HashResult.Files) {
            if (-not ([System.Management.Automation.PSTypeName]"$($file.Module).$($file.Base)").Type) {
                $drift.Add("not loaded $($file.Key)")
            }
        }
        if ($drift.Count) {
            $loadedFrom = if ($otherRoots.Count) {
                "'" + ($otherRoots -join "', '") + "'"
            }
            else {
                'another root'
            }
            $summary = "C# types already loaded from $loadedFrom differ from the sources under '$rootKey'."
        }
    }

    $loadedHash = if ($prior) {
        $prior.Hash
    }
    else {
        $null
    }
    [pscustomobject]@{
        RootKey      = $rootKey
        Loaded       = $loaded
        Current      = $null -eq $summary
        LoadedHash   = $loadedHash
        SourceHash   = $HashResult.CombinedHash
        Drift        = [string[]] $drift.ToArray()
        MissingTypes = [string[]] @($drift | Where-Object { $_.StartsWith('added ') -or $_.StartsWith('not loaded ') })
        Summary      = $summary
    }
}

function Build-CombinedTypeAssembly {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $ModulesRoot,

        [string[]] $Module,

        [Parameter(Mandatory)]
        [string] $OutputDirectory
    )

    $hashArguments = @{ ModulesRoot = $ModulesRoot }
    if ($PSBoundParameters.ContainsKey('Module')) {
        $hashArguments.Module = $Module
    }
    $hashResult = Get-CombinedTypeHash @hashArguments
    if ($hashResult.Files.Count -eq 0) {
        return $null
    }

    $dll = [System.IO.Path]::Combine($OutputDirectory, ('Catzc.Types.{0}.dll' -f $hashResult.CombinedHash))
    if ([System.IO.File]::Exists($dll)) {
        return [pscustomobject]@{
            Hash     = $hashResult.CombinedHash
            Path     = $dll
            Manifest = Write-TypesAssemblyManifest -Path $dll
            Files    = $hashResult.Files
            Snapshot = $hashResult.Snapshot
            Compiled = $false
        }
    }

    # Freeze the sources, then hash and compile the copy, so the DLL's name keys exactly the bytes compiled.
    $frozenRoot = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), "catzc-types-$PID-$([guid]::NewGuid().ToString('N'))")
    try {
        foreach ($file in $hashResult.Files) {
            $frozenTypes = [System.IO.Path]::Combine($frozenRoot, $file.Module, 'types')
            [System.IO.Directory]::CreateDirectory($frozenTypes) | Out-Null
            try {
                [System.IO.File]::Copy($file.Path, [System.IO.Path]::Combine($frozenTypes, "$($file.Base).cs"))
            }
            catch [System.IO.FileNotFoundException], [System.IO.DirectoryNotFoundException] {
                throw "C# type source '$($file.Path)' was removed while the types were being built. Re-run the build."
            }
        }
        $frozenArguments = @{ ModulesRoot = $frozenRoot }
        if ($PSBoundParameters.ContainsKey('Module')) {
            $frozenArguments.Module = $Module
        }
        $frozen = Get-CombinedTypeHash @frozenArguments
        $dll = [System.IO.Path]::Combine($OutputDirectory, ('Catzc.Types.{0}.dll' -f $frozen.CombinedHash))
        $compiled = $false
        if (-not [System.IO.File]::Exists($dll)) {
            [System.IO.Directory]::CreateDirectory($OutputDirectory) | Out-Null
            $tmp = "$dll.$PID.tmp"
            try {
                try {
                    Add-Type -Path @($frozen.Files.Path) -OutputAssembly $tmp -OutputType Library -ErrorAction Stop
                }
                catch {
                    # The compiler names the frozen copies; name the sources the reader edits instead.
                    $message = $_.Exception.Message
                    foreach ($file in $hashResult.Files) {
                        $message = $message.Replace([System.IO.Path]::Combine($frozenRoot, $file.Module, 'types', "$($file.Base).cs"), $file.Path)
                    }
                    throw $message
                }
                try {
                    [System.IO.File]::Move($tmp, $dll)
                }
                catch {
                    if (-not [System.IO.File]::Exists($dll)) {
                        throw
                    }
                }
            }
            finally {
                if ([System.IO.File]::Exists($tmp)) {
                    [System.IO.File]::Delete($tmp)
                }
            }
            $compiled = $true
        }
    }
    finally {
        if ([System.IO.Directory]::Exists($frozenRoot)) {
            [System.IO.Directory]::Delete($frozenRoot, $true)
        }
    }

    [pscustomobject]@{
        Hash     = $frozen.CombinedHash
        Path     = $dll
        Manifest = Write-TypesAssemblyManifest -Path $dll
        Files    = $hashResult.Files
        Snapshot = $frozen.Snapshot
        Compiled = $compiled
    }
}

function Get-TypesShadowRoot {
    [OutputType([string])]
    param()

    if ($IsWindows) {
        Join-Path $env:LOCALAPPDATA 'catzc\types'
    }
    else {
        Join-Path $HOME '.local/share/catzc/types'
    }
}

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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes only the per-user shadow cache, an internal load-time detail of the importer; the load itself is announced by the caller (Import-CSharpTypes).')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The binary load is announced by the caller: Import-CSharpTypes writes "Loaded types <dll>" through Write-ImporterMessage -StateChange; the analyzer rule SpellOutIdentifiers runs inside the analyzer engine, where only diagnostic records may be emitted.')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [string] $ShadowRoot = (Get-TypesShadowRoot),

        [TimeSpan] $PruneAfter = [TimeSpan]::FromDays(1),

        # false loads the file in place: a system that does not lock a loaded file needs no copy (types-load.yml shadowCopy).
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
    $shadow = [System.IO.Path]::Combine($ShadowRoot, [System.IO.Path]::GetFileName($Path))
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

    $staleBefore = [DateTime]::UtcNow - $PruneAfter
    foreach ($other in [System.IO.Directory]::EnumerateFiles($ShadowRoot, 'Catzc.Types.*.dll')) {
        if ($other -eq $shadow -or [System.IO.File]::GetLastWriteTimeUtc($other) -ge $staleBefore) {
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

$script:typesAliasAttribute = 'Catzc.Base.Objects.PSTypeAliasAttribute'
$script:typesDisplayAttribute = 'Catzc.Base.Objects.ConsoleDisplayAttribute'

function Get-TypesAssemblyManifest {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not [System.IO.File]::Exists($Path)) {
        throw "Cannot read the types assembly: '$Path' does not exist."
    }

    $tokens = [System.Reflection.Metadata.Ecma335.MetadataTokens]
    $rows = @{}
    $stream = [System.IO.MemoryStream]::new([System.IO.File]::ReadAllBytes($Path))
    $peReader = [System.Reflection.PortableExecutable.PEReader]::new($stream)
    try {
        $reader = [System.Reflection.Metadata.PEReaderExtensions]::GetMetadataReader($peReader)
        foreach ($handle in $reader.TypeDefinitions) {
            $definition = $reader.GetTypeDefinition($handle)
            $aliases = [System.Collections.Generic.List[string]]::new()
            $display = $null
            foreach ($attributeHandle in $definition.GetCustomAttributes()) {
                $attribute = $reader.GetCustomAttribute($attributeHandle)
                if ($attribute.Constructor.Kind -ne [System.Reflection.Metadata.HandleKind]::MethodDefinition) {
                    continue
                }
                $constructor = $reader.GetMethodDefinition($tokens::MethodDefinitionHandle($tokens::GetRowNumber($attribute.Constructor)))
                $attributeType = $reader.GetTypeDefinition($constructor.GetDeclaringType())
                $attributeName = $reader.GetString($attributeType.Namespace) + '.' + $reader.GetString($attributeType.Name)
                if ($attributeName -ne $script:typesAliasAttribute -and $attributeName -ne $script:typesDisplayAttribute) {
                    continue
                }
                $blob = $reader.GetBlobReader($attribute.Value)
                [void] $blob.ReadUInt16()
                if ($attributeName -eq $script:typesAliasAttribute) {
                    $aliases.Add($blob.ReadSerializedString())
                }
                else {
                    $display = [System.Collections.Generic.List[string]]::new()
                    $count = $blob.ReadInt32()
                    for ($i = 0; $i -lt $count; $i++) {
                        $display.Add($blob.ReadSerializedString())
                    }
                }
            }
            $base = $null
            if ($definition.BaseType.Kind -eq [System.Reflection.Metadata.HandleKind]::TypeDefinition) {
                $base = $tokens::GetRowNumber($definition.BaseType)
            }
            $rows[$tokens::GetRowNumber($handle)] = [pscustomobject]@{
                Name    = $reader.GetString($definition.Namespace) + '.' + $reader.GetString($definition.Name)
                Public  = ($definition.Attributes -band [System.Reflection.TypeAttributes]::VisibilityMask) -eq [System.Reflection.TypeAttributes]::Public
                Aliases = $aliases
                Display = $display
                Base    = $base
            }
        }
    }
    finally {
        $peReader.Dispose()
        $stream.Dispose()
    }

    $types = foreach ($row in $rows.Values) {
        if (-not $row.Public) {
            continue
        }
        $effective = $row
        while ($null -eq $effective.Display -and $null -ne $effective.Base -and $rows.ContainsKey($effective.Base)) {
            $effective = $rows[$effective.Base]
        }
        $displayNames = [string[]] @()
        if ($null -ne $effective.Display) {
            $displayNames = [string[]] $effective.Display.ToArray()
        }
        [pscustomobject]@{
            Name    = $row.Name
            Aliases = [string[]] @($row.Aliases)
            Display = $displayNames
        }
    }
    $sorted = [object[]] @($types)
    [System.Array]::Sort($sorted, [System.Comparison[object]] { param($a, $b) [System.StringComparer]::Ordinal.Compare($a.Name, $b.Name) })
    [pscustomobject]@{ Types = $sorted }
}

function Write-TypesAssemblyManifest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Writes a generated build artifact beside the assembly; the build and the importer announce the build.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The caller (Build-CombinedTypeAssembly, Import-CSharpTypes) announces the build; the analyzer rule runs where only diagnostic records may be emitted.')]
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Path
    )

    $manifestPath = [System.IO.Path]::ChangeExtension($Path, 'json')
    if ([System.IO.File]::Exists($manifestPath)) {
        return $manifestPath
    }

    $hash = [System.IO.Path]::GetFileNameWithoutExtension($Path) -replace '^Catzc\.Types\.', ''
    $manifest = [ordered]@{ hash = $hash; types = @((Get-TypesAssemblyManifest -Path $Path).Types | ForEach-Object { [ordered]@{ name = $_.Name; aliases = @($_.Aliases); display = @($_.Display) } }) }
    $json = (ConvertTo-Json -InputObject $manifest -Depth 5) -replace "`r`n", "`n"
    $tmp = "$manifestPath.$PID.tmp"
    try {
        [System.IO.File]::WriteAllText($tmp, $json + "`n", [System.Text.UTF8Encoding]::new($false))
        [System.IO.File]::Move($tmp, $manifestPath)
    }
    catch {
        # A concurrent writer that won the race left an equivalent manifest; anything else is a real failure.
        if (-not [System.IO.File]::Exists($manifestPath)) {
            throw
        }
    }
    finally {
        if ([System.IO.File]::Exists($tmp)) {
            [System.IO.File]::Delete($tmp)
        }
    }
    $manifestPath
}

# The default row and the allowed values live here, not on a C# type: the policy is read while the types assembly is still unloaded.
$script:typesLoadDefault = [ordered]@{ Load = 'lazy'; Trigger = 'lookup-hook'; EagerTypes = @(); ShadowCopy = $true }
$script:typesLoadHosts = 'console', 'headless'
$script:typesLoadSystems = 'windows', 'unix'
$script:typesLoadRunModes = 'source', 'build'
$script:typesLoadLoads = 'lazy', 'eager'
$script:typesLoadTriggers = 'lookup-hook', 'none'
$script:typesLoadKeys = 'load', 'trigger', 'shadowCopy', 'eagerTypes'

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
    $policy = [ordered]@{ Cell = $cell; Engine = $Engine }
    foreach ($name in 'Load', 'Trigger', 'ShadowCopy') {
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
    if ($policy.Trigger -eq 'none' -and $policy.Load -ne 'eager') {
        throw "Row '$cell' has trigger 'none' with load '$($policy.Load)'; nothing would ever load the types. 'none' needs load eager."
    }
    [pscustomobject]$policy
}

function Register-DeferredTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Session-global by design: the pending record must survive a re-import of this module, like $global:__CatzcTypes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Records in-memory session state only; the importer announces the deferral')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $RootKey,

        [Parameter(Mandatory)]
        [string] $Path,

        [bool] $ShadowCopy = $true
    )

    if (-not (Get-Variable -Name '__CatzcDeferredTypes' -Scope Global -ValueOnly -ErrorAction Ignore)) {
        $global:__CatzcDeferredTypes = @{}
    }
    $global:__CatzcDeferredTypes[$RootKey] = @{ Path = $Path; ShadowCopy = $ShadowCopy; Loaded = $false }
}

function Initialize-Types {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Reads and marks $global:__CatzcDeferredTypes, the session-global pending record')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Loads the assembly the importer already verified and announced; there is nothing to confirm')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The importer announces the change: an eager load writes "Registered default display properties" through Write-ImporterMessage -StateChange, and a deferred load was announced as "Deferred types" when the importer registered it; Write-ImporterMessage is gone once the lazy load runs')]
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
        foreach ($type in $manifest.types) {
            foreach ($alias in @($type.aliases)) {
                [void] $accelerators::Remove($alias)
                $accelerators::Add($alias, ([System.Management.Automation.PSTypeName]$type.name).Type)
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

function Enable-DeferredTypesLoad {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Justification = 'Reads $global:__CatzcDeferredTypes, the session-global pending record')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Installs an in-memory lookup hook for this session only; the importer announces the deferral')]
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

    $script:deferredTypesCommands = [System.Collections.Generic.HashSet[string]]::new([string[]]$CommandName, [System.StringComparer]::OrdinalIgnoreCase)
    $ExecutionContext.InvokeCommand.PreCommandLookupAction = {
        param($commandName)
        if ($script:deferredTypesCommands.Contains($commandName)) {
            Initialize-Types | Out-Null
        }
    }
}

Export-ModuleMember -Function Get-CombinedTypeHash, Get-LoadedTypeDrift, Build-CombinedTypeAssembly, Get-TypesShadowRoot, Get-TypesStampPath, Import-TypesAssembly, Test-TypesAssemblyContent, Get-TypesAssemblyManifest, Write-TypesAssemblyManifest, Get-TypesLoadPolicy, Register-DeferredTypes, Initialize-Types, Enable-DeferredTypesLoad
