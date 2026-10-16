---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "9c47b033b392"
---

# automation/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `switch -CaseSensitive ($Step) {`, written with `#`.

```text
Each case first returns for an empty list, so a run with no files still proves the step has its adapter, and an empty list
never reaches a command whose default is the whole repository.
```
