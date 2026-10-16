---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/tests/types/ParsedScripts.Tests.ps1.md
    folder: docs/references/automation/catzc-base-repository/tests/types
    name: parsed-scripts-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "6ca562f9f6b1"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ParsedScripts' -Tag 'L0', 'logic' {`, written with `#`.

```text
One holder parses a file once. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
