<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-GUIDS
      - ADR-AUTO-TEST#35
      - ADR-REPO-PROTGLOB#6
---
#>

<#
.SYNOPSIS
    Quality gate: every guid in tracked text is registered in guids.yml, none is denied, and every entry is live.
.DESCRIPTION
    Scanned files and the registry must lie in the repository globset, so the scan's protection identity covers them.
    [ADR-AUTO-GUIDS](/docs/adr/automation/managed-guids.md),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-REPO-PROTGLOB#6](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob6)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-ManagedGuids.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to out/test-managed-guids/ (Write-QualityGateReport).
.PARAMETER PassThru
    Registered and Occurrences let a caller assert on the registry and the scan without parsing the report.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-ManagedGuids.ps1.md#comment2)
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-ManagedGuids
#>
function Test-ManagedGuids {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $issues = [System.Collections.Generic.List[string]]::new()

    $registryFile = 'automation/Catzc.Base.QualityGates/configs/guids.yml'
    $members = [System.Collections.Generic.HashSet[string]]::new([string[]]@(Get-GlobSetFile -Name 'repository'), [System.StringComparer]::Ordinal)
    foreach ($file in (@(Get-GuidScanFiles) + $registryFile)) {
        if (-not $members.Contains($file)) {
            $issues.Add("${file}: read by the guid scan but outside the 'repository' globset (globs.yml) — its protection identity must cover it")
        }
    }

    $config = Get-Config -Config guids
    $registered = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in @($config.guids.Keys)) {
        [void]$registered.Add("$($config.guids[$name].guid)")
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
            $issues.Add("$($record.file):$($record.line) $($record.guid): not registered in guids.yml — mint a readable placeholder with ConvertTo-Guid, or remove it")
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
