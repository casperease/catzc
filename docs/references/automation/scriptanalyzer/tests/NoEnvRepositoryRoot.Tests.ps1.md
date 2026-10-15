---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoEnvRepositoryRoot.Tests.ps1.md
    kind: comment-page
    body_sha: "0e88f38d96c5"
    adrs:
      - ADR-AUTO-NOPWD#6
---

# automation/.scriptanalyzer/tests/NoEnvRepositoryRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoEnvRepositoryRoot' -Tag 'L0', 'logic', 'ADR-AUTO-NOPWD#6' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. Its scope is decided by the file path, so each case writes a fixture file into $TestDrive under
a fake automation/ layout and parses it from there. The engine-wiring proof lives once, for all custom rules, in
CustomRuleWiring.Tests.ps1.
```
