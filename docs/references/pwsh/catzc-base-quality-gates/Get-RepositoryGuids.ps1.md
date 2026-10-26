# pwsh/Base.QualityGates/Get-RepositoryGuids.ps1

The scanner behind the quality gate for managed GUIDs: it reads the tracked text files and returns one record per GUID literal it finds.

## help

### synopsis

Scans every tracked text file for GUID literals and returns one record per occurrence.

### description

The repository-wide managed-GUID scanner. It reads the tracked-file universe (Get-GuidScanFiles) and matches the canonical hyphenated GUID
form only — deliberately never bare 32-hex, which would false-positive on hashes (the durable SHAs are 64 hex and unhyphenated, so they
never match). Paths come back repo-relative (communication form); guids come back lowercase. The managed-guid quality gate
(Test-ManagedGuids) asserts every returned guid against the registry (configs/guids.yml), and every registry entry against these results.

### outputs

One ordered dictionary per occurrence: @{ file; line; guid }.

### example 1

```powershell
Get-RepositoryGuids | Where-Object { -not (Test-ManagedGuid $_.guid) }
Lists every unregistered GUID occurrence in the repository.
```

## One scan per file

The command reads the whole file and matches once, instead of matching per line. One scan over the text is about 3 times faster than many
per-line `Match` calls, whose managed and native transitions dominated. Line numbers are recovered from each match's offset: matches arrive
in ascending order, so one forward cursor counts the newlines between consecutive matches and touches each character at most once. A tracked
file that is missing on disk, such as an unstaged deletion, has nothing to scan.
