---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepParameterModel.ps1.md
    kind: comment-page
    body_sha: "0f083f9a2416"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Templates/Get-BicepParameterModel.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the `parameters` section of the main.json that Build-Bicep writes to the template's output folder
(Get-BicepTemplatesOutputRoot) and returns it as a [Catzc.Azure.Templates.BicepParameterModel]: the template
name plus one [Catzc.Azure.Templates.BicepParameter] per declared parameter, keyed by name.

When the output folder holds no current build, it runs Build-Bicep first, which also renders the
parameters.<config>.json files. A build is current when its main.json is at least as new as every input
Build-Bicep reads from the template folder: the template's *.bicep files, its configuration files, and its
PrePost.psm1. A reusable module under infrastructure/modules/ is not among those inputs, so after editing
only a module run Build-Bicep yourself. The build is the only call to `az`; reading the model is pure over
the JSON.

Get-BicepParameterViolations checks every rendered parameters file against this model.
```
