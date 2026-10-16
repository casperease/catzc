---
catzc:
  immutable:
    with_body_sha: "7dd941bf5171"
    path: docs/references/automation/catzc-base-engines/tests/types/ExecutionEngine.Tests.ps1.md
    folder: docs/references/automation/catzc-base-engines/tests/types
    name: execution-engine-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Engines/tests/types/ExecutionEngine.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeDiscovery {`, written with `#`.

```text
The execution engine model against its per-engine fixture tables (Get-EngineCaseTable): every case is checked under
every engine, side by side, so a behaviour that differs between pwsh, bash and zsh differs on purpose
([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)).
```
