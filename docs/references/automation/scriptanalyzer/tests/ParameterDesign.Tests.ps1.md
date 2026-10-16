---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/ParameterDesign.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a7ac33cc0ebc
---

# automation/.scriptanalyzer/tests/ParameterDesign.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The per-case assertions run the rule functions directly on a parsed AST (L0). Their scope is decided by the file path,
so each case writes a fixture file into $TestDrive under a fake automation/ layout. The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
