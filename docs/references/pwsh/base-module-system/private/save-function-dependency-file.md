# pwsh/Base.ModuleSystem/private/Save-FunctionDependencyFile.ps1

Writes the cross-session result file of the function call graph atomically, so a reader never sees a half-written file.

## help

### synopsis

Writes the call graph rows and their stamp to the result file.

### description

Writes to a `.tmp` file beside the target and moves it over the target. A write that fails on an IO or access error is skipped with a
message, since losing the file costs one parse.

### parameter `Path`

The result file.

### parameter `Stamp`

The content stamp of the scripts the rows were built from.

### parameter `Edge`

The call graph rows.

### example 1

```powershell
Save-FunctionDependencyFile -Path $cachePath -Stamp $stamp -Edge $rows
```
