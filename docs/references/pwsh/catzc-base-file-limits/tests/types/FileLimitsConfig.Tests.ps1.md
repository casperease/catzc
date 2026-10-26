# pwsh/Base.FileLimits/tests/types/FileLimitsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'FileLimitsConfig'`, written with `#`.

```text
The type is the only place a file-limits default lives, and its bounds are asserted on construction so a wrong number
never reaches a gate.
```
