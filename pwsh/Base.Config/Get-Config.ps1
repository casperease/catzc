function Get-Config {
    [CmdletBinding(DefaultParameterSetName = 'Load')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^[a-z0-9]+(-[a-z0-9]+)*$')]
        [string] $Config,

        [Parameter(ParameterSetName = 'Load')]
        [string] $Module,

        [Parameter(Mandatory, ParameterSetName = 'ListOwners')]
        [switch] $ListOwners
    )

    if ($ListOwners) {
        return Resolve-ConfigEntry -Config $Config -All
    }

    # The one reader of every config, so a name it cannot discover throws here and never falls back to a guess.
    $entry = try {
        Resolve-ConfigEntry -Config $Config -Module $Module   # @{ Name; Module; Path }
    }
    catch {
        # A file and a same-named folder in one module read as two owners, so the pair is named before the ambiguity error.
        foreach ($owner in @(Resolve-ConfigEntry -Config $Config -All | Group-Object { $_.Module } | Where-Object Count -GT 1)) {
            $paths = ($owner.Group | ForEach-Object { $_.Path }) -join "' and '"
            throw "Config '$Config' in module '$($owner.Name)' is both a file and a same-named folder: '$paths'; keep one."
        }
        throw
    }

    # The cache key carries the overlay fragment's stamp, so an edited fragment is never served from a stale merge.
    $fragmentPath = $null
    $cacheKey = if ($entry.Path) {
        $entry.Path
    }
    else {
        "type:$($entry.Module)/$($entry.Name)"
    }
    $overlayRoot = Get-ConfigOverlayRoot
    if ($overlayRoot) {
        # The overlay folder is named like the bundled module's, without its namespace; a type with no shipped file finds it by its module.
        $folder = if ($entry['Folder']) {
            $entry['Folder']
        }
        else {
            $loaded = Get-Module -Name $entry.Module | Select-Object -First 1
            Assert-NotNull $loaded -ErrorText "Get-Config: config '$($entry.Name)' belongs to module '$($entry.Module)', which is not loaded."
            [System.IO.Path]::GetFileName($loaded.ModuleBase)
        }
        $candidate = [System.IO.Path]::Combine($overlayRoot, $folder, 'configs', "$($entry.Name).yml")
        if ([System.IO.File]::Exists($candidate)) {
            $fragmentPath = $candidate
            $stamp = [System.IO.FileInfo]::new($candidate)
            $cacheKey = "$cacheKey|$candidate|$($stamp.LastWriteTimeUtc.Ticks)|$($stamp.Length)"
        }
    }
    # Inside a source, such as a commit, the key carries its name, so the working tree's entry is never served.
    $source = Get-RepositoryTextSource
    if ($source) {
        $cacheKey = "$cacheKey|source:$($source.Name)"
    }

    # Keyed by the resolved file, so two names for one file share one parsed object and one file never yields two.
    if ($null -eq $ExecutionContext.SessionState.PSVariable.GetValue('script:configCache')) {
        # Probed through the variable table, so a first call under strict mode finds no cache instead of throwing.
        $script:configCache = @{}
    }
    if ($script:configCache.ContainsKey($cacheKey)) {
        return $script:configCache[$cacheKey]
    }

    $raw = if ($entry.Path -and [System.IO.Directory]::Exists($entry.Path)) {
        # A split config: its parts merge in ordinal name order, and a key two parts both set fails the load.
        $parts = [string[]] @(Get-RepositoryTextFile $entry.Path -Filter '*.yml')
        Assert-True ($parts.Count -gt 0) -ErrorText "Config folder '$($entry.Path)' holds no *.yml part."
        $merged = [ordered]@{}
        foreach ($part in $parts) {
            $partRaw = Read-RepositoryText $part | ConvertFrom-Yaml -Ordered
            Assert-True ($partRaw -is [System.Collections.IDictionary]) -ErrorText "Config part '$part' must be a map."
            $merged = Merge-ConfigFragment -Base $merged -Fragment $partRaw -Disjoint
        }
        $merged
    }
    elseif ($entry.Path) {
        $text = Read-RepositoryText $entry.Path
        Assert-True ($null -ne $text) -ErrorText "Path does not exist: $($entry.Path)$(if ($source) { " (in source $($source.Name))" })"
        Assert-True ($text.Length -gt 0) -ErrorText "Config file '$($entry.Path)' is empty (0 bytes): the read raced a writer, or the file was truncated on disk."
        $text | ConvertFrom-Yaml -Ordered
    }
    else {
        [ordered]@{}
    }

    $registered = (Get-ConfigRegistry)[$entry.Name]
    if ($fragmentPath) {
        $sealedConfigs = ([Catzc.Base.Config.ConfigsConfig]::new(@{ configs = Get-ConfigRegistry })).sealedConfigs
        if ($sealedConfigs -contains $entry.Name) {
            throw "Config '$($entry.Name)' is sealed (configs.yml overridable: false), so the overlay may not change it: remove $fragmentPath."
        }
        $fragment = Get-Content $fragmentPath -Raw | ConvertFrom-Yaml -Ordered
        Assert-True ($raw -is [System.Collections.IDictionary] -and ($null -eq $fragment -or
                $fragment -is [System.Collections.IDictionary])) -ErrorText "Overlay fragment $fragmentPath cannot merge onto config '$($entry.Name)': a fragment and its config must both be maps."
        if ($null -ne $fragment) {
            $raw = Merge-ConfigFragment -Base $raw -Fragment $fragment
        }
        Write-Verbose "Merged overlay fragment '$fragmentPath' onto config '$($entry.Name)'"
    }

    $ret = $raw
    if ($registered) {
        # The registered type maps and validates at construction, so a malformed file can never become a config object.
        $type = [type] $registered['type']
        $ret = $type::new($raw)
    }

    Write-Verbose "Loaded config '$($entry.Name)' from: $(if ($entry.Path) { $entry.Path } else { "its type's defaults ($($entry.Module))" })"
    $script:configCache[$cacheKey] = $ret
    $script:configCache[$cacheKey]
}
