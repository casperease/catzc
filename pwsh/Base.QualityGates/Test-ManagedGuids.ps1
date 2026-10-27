function Test-ManagedGuids {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()

    $config = Get-Config -Config guids
    $registries = @($config.registries | Where-Object { $_ })
    $registryFile = ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/guids.yml')
    $members = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GlobSetFile -Name 'repository'),
        [System.StringComparer]::Ordinal)
    foreach ($file in (@(Get-GuidScanFiles) + $registryFile + $registries)) {
        if (-not $members.Contains($file)) {
            $issues.Add("${file}: read by the guid scan but outside the 'repository' globset (globs.yml) — its protection identity must cover it")
        }
    }

    $registered = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @($config.guids.Keys)) {
        [void]$registered.Add("$($config.guids[$name].guid)")
    }
    # A registry is the one declaration of its GUIDs: each value in it counts as registered, so it is never listed here as well.
    $guidPattern = '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'
    foreach ($registry in $registries) {
        $path = Join-Path (Get-RepositoryRoot) $registry
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $issues.Add("guids.yml registries: '$registry' does not exist — remove it, or restore the registry")
            continue
        }
        foreach ($match in [regex]::Matches([System.IO.File]::ReadAllText($path), $guidPattern)) {
            [void]$registered.Add($match.Value)
        }
    }
    $denied = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @($config.denied.Keys)) {
        [void]$denied.Add("$($config.denied[$name].guid)")
    }

    $found = @(Get-RepositoryGuids)
    $foundValues = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($record in $found) {
        [void]$foundValues.Add($record.guid)
        if ($denied.Contains($record.guid)) {
            $issues.Add("$($record.file):$($record.line) $($record.guid): a denied guid — construct it at runtime (e.g. [guid]::Empty) instead")
        }
        elseif (-not $registered.Contains($record.guid)) {
            $issues.Add("$($record.file):$($record.line) $($record.guid): not registered in guids.yml or a registry it names — mint a readable placeholder with ConvertTo-Guid, or remove it")
        }
    }
    foreach ($name in @($config.guids.Keys)) {
        if (-not $foundValues.Contains("$($config.guids[$name].guid)")) {
            $issues.Add("guids.yml ${name}: no tracked file references it — remove the dead entry")
        }
    }

    Write-QualityGateReport -Subject 'managed-guids' -Title 'Test-ManagedGuids' -Issues $issues `
        -Facts ([ordered]@{ Registered = $registered.Count; Occurrences = $found.Count }) `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
