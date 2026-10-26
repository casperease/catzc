# pwsh/Base.ModuleSystem/Get-ModuleDependency.ps1

Collapses the function-level call graph of `Get-FunctionDependency` into unique module-to-module edges, each with its call count and the
functions involved. These are the actual edges that `Test-ModuleDependency` compares with the declared graph.

## help

### synopsis

Compiles a module-level dependency edge map from function-level dependencies.

### description

Takes the output of Get-FunctionDependency and collapses it into unique module-to-module edges with call counts and the functions involved.

### parameter `Dependency`

Function dependency objects from Get-FunctionDependency. Accepts pipeline input.

### example 1

```powershell
Get-FunctionDependency | Get-ModuleDependency
```

### example 2

```powershell
Get-FunctionDependency | Get-ModuleDependency | Where-Object { $_.From -eq 'Catzc.Tooling.Core' }
```
