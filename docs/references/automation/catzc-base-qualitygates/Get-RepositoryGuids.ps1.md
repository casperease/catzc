---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Get-RepositoryGuids.ps1.md
    kind: comment-page
    body_sha: e6ec85f98074
    adrs: []
---

# automation/Catzc.Base.QualityGates/Get-RepositoryGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The repository-wide managed-GUID scanner. It reads the tracked-file universe (Get-GuidScanFiles) and
matches the canonical hyphenated GUID form only — deliberately never bare 32-hex, which would
false-positive on hashes (the durable SHAs are 64 hex and unhyphenated, so they never match). Paths
come back repo-relative (communication form); guids come back lowercase. The managed-guid quality
gate (Test-ManagedGuids) asserts every returned guid against the registry (configs/guids.yml), and every
registry entry against these results.
```

## comment:2

Above `$text = [System.IO.File]::ReadAllText($fullPath)`.

```text
Read the whole file and match once, rather than regex-per-line: a single scan over the text is
~3x faster than N per-line Matches calls (the per-line managed/native transitions dominated).
Line numbers are recovered from each match's offset — matches arrive in ascending index order, so
one forward cursor counts the newlines between consecutive matches, touching each char at most once.
```
