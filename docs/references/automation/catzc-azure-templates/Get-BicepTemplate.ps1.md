---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepTemplate.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-bicep-template-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e121ef42d80b
---

# automation/Catzc.Azure.Templates/Get-BicepTemplate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$template = (Get-BicepTemplates) | Where-Object { $_.name -eq $Name } |...`, written with `#`.

```text
Parenthesise the call so its (comma-wrapped, array-preserving) output is collected and then
enumerated element-by-element into Where-Object. A bare `Get-BicepTemplates | Where-Object`
feeds the whole array as a single pipeline object, which silently matches via member
enumeration and returns every template (latent until a second template exists).
```
