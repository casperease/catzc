---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/LinksConfig.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e996b3470598
    adrs:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'LinksConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
LinksConfig maps links.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key
behaves exactly like the default, and a malformed value fails at construction with the allowed set.
```
