# pwsh/Catzc.Base.Execution/private/Test-RealProcessBlocked.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pester = Get-Module Pester`, written with `#`.

```text
Armed per container: only the L0 and L1 Describes of a run forbid a real process. Pester's own current block says where the
call comes from; outside any Describe (a script's top level, a stray module call) nothing is armed.
```
