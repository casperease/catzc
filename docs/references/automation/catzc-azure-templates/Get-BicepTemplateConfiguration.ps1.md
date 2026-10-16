---
catzc:
  immutable:
    with_body_sha: "72ec41ba4f0b"
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplateConfiguration.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-bicep-template-configuration-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
