---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
    kind: comment-page
    body_sha: "897fa2971cdc"
---

# automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$pathFilters = Get-BuildValidationPathFilter -GlobSet $set`.

```text
The server-side pre-commit trigger filters on the globset's native path projection
(Get-BuildValidationPathFilter -> Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) — the same globs the pipeline
triggers on — never a committed marker.
```
