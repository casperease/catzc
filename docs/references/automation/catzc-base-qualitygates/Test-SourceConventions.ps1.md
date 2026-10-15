---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-SourceConventions.ps1.md
    kind: comment-page
    body_sha: "355d05734660"
---

# automation/Catzc.Base.QualityGates/Test-SourceConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$typesTestDirectory = Join-Path $testsDirectory 'types'`.

```text
tests/types/ holds the native-type tests, named for their type (which has no verb) — so each must name a
real types/*.cs of the module, and the folder cannot collect misplaced or misnamed tests.
```
