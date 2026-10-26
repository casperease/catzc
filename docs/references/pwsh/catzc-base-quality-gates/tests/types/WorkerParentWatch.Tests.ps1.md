# pwsh/Base.QualityGates/tests/types/WorkerParentWatch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:savedPid = $env:CATZC_TEST_PARENT_PID`, written with `#`.

```text
Process-scope only, snapshot and restore
([ADR-PWSH-ENV-NOPESTERISOLATION](/docs/drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-nopesterisolation)): under the harness these hold the real
parent, and only the absent/malformed cases run here — a watch that starts in THIS process would
watch whatever the variables name.
```
