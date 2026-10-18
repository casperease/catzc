# pwsh/Catzc.Base.QualityGates/Test-ManagedGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every guid in tracked text is registered in guids.yml, none is denied, and every entry is live.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the managed guids
([ADR-AUTO-GUIDS](../../../adr/automation/managed-guids.md)): it scans the tracked text (Get-RepositoryGuids over Get-GuidScanFiles) against
the registry (configs/guids.yml) and collects an issue for:

- a scanned file, or the registry itself, outside the 'repository' globset — the protection identity of the scan must cover everything it
  reads ([ADR-REPO-PROTGLOB-INCLUDESOWNCONFIG](../../../adr/repository/protected-globs.md#rule-adr-repo-protglob-includesownconfig));
- a denied guid (guids.yml `denied:`) in tracked text — never a legitimate identity; construct it at runtime (e.g. `[guid]::Empty`) instead;
- an unregistered guid in tracked text — mint a readable placeholder with ConvertTo-Guid, or remove it;
- a registry entry no tracked file references — dead vocabulary to remove.

The value checks over one guid stay Test-ManagedGuid / Assert-ManagedGuid; this gate is the repository-wide check. It reads the tracked
files, which exist only in the source tree (Get-GuidScanFiles).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-managed-guids/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Registered; Occurrences }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-ManagedGuids
```
