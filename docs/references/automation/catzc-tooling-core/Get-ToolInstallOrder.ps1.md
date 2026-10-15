---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Get-ToolInstallOrder.ps1.md
    kind: comment-page
    body_sha: "98e4a4082168"
---

# automation/Catzc.Tooling.Core/Get-ToolInstallOrder.ps1

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
Kahn's algorithm for install order: if A depends on B, B must be installed first, so the edge runs B → A.
A tool's in-degree is therefore the number of edges pointing at it, which is the count of its own depends_on
entries, and a tool with no dependencies starts in the ready queue.
```

## comment:4

Above `$dependency = $allTools[$name]['depends_on']`.

```text
depends_on is optional: index it (a dotted read of an absent key throws under strict), and keep the
value an array — an if-expression would unroll a one-item list to a scalar
```

## comment:5

Above `$inDegree = @{}`.

```text
Kahn's algorithm for install order: if A depends on B, B must be installed first, so the edge runs B → A.
A tool's in-degree is therefore the number of edges pointing at it, which is the count of its own depends_on
entries, and a tool with no dependencies starts in the ready queue.
```
