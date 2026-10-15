<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PWSH-PARAM
---
#>

<#
.SYNOPSIS
    Quality gate: one parameter name means one type across the public functions.
.DESCRIPTION
    An exempt name that no longer conflicts is itself reported, so the exempt list holds only what is real.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-ParameterConsistency.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-parameter-consistency).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Functions; Exempt } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ParameterConsistency
.EXAMPLE
    (Test-ParameterConsistency -PassThru).Issues
#>
function Test-ParameterConsistency {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree
    $repositoryRoot = Get-RepositoryRoot
    $config = Get-Config -Config parameter-consistency
    $files = @(Get-GitTrackedPath 'automation' | Where-Object { $_ -match '^automation/[^/.][^/]*/[^/]+\.ps1$' } |
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
            $issues.Add("automation/Catzc.Base.QualityGates/configs/parameter-consistency.yml: -$name is exempt but no longer conflicts — remove the entry")
        }
    }

    Write-QualityGateReport -Subject parameter-consistency -Title Test-ParameterConsistency -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Functions = $files.Count; Exempt = $config.exempt.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
