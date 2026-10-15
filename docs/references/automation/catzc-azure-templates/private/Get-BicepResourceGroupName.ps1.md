---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepResourceGroupName.ps1.md
    kind: comment-page
    body_sha: ebe6c10983b2
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepResourceGroupName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Convenience over Get-BicepResourceName for the resource-group type — the single source of the RG
name for both Get-BicepDeploymentContext (the deploy target) and Set-BicepTrackingTagSet (the tag
scope), so the two never drift. The resource-group name is derived from the naming standard, never
hand-typed in config (one config file ⟷ one resource group).
```
