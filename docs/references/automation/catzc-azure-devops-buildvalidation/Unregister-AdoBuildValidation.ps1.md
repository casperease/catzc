---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Unregister-AdoBuildValidation.ps1.md
    kind: comment-page
    body_sha: "00df666feb77"
    adrs:
      - ADR-AUTO-IDEM#2
    links: []
---

# automation/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Finds the build-validation policy whose path filter is the globset's native projection
(Get-GlobSetTrigger, [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md) — the tie between policy and globset)
on the guarded branch and deletes
it. When no such policy exists the function reports and returns without error
([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)).
```
