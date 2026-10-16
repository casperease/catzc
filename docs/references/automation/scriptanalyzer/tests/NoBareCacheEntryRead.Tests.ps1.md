---
catzc:
  immutable:
    with_body_sha: "76d14f1b2920"
    path: docs/references/automation/scriptanalyzer/tests/NoBareCacheEntryRead.Tests.ps1.md
    folder: docs/references/automation/scriptanalyzer/tests
    name: no-bare-cache-entry-read-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/.scriptanalyzer/tests/NoBareCacheEntryRead.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Measure-NoBareCacheEntryRead' -Tag 'L0', 'logic', 'ADR-PWSH-CACHE#4' {`, written with `#`.

```text
The per-case assertions run the rule function directly on a parsed AST (L0). The engine-wiring proof lives once,
for all custom rules, in CustomRuleWiring.Tests.ps1.
```
