# pwsh/Base.QualityGates/private/Get-ParameterTypeConflict.ps1

Finds the parameter names that carry more than one type across the given function files. A name with two types is a conflict that a reader
of the commands would trip over.

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
Get-ParameterTypeConflict -Path (Get-ChildPath pwsh/Catzc.Widget -File -Filter '*.ps1' -Depth 1)
```

## Type names

A type is resolved through .NET where it is loaded, so an accelerator and its full name are one type (`[bool]` is `[System.Boolean]`). A
type that does not resolve keeps its written name.
