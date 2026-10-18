# pwsh/Catzc.Base.Timeouts/tests/types/BoundedCommand.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:cases = @(Get-EngineCaseTable (Join-Path $PSScriptRoot...`, written with `#`.

```text
Every case, every engine, from the per-engine fixture table: a case that does not apply to an engine says why
there ("n/a: <reason>"), so pwsh/bash/zsh parity reads side by side in one file.
```
