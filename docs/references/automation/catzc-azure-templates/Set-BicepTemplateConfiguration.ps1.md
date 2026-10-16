---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Set-BicepTemplateConfiguration.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: set-bicep-template-configuration-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "380db38499d3"
---

# automation/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStat...`, written with `#`.

```text
State-changing function deliberately uses -DryRun, not ShouldProcess — see
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:2

Above `$loc = if ([string]::IsNullOrEmpty($Customer)) {`, written with `#`.

```text
The coordinate must conform to the conventional tree (the same cross-layer rule discovery
enforces): the customer subfolder is a defined customer key, and the (customer?, env) coordinate
resolves to exactly one subscription.
```
