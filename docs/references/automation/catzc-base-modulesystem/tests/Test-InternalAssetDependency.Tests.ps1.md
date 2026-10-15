---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-InternalAssetDependency.Tests.ps1.md
    kind: test-asset
    body_sha: "5ed0c74b3932"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-InternalAssetDependency' -Tag 'L0', 'logic' {`.

```text
Test-InternalAssetDependency over a mocked inventory: the violation and coverage engines have their own tests, so
this pins how the gate turns their records into issues. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
