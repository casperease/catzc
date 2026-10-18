# automation/Catzc.Base.Environment/tests/Sync-SessionPath.Tests.ps1

<!-- cspell:ignore machinebin userbin -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:regUser = ''`, written with `#`.

```text
The persistent PATH is read through the Get-EnvironmentPath seam — mock it so these tests are
deterministic and never read the real machine registry. Each test sets $script:regUser/$regMachine.
```
