---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/FunctionCall.cs.md
    kind: comment-page
    body_sha: "5ba04fecab56"
    adrs: []
    links: []
---

# automation/Catzc.Base.ModuleSystem/types/FunctionCall.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One statically named command call inside a function body: the command name as written and the line it starts on.
Collected by FunctionCallCollector for Test-FunctionDependency.

BCL only; declares its module namespace (file-scoped), per the type loader. PascalCase (a result shape).
```
