function Build-ConsumerTypes {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '',
        Justification = 'Session-global by design: $global:__CatzcTypes holds the per-namespace hash+snapshot that must survive module reimport to detect C# source changes across the session')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$WorkingRoot,

        [Parameter(Mandatory)]
        [string]$CatzcHash
    )

    # The config registry is not loaded yet, so the consumer's tracks are read straight from the working root's variants config, the file the
    # config index reads whole once it is there; Variants cannot be called this early.
    $variantsPath = [System.IO.Path]::Combine($WorkingRoot, '.catzc', 'configs', 'variants.yml')
    if (-not [System.IO.File]::Exists($variantsPath)) {
        return
    }
    $declared = ConvertFrom-Yaml ([System.IO.File]::ReadAllText($variantsPath))
    if (-not ($declared -is [System.Collections.IDictionary]) -or -not $declared.Contains('tracks') -or -not ($declared['tracks'] -is [System.Collections.IDictionary])) {
        return
    }
    $sourcesByNamespace = [ordered]@{}
    foreach ($trackName in @($declared['tracks'].Keys)) {
        $track = $declared['tracks'][$trackName]
        if (-not ($track -is [System.Collections.IDictionary]) -or -not $track.Contains('type') -or $track['type'] -cne 'modules' -or
            -not $track.Contains('namespace') -or -not $track['namespace'] -or -not $track.Contains('members')) {
            continue
        }
        $trackNamespace = [string] $track['namespace']
        if ($trackNamespace -ceq 'Catzc' -or $trackNamespace.StartsWith('Catzc.', [System.StringComparison]::Ordinal)) {
            throw "The track '$trackName' has the namespace '$trackNamespace', which is the system's (ADR-AUTO-CONSUMER-OWNTRACKS); a consumer track's namespace is its own."
        }
        foreach ($member in @($track['members'])) {
            $place = if ($member -is [System.Collections.IDictionary]) {
                if ($member.Contains('path')) {
                    [string] $member['path']
                }
            }
            else {
                [string] $member
            }
            if (-not $place -or $place.IndexOfAny([char[]]'*?[') -ge 0) {
                continue
            }
            $placeDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($WorkingRoot, $place))
            if (-not [System.IO.Directory]::Exists($placeDirectory)) {
                continue
            }
            foreach ($moduleDirectory in [System.IO.Directory]::EnumerateDirectories($placeDirectory)) {
                $typesDirectory = [System.IO.Path]::Combine($moduleDirectory, 'types')
                if ([System.IO.Path]::GetFileName($moduleDirectory).StartsWith('.') -or -not [System.IO.Directory]::Exists($typesDirectory)) {
                    continue
                }
                if (-not $sourcesByNamespace.Contains($trackNamespace)) {
                    $sourcesByNamespace[$trackNamespace] = [System.Collections.Generic.List[string]]::new()
                }
                foreach ($source in [System.IO.Directory]::EnumerateFiles($typesDirectory, '*.cs')) {
                    $sourcesByNamespace[$trackNamespace].Add($source)
                }
            }
        }
    }

    foreach ($consumerNamespace in @($sourcesByNamespace.Keys)) {
        if ($sourcesByNamespace[$consumerNamespace].Count -eq 0) {
            continue
        }
        # The consumer's assembly references catzc's, so catzc's must be loaded: a deferred load happens here.
        Initialize-Types | Out-Null
        $catzcFile = (Get-TypesAssemblyPrefix) + $CatzcHash + '.dll'
        $catzcAssembly = @([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {
                -not $_.IsDynamic -and $_.Location -and [System.IO.Path]::GetFileName($_.Location) -ceq $catzcFile }) | Select-Object -Last 1
        if (-not $catzcAssembly) {
            throw "Cannot compile the types of '$consumerNamespace': the catzc types assembly '$catzcFile' is not loaded."
        }
        $built = Build-CombinedTypeAssembly -Source ([string[]] @($sourcesByNamespace[$consumerNamespace] | Sort-Object)) `
            -OutputDirectory ([System.IO.Path]::Combine($WorkingRoot, 'out')) -Namespace $consumerNamespace -Reference @($catzcAssembly.Location)
        $relativeBuilt = ([System.IO.Path]::GetRelativePath($WorkingRoot, $built.Path)) -replace '\\', '/'
        if ($built.Compiled) {
            Write-ImporterMessage "Built $relativeBuilt"
        }

        # The stale-types record of this namespace is its own, apart from catzc's.
        $recordKey = "namespace:$consumerNamespace"
        $previous = $global:__CatzcTypes[$recordKey]
        if ($previous) {
            if ($previous.Hash -ne $built.Hash) {
                if (Test-IsRunningInPipeline) {
                    throw "The C# types of '$consumerNamespace' changed since they were loaded ($($previous.Hash) -> $($built.Hash)). Restart PowerShell to pick up the change."
                }
                Write-ImporterMessage "Using the old C# types of '$consumerNamespace', restart PowerShell to pick up the change" -ForegroundColor Yellow
            }
            continue
        }

        $loadedFrom = Import-TypesAssembly -Path $built.Path -Namespace $consumerNamespace
        $assembly = @([System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object {
                -not $_.IsDynamic -and $_.Location -eq $loadedFrom }) | Select-Object -Last 1
        $accelerators = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')
        $manifest = [System.IO.File]::ReadAllText($built.Manifest) | ConvertFrom-Json
        foreach ($type in $manifest.types) {
            foreach ($alias in @($type.aliases)) {
                if (-not $alias.StartsWith("$consumerNamespace.", [System.StringComparison]::Ordinal)) {
                    throw "The alias '$alias' of '$($type.name)' is outside the namespace '$consumerNamespace'; a consumer's accelerators are under its own prefix (ADR-PWSH-TYPES-LOADKEYEDONNAMESPACE)."
                }
                [void] $accelerators::Remove($alias)
                $accelerators::Add($alias, $assembly.GetType($type.name))
            }
        }
        $global:__CatzcTypes[$recordKey] = [pscustomobject]@{ Hash = $built.Hash; Snapshot = $built.Snapshot }
        Write-ImporterMessage "Loaded types $relativeBuilt" -StateChange
    }
}
