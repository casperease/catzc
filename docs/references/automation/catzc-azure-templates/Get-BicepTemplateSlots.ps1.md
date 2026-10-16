---
catzc:
  immutable:
    with_body_sha: "40c40b9e5df1"
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplateSlots.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-bicep-template-slots-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/Get-BicepTemplateSlots.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$wantCustomer = [string]$Customer`, written with `#`.

```text
slots are [ordered] dicts -> use the script-block Where-Object/ForEach-Object form (the
`Where-Object prop -EQ` shortcut does not bind ordered-dict keys). Filter by customer — the
configuration axis; empty/unbound = the configuration-root (shared-platform) slots.
```
