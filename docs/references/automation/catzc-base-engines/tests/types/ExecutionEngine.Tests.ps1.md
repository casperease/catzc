---
catzc:
  derived:
    path: docs/references/automation/catzc-base-engines/tests/types/ExecutionEngine.Tests.ps1.md
    kind: test-asset
    body_sha: "3ef58e7dc971"
---

# automation/Catzc.Base.Engines/tests/types/ExecutionEngine.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeDiscovery {`.

```text
The execution engine model against its per-engine fixture tables (Get-EngineCaseTable): every case is checked under
every engine, side by side, so a behaviour that differs between pwsh, bash and zsh differs on purpose
([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)).
```
