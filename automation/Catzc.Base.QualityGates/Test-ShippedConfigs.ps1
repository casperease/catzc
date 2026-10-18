<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
    name: test-shipped-configs
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
    cites:
      - ADR-AUTO-TEST#35
      - ADR-CONF-LOADING#4
---
#>

function Test-ShippedConfigs {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $registry = (Get-Config -Config configs).configs

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
