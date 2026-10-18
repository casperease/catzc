# pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-FunctionDependency' -Tag 'L1', 'integrity', 'source-only' {`, written with `#`.

```text
The integrity invariant — the real repository's function dependency graph is satisfied — needs exactly one
scan of the real pwsh/ tree. The gate's uniform shape
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) is pure logic, so it is proven at
L0 against fixture roots rather than by a second full-tree scan.
```
