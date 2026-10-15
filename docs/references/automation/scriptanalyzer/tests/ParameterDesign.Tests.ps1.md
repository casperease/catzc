---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/ParameterDesign.Tests.ps1.md
    kind: test-asset
    body_sha: d575a2a4a9d7
---

# automation/.scriptanalyzer/tests/ParameterDesign.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The per-case assertions run the rule functions directly on a parsed AST (L0). Their scope is decided by the file path,
so each case writes a fixture file into $TestDrive under a fake automation/ layout. The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
