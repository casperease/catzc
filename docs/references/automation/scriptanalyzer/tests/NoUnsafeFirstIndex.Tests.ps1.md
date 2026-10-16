---
catzc:
  immutable:
    with_body_sha: "3a60c88cda4f"
    path: docs/references/automation/scriptanalyzer/tests/NoUnsafeFirstIndex.Tests.ps1.md
    folder: docs/references/automation/scriptanalyzer/tests
    name: no-unsafe-first-index-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
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
