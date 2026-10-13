<#
.SYNOPSIS
    Quality gate: every shipped config has a registered C# config type and loads through it.
.DESCRIPTION
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the config
    registry ([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)). It walks
    the module folders of the loaded code root (Get-CatzcModulesRoot) — the source tree or a built package — and
    lists every issue:

    - a shipped configs/<name>.yml with no `type:` entry in configs.yml;
    - a configs.yml entry that names no shipped config;
    - a configs.yml type that does not resolve;
    - a shipped config that does not load through Get-Config (its type rejects it).

    A config several modules ship (glossary) is loaded once per owner, with -Module.
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-shipped-configs/ (Write-QualityGateReport).
.PARAMETER PassThru
    Return the result ({ Subject; IssueCount; Issues; ReportPath; Configs; Types }) instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ShippedConfigs
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
