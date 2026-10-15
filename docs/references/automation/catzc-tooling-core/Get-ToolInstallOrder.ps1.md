# docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md

`automation/Catzc.Tooling.Core/Get-ToolInstallOrder.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Performs a topological sort based on DependsOn fields. Tools with no
dependencies come first, tools that depend on others come after their
dependencies. Throws on circular dependencies.
```

## comment:2

Above `$dependency = $allTools[$name]['depends_on']`.

```text
depends_on is optional: index it (a dotted read of an absent key throws under strict), and keep the
value an array — an if-expression would unroll a one-item list to a scalar
```

## comment:3

Above `$inDegree = @{}`.

```text
Wait — in-degree is wrong above. In-degree for a node = number of edges pointing TO it.
DependsOn means "I depend on X" = edge from X to me. So in-degree of me = count of my DependsOn.
Actually no: in Kahn's for install order, we want: if A depends on B, B must come first.
So edge is B → A (B must be installed before A). In-degree of A = number of dependencies A has.
```
