---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-ModuleCycles.Tests.ps1.md
    kind: test-asset
    body_sha: "84718b57efc2"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ModuleCycles' -Tag 'L0', 'logic' {`.

```text
Test-ModuleCycles over a mocked call graph (Get-ModuleDependency). Neutral fixture module names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
