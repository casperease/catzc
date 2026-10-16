---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHost.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "58feae1a33aa"
---

# automation/Catzc.Tooling.Core/private/Resolve-SessionToolHost.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Get-Command $Config.command -CommandType Application -ErrorAction Ignore |...`, written with `#`.

```text
-First 1: the command may still resolve in more than one PATH dir — an array's .Source would break the
[string] -Location binding downstream.
```
