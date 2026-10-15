---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureBicepDeploymentModes.ps1.md
    kind: comment-page
    body_sha: c499dc4ec9cb
---

# automation/Catzc.Azure.Templates/Get-AzureBicepDeploymentModes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
'Incremental' (default) — additive update; existing resources outside the template are preserved.
'Complete'              — destructive sync; resources in the target scope but not in the template are deleted.
'DoNotRun'              — pseudo-mode meaning the template is intentionally skipped (gate-checked by callers).
```
