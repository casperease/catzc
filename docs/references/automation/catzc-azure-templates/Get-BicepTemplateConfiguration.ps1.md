---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "72ec41ba4f0b"
---

# automation/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$configName = Get-BicepConfigName $Environment $Slot`, written with `#`.

```text
One config file per (customer?, env, slot): the coordinate is the file address — root for the
shared platform, configuration/<customer>/ for a customer deployment.
```
