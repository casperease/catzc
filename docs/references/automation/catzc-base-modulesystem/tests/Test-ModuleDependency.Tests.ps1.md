---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-ModuleDependency.Tests.ps1.md
    kind: test-asset
    body_sha: "708f047232f6"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1

<!-- cspell:ignore tpols -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ModuleDependency' {`.

```text
Test-ModuleDependency is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case runs it with
-PassThru over mocked boundaries and reads the collected issues; the report goes to $TestDrive.
```
