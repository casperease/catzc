---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ParameterTypeConflict.ps1.md
    kind: comment-page
    body_sha: bed8f5e21547
---

# automation/Catzc.Base.QualityGates/private/Get-ParameterTypeConflict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$reflected = $constraint.TypeName.GetReflectionType()`.

```text
Resolve through .NET where the type is loaded, so an accelerator and its full name are one type
([bool] is [System.Boolean]); a type that does not resolve keeps its written name.
```
