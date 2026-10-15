---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1.md
    kind: comment-page
    body_sha: "3a60c88cda4f"
    adrs:
      - ADR-PWSH-ERROR#8
---

# automation/.scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoUnsafeFirstIndex' -Tag 'L0', 'logic', 'ADR-PWSH-ERROR#8' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
