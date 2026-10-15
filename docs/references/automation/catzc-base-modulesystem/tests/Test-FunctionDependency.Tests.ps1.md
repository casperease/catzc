---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-FunctionDependency.Tests.ps1.md
    kind: test-asset
    body_sha: db183d6bf865
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-FunctionDependency' -Tag 'L1', 'integrity', 'source-only' {`.

```text
The integrity invariant — the real repository's function dependency graph is satisfied — needs exactly one
scan of the real automation tree. The gate's uniform shape
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) is pure logic, so it is proven at
L0 against fixture roots rather than by a second full-tree scan.
```
