# automation/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'TimeoutSeconds defaults come from the time safeguard' -Tag 'L1',...`, written with `#`.

```text
A function bounds its own long-running work through Get-TimeoutSeconds -Command and its [TimeLimit] decoration, never
a number literal as the parameter default
([ADR-PWSH-ASSERT#1](/docs/adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert1)). Reads the shipped .ps1
files by AST, so it runs in the source and the build run alike.
```
