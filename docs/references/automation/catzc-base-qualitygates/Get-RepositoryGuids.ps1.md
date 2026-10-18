# automation/Catzc.Base.QualityGates/Get-RepositoryGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$text = [System.IO.File]::ReadAllText($fullPath)`, written with `#`.

```text
Read the whole file and match once, rather than regex-per-line: a single scan over the text is
~3x faster than N per-line Matches calls (the per-line managed/native transitions dominated).
Line numbers are recovered from each match's offset — matches arrive in ascending index order, so
one forward cursor counts the newlines between consecutive matches, touching each char at most once.
```
