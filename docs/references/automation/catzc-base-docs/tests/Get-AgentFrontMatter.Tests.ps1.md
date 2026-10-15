---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md
    kind: test-asset
    body_sha: d6598c88603f
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#1
---

# automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AgentFrontMatter' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#1' {`.

```text
Get-AgentFrontMatter over fixture agent files in $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
