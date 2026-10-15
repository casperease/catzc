---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md
    kind: test-asset
    body_sha: "8bd6b46214d4"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-CatsRuleEnforcers' -Tag 'L0', 'logic' {`.

```text
Get-CatsRuleEnforcers over a fixture test tree in $TestDrive and a mocked analyzer map: the AST reader credits
only -Tag citations, never a citation-shaped string elsewhere. The repository facts behind it (every cited id is a
real rule) are quality gates of their own. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
