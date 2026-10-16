---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/FunctionCall.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "419ea8ddb7b7"
---

# automation/Catzc.Base.ModuleSystem/types/FunctionCall.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One statically named command call inside a function body: the command name as written and the line it starts on.
Collected by FunctionCallCollector for Test-FunctionDependency.

BCL only; declares its module namespace (file-scoped), per the type loader. PascalCase (a result shape).
```
