---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
    kind: comment-page
    body_sha: "7266214c9fb5"
---

# automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$configName = Get-BicepConfigName $Environment $Slot`.

```text
One config file per (customer?, env, slot): the coordinate is the file address — root for the
shared platform, configuration/<customer>/ for a customer deployment.
```
