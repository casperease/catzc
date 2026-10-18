# pwsh/Catzc.Tooling.Github/tests/Test-GitHistoryClean.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:repo = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-ghtest-' +...`, written with `#`.

```text
A throwaway git repo whose history plants the token on all three surfaces:
a blob (file content), a path (file name), and a commit message.
```
