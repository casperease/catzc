---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ManagedGuids.ps1.md
    kind: reference
    body_sha: bc0680df2d84
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-PROTGLOB#6
---

# automation/Catzc.Base.QualityGates/Test-ManagedGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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
```

## comment:2

Section `.PARAMETER PassThru` of the comment-based help.

```text
Return the result ({ Subject; IssueCount; Issues; ReportPath; Registered; Occurrences }) instead of throwing on
issues.
```
