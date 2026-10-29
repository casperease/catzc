# pwsh/Azure.Templates/tests/Locks.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `@($locks | Where-Object Path -NotLike '*/lock-virtual-network/*').Count |...`, written with `#`.

```text
A zone's name is an environment() suffix the evaluator leaves unresolved, so its lock is counted, not found by name: every lock
but the network's is a zone's, one per zone the evaluator reports.
```

## comment:2

Above `if ($script:bicepReady) {`, written with `#`.

```text
Each template builds once for the file, so its compile is shared by every It below
([ADR-AUTO-TEST-SETUPONCE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-setuponce)).
```
