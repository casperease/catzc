---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Sync-AdoBuildValidations.ps1.md
    kind: comment-page
    body_sha: c38a92d5a1f0
    adrs: []
---

# automation/Catzc.Azure.DevOps.BuildValidation/Sync-AdoBuildValidations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The config-driven reconcile: for each entry under 'validations' in build-validation.yml, runs
Register-AdoBuildValidation — creating missing policies, updating drifted ones, and leaving current
ones alone — and emits each result. This is the everything-as-code path for the server-side policies:
the local config is the source of truth, and this function converges the ADO project to it.
```
