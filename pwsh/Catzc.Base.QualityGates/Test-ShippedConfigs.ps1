function Test-ShippedConfigs {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $registryConfig = Get-Config -Config configs
    $registry = $registryConfig.configs

    $shipped = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $configCount = 0
    $modulesRoot = Get-CatzcModulesRoot
    foreach ($moduleDirectory in ([System.IO.Directory]::EnumerateDirectories($modulesRoot) | Sort-Object)) {
        $moduleName = [System.IO.Path]::GetFileName($moduleDirectory)
        $configsDirectory = Join-Path $moduleDirectory 'configs'
        if ($moduleName -match '^\.' -or -not [System.IO.Directory]::Exists($configsDirectory)) {
            continue
        }
        foreach ($file in ([System.IO.Directory]::EnumerateFiles($configsDirectory, '*.yml') | Sort-Object)) {
            $name = [System.IO.Path]::GetFileNameWithoutExtension($file)
            $configCount++
            [void]$shipped.Add($name)
            if (-not $registry.ContainsKey($name)) {
                $issues.Add("$moduleName/configs/$name.yml: no type registered in configs.yml — add a C# config type and its entry")
                continue
            }
            try {
                $null = Get-Config -Config $name -Module $moduleName
            }
            catch {
                $issues.Add("$moduleName/configs/$name.yml: does not load — $($_.Exception.Message)")
                continue
            }
            $raw = Get-Content -LiteralPath $file -Raw | ConvertFrom-Yaml -Ordered
            $reasons = if ($registryConfig.differs.ContainsKey($name)) {
                $registryConfig.differs[$name]
            }
            $differing = @(if ($raw -is [System.Collections.IDictionary]) {
                    [Catzc.Base.Config.ConfigDefaultDifference]::Compare(($registry[$name] -as [type]), $raw)
                })
            foreach ($difference in $differing) {
                if (-not ($reasons -and $reasons.ContainsKey($difference.key))) {
                    $issues.Add("$moduleName/configs/$name.yml: '$($difference.key)' ships '$($difference.shipped)' where its type's default is '$($difference.declared)' — match them, or give the reason under differs in configs.yml")
                }
            }
            $differingKeys = @($differing | ForEach-Object { $_.key })
            $listedKeys = @(if ($reasons) {
                    $reasons.Keys
                })
            foreach ($listed in $listedKeys) {
                if ($listed -notin $differingKeys) {
                    $issues.Add("configs.yml: '$name' differs '$listed', but the shipped value and the type's default agree — remove the entry")
                }
            }
        }
    }

    foreach ($name in $registry.Keys) {
        if (-not $shipped.Contains($name)) {
            $issues.Add("configs.yml: '$name' names no shipped config — remove the entry")
        }
        if (-not ($registry[$name] -as [type])) {
            $issues.Add("configs.yml: '$name' type '$($registry[$name])' does not resolve")
        }
    }

    Write-QualityGateReport -Subject 'shipped-configs' -Title 'Test-ShippedConfigs' -Issues $issues `
        -Facts ([ordered]@{ Configs = $configCount; Types = $registry.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
