---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-FunctionDependencyTree.ps1.md
    kind: reference
    body_sha: b8b635c34878
    adrs: []
---

# automation/Catzc.Base.ModuleSystem/Get-FunctionDependencyTree.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Takes a function name and walks the call graph produced by Get-FunctionDependency
using breadth-first search. Returns every function reachable from the root, with
the depth at which it was first encountered and the caller that introduced it.

Accepts pipeline input from Get-FunctionDependency. If no pipeline input is
provided, calls Get-FunctionDependency automatically.
```
