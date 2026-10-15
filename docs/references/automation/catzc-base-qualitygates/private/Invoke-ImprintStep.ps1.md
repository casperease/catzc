---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md
    kind: comment-page
    body_sha: a9ce7c17df6a
---

# automation/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `switch -CaseSensitive ($Step) {`.

```text
Each case first returns for an empty list, so a run with no files still proves the step has its adapter, and an empty list
never reaches a command whose default is the whole repository.
```
