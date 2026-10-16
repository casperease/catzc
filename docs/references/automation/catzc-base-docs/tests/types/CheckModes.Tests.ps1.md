---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/CheckModes.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0aee249a64a3"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CheckModes' -Tag 'L0', 'logic', 'ADR-PRIN-ONELIVE#1' {`, written with `#`.

```text
CheckModes — the one parser of a check's mode setting, shared by every check config: an omitted mode is the default declared
once on CheckMode, and an unknown one gets the one error text. Neutral fixture values
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
