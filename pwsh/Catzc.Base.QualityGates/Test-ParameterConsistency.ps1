<#
---
catzc:
  immutable:
    with_body_sha: "3695846ef872"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
    docs: "[Test-ParameterConsistency.ps1.md](docs/references/pwsh/catzc-base-quality-gates/Test-ParameterConsistency.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PWSH-PARAM
---
#>

function Test-ParameterConsistency {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    $config = Get-Config -Config parameter-consistency
    $modulesFolder = Get-CatzcModulesFolder
    $publicFile = '^' + [regex]::Escape($modulesFolder) + '/[^/.][^/]*/[^/]+\.ps1$'
    $files = @(Get-GitTrackedPath $modulesFolder | Where-Object { $_ -match $publicFile } |
            ForEach-Object { Join-Path $repositoryRoot $_ })

    $issues = [System.Collections.Generic.List[string]]::new()
    $conflicting = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($conflict in @(Get-ParameterTypeConflict -Path $files)) {
        [void]$conflicting.Add($conflict.Name)
        if ($config.IsExempt($conflict.Name)) {
            continue
        }
        $types = ($conflict.Types | ForEach-Object { "[$($_.Type)] in $($_.Functions -join ', ')" }) -join '; '
        $issues.Add("-$($conflict.Name): one name, more than one type — $types. Give it one type, or exempt it in parameter-consistency.yml with the reason")
    }
    foreach ($name in @($config.exempt.Keys | Sort-Object)) {
        if (-not $conflicting.Contains($name)) {
            $issues.Add("$(ConvertTo-RepoRelativePath (Get-CatzcModuleRoot 'configs/parameter-consistency.yml')): -$name is exempt but no longer conflicts — remove the entry")
        }
    }

    Write-QualityGateReport -Subject parameter-consistency -Title Test-ParameterConsistency -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Functions = $files.Count; Exempt = $config.exempt.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
