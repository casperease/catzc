# automation/Catzc.Base.QualityGates/private/Get-ParameterTypeConflict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Finds the parameter names that carry more than one type across the given function files.

### description

The logic behind Test-ParameterConsistency: parses each file, reads every function's declared parameters, and groups them by name
(case-insensitively). Two declarations agree when their element types agree — `[string]` and `[string[]]` are one type at two cardinalities,
and a type is resolved through .NET where it is loaded, so an accelerator and its full name are one type (`[bool]` is `[System.Boolean]`);
an untyped parameter and one typed `[object]` or `[psobject]` accept anything, so they never conflict. A name whose typed declarations have
more than one element type is one conflict.

### parameter `Path`

The .ps1 files to read (absolute paths).

### outputs

`[pscustomobject]` { Name; Types } per conflicting name, by name — Types one { Type; Functions } per element type, by type, Functions the
declaring functions sorted ordinally.

### example 1

```powershell
Get-ParameterTypeConflict -Path (Get-ChildPath automation/Catzc.Widget -File -Filter '*.ps1' -Depth 1)
```

## comment:1

Above `$reflected = $constraint.TypeName.GetReflectionType()`, written with `#`.

```text
Resolve through .NET where the type is loaded, so an accelerator and its full name are one type
([bool] is [System.Boolean]); a type that does not resolve keeps its written name.
```
