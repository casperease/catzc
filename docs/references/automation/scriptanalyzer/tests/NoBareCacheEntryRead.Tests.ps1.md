---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoBareCacheEntryRead.Tests.ps1.md
    kind: test-asset
    body_sha: "32f421e22dea"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/.scriptanalyzer/tests/NoBareCacheEntryRead.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Measure-NoBareCacheEntryRead' -Tag 'L0', 'logic', 'ADR-PWSH-CACHE#4' {`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
