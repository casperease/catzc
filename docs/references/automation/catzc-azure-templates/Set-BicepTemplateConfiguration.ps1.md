---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
    kind: comment-page
    body_sha: "1109e47eb65d"
---

# automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:7

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:8

Above `$loc = if ([string]::IsNullOrEmpty($Customer)) {`.

```text
The coordinate must conform to the conventional tree (the same cross-layer rule discovery
enforces): the customer subfolder is a defined customer key, and the (customer?, env) coordinate
resolves to exactly one subscription.
```
