---
catzc:
  immutable:
    with_body_sha: "58feae1a33aa"
    path: docs/references/automation/catzc-tooling-core/private/Resolve-SessionToolHost.ps1.md
    folder: docs/references/automation/catzc-tooling-core/private
    name: resolve-session-tool-host-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
