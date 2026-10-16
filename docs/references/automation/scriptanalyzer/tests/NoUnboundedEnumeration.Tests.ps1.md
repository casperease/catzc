---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/NoUnboundedEnumeration.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "83e8a7f21018"
---

# automation/.scriptanalyzer/tests/NoUnboundedEnumeration.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoUnboundedEnumeration' -Tag 'L0', 'logic',...`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0) — the rule is pure logic over a
ScriptBlockAst. Its scope is decided by the file path, so each case writes a fixture file into $TestDrive and parses it
from there. The engine-wiring proof lives once, for all custom rules, in CustomRuleWiring.Tests.ps1.
```
