# automation/Catzc.Base.ModuleSystem/Get-FunctionDependencyTree.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the transitive closure of all functions that a given function depends on.

### description

Takes a function name and walks the call graph produced by Get-FunctionDependency
using breadth-first search. Returns every function reachable from the root, with
the depth at which it was first encountered and the caller that introduced it.

Accepts pipeline input from Get-FunctionDependency. If no pipeline input is
provided, calls Get-FunctionDependency automatically.

### parameter Function

The name of the root function to trace dependencies from.

### parameter Dependency

Function dependency objects from Get-FunctionDependency. Accepts pipeline input.

### example 1

```powershell
Get-FunctionDependencyTree -Function 'Install-Poetry'
```

### example 2

```powershell
Get-FunctionDependency | Get-FunctionDependencyTree -Function 'Get-ModuleDependency'
```
