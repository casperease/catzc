---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ParameterTypeConflict.ps1.md
    kind: comment-page
    body_sha: "60d42493606b"
---

# automation/Catzc.Base.QualityGates/private/Get-ParameterTypeConflict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$reflected = $constraint.TypeName.GetReflectionType()`, written with `#`.

```text
Resolve through .NET where the type is loaded, so an accelerator and its full name are one type
([bool] is [System.Boolean]); a type that does not resolve keeps its written name.
```
