---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md
    kind: test-asset
    body_sha: "5999da6af91d"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#3
---

# automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ClaudeMdAgentNames' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#3' {`.

```text
Get-ClaudeMdAgentNames over fixture CLAUDE.md files in $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
