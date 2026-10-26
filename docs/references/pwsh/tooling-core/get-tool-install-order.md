# pwsh/Tooling.Core/Get-ToolInstallOrder.ps1

The sorter that puts the tools of `tools.yml` in dependency-safe install order, dependencies first, and throws on a cycle.

## help

### synopsis

Returns tool names from tools.yml in dependency-safe install order.

### description

Performs a topological sort based on DependsOn fields. Tools with no dependencies come first, tools that depend on others come after their
dependencies. Throws on circular dependencies.

### example 1

```powershell
Get-ToolInstallOrder
# Returns @('python', 'java', 'dotnet', 'node_js', 'terraform', 'poetry', 'az_cli', 'py_spark')
```

## Algorithm

The sort is Kahn's algorithm. If A depends on B, B must be installed first, so the edge runs B to A. A tool's in-degree is the number of
edges pointing at it, which is the count of its own `depends_on` entries, and a tool with no dependencies starts in the ready queue.

## Optional depends_on

`depends_on` is optional. The code indexes it, since a dotted read of an absent key throws under strict mode, and keeps the value an array,
since an `if` expression would unroll a one-item list to a scalar.
