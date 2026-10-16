<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
    adrs:
      - ADR-AUTO-GUIDS
      - ADR-AUTO-TEST#35
      - ADR-REPO-PROTGLOB#6
  config:
    synopsis: 'Quality gate: every guid in tracked text is registered in guids.yml, none is denied, and every entry is live.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the managed
      guids ([ADR-AUTO-GUIDS](/docs/adr/automation/managed-guids.md)): it scans the tracked text (Get-RepositoryGuids over
      Get-GuidScanFiles) against the registry (configs/guids.yml) and collects an issue for:

        - a scanned file, or the registry itself, outside the 'repository' globset — the protection identity of the
          scan must cover everything it reads
          ([ADR-REPO-PROTGLOB#6](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob6));
        - a denied guid (guids.yml `denied:`) in tracked text — never a legitimate identity; construct it at runtime
          (e.g. [guid]::Empty) instead;
        - an unregistered guid in tracked text — mint a readable placeholder with ConvertTo-Guid, or remove it;
        - a registry entry no tracked file references — dead vocabulary to remove.

      The value checks over one guid stay Test-ManagedGuid / Assert-ManagedGuid; this gate is the repository-wide check.
      It reads the tracked files, which exist only in the source tree (Get-GuidScanFiles).
    parameters:
      OutputFolder: The report base folder. Defaults to out/test-managed-guids/ (Write-QualityGateReport).
      PassThru: |-
        Return the result ({ Subject; IssueCount; Issues; ReportPath; Registered; Occurrences }) instead of throwing on
        issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-ManagedGuids
---
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
