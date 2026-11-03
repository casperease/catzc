# pwsh/Base.ModuleSystem/private/Get-FunctionDependencyCachePath.ps1

The one place that names the cross-session file of the function call graph, so a test points it elsewhere with a single mock.

## help

### synopsis

Returns the path of the function dependency result file under the output root.

### description

The path is `cache/function-dependency.json` below `Get-OutputRoot`, a per-machine file that is never committed.

### example 1

```powershell
Get-FunctionDependencyCachePath
```
