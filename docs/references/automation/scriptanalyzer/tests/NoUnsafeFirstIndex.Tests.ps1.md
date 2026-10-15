---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1.md
    kind: test-asset
    body_sha: "685e5fad453b"
    adrs:
      - ADR-PWSH-ERROR#8
---

# automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Measure-NoUnsafeFirstIndex' -Tag 'L0', 'logic', 'ADR-PWSH-ERROR#8' {`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
