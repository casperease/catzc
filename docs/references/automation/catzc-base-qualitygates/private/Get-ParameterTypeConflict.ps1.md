---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ParameterTypeConflict.ps1.md
    kind: comment-page
    body_sha: "2f787f7d9b2e"
---

# automation/Catzc.Base.QualityGates/private/Get-ParameterTypeConflict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The logic behind Test-ParameterConsistency: parses each file, reads every function's declared parameters, and groups
them by name (case-insensitively). Two declarations agree when their element types agree — [string] and [string[]]
are one type at two cardinalities, and a type is resolved through .NET where it is loaded, so an accelerator and its
full name are one type ([bool] is [System.Boolean]); an untyped parameter and one typed [object] or [psobject]
accept anything, so they never conflict. A name whose typed declarations have
more than one element type is one conflict.
```

## comment:2

Above `$reflected = $constraint.TypeName.GetReflectionType()`.

```text
Resolve through .NET where the type is loaded, so an accelerator and its full name are one type
([bool] is [System.Boolean]); a type that does not resolve keeps its written name.
```

## comment:3

Above `$reflected = $constraint.TypeName.GetReflectionType()`.

```text
Resolve through .NET where the type is loaded, so an accelerator and its full name are one type
([bool] is [System.Boolean]); a type that does not resolve keeps its written name.
```
