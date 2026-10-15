---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md
    kind: test-asset
    body_sha: d5e82a063158
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-FolderConventions' -Tag 'L0', 'logic' {`.

```text
Test-FolderConventions over fixture module trees in $TestDrive: the repository root is mocked, so each test builds
the folders it needs and pins one convention. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
