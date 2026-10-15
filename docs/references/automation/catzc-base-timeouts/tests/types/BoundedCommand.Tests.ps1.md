---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/tests/types/BoundedCommand.Tests.ps1.md
    kind: test-asset
    body_sha: cef4080f2be9
---

# automation/Catzc.Base.Timeouts/tests/types/BoundedCommand.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:cases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot...`.

```text
Every case, every engine, from the per-engine fixture table: a case that does not apply to an engine says why
there ("n/a: <reason>"), so pwsh/bash/zsh parity reads side by side in one file.
```
