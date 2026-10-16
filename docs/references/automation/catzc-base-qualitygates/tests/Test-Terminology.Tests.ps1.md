---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Terminology.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "745282c098fe"
---

# automation/Catzc.Base.QualityGates/tests/Test-Terminology.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-Config -ModuleName Catzc.Base.QualityGates {`, written with `#`.

```text
Default happy path: config loads, dictionary is current, every term is referenced. Both mocks return the
production shapes — the typed registry record and Build-TerminologyDictionary's per-category rows.
```
