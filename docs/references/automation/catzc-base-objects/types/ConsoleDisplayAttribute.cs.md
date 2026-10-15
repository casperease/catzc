---
catzc:
  derived:
    path: docs/references/automation/catzc-base-objects/types/ConsoleDisplayAttribute.cs.md
    kind: reference
    body_sha: "877dafa3feb9"
    adrs: []
---

# automation/Catzc.Base.Objects/types/ConsoleDisplayAttribute.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Names the identity properties of the type it decorates: the few that tell one instance from another at a
glance. One declaration drives both console surfaces of a catzc object held in pwsh:

  1. its text — ConsoleText.ToConsoleString renders only these properties, so "$x", [string]$x, -join and
     a nested table cell read `SubscriptionContext { Id = 1f2e…, Name = Contoso Prod }`;
  2. its prompt display — Import-CSharpTypes registers them as the type's DefaultDisplayPropertySet, so
     typing `$x` (or a command returning one) shows these columns instead of every property.

Without the attribute both surfaces show every public property. The names are checked when the type is
rendered: an unknown name throws, naming the type and the property. BCL only; declares its module
namespace (file-scoped), per the type loader.
```
