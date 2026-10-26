# pwsh/Base.ModuleSystem/Get-FunctionDependencyTree.ps1

Walks the call graph of `Get-FunctionDependency` breadth-first from one function and returns everything it transitively depends on, with the
depth and the caller that introduced each.

## help

### synopsis

Returns the transitive closure of all functions that a given function depends on.

### description

Takes a function name and walks the call graph produced by Get-FunctionDependency using breadth-first search. Returns every function
reachable from the root, with the depth at which it was first encountered and the caller that introduced it.

Accepts pipeline input from Get-FunctionDependency. If no pipeline input is provided, calls Get-FunctionDependency automatically.

### parameter `Function`

The name of the root function to trace dependencies from.

### parameter `Dependency`

Function dependency objects from Get-FunctionDependency. Accepts pipeline input.

### example 1

```powershell
Get-FunctionDependencyTree -Function 'Install-Poetry'
```

### example 2

```powershell
Get-FunctionDependency | Get-FunctionDependencyTree -Function 'Get-ModuleDependency'
```
