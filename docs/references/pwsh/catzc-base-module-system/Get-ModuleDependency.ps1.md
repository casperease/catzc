# pwsh/Base.ModuleSystem/Get-ModuleDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
