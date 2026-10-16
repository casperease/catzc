---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Register-AdoBuildValidation.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "50c174fff6f9"
---

# automation/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pathFilters = Get-BuildValidationPathFilter -GlobSet $set`, written with `#`.

```text
The server-side pre-commit trigger filters on the globset's native path projection
(Get-BuildValidationPathFilter -> Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)) — the same globs the pipeline
triggers on — never a committed marker.
```
