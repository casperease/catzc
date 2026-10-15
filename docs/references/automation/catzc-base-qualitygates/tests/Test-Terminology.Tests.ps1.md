---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Terminology.Tests.ps1.md
    kind: test-asset
    body_sha: c11029b33b7c
---

# automation/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.QualityGates {`.

```text
Default happy path: config loads, dictionary is current, every term is referenced. Both mocks return the
production shapes — the typed registry record and Build-TerminologyDictionary's per-category rows.
```
