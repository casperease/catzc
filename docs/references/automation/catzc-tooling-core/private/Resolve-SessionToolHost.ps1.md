---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHost.ps1.md
    kind: comment-page
    body_sha: d2e3aefb58ed
---

# automation/Catzc.Tooling.Core/private/Resolve-SessionToolHost.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `Get-Command $Config.command -CommandType Application -ErrorAction Ignore |...`.

```text
-First 1: the command may still resolve in more than one PATH dir — an array's .Source would break the
[string] -Location binding downstream.
```
