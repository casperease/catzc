---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/CheckMode.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "10e580dce292"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#4
---

# automation/Catzc.Base.Docs/types/CheckMode.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Docs;`, written with `//`.

```text
How a repository check treats what it finds, set per check in its config (adr-checks.yml in Catzc.Base.Docs; links.yml and
source-conventions.yml in Catzc.Base.QualityGates), never per check in code
([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)):
  Gate   — every finding is an issue, so the run fails until the count is 0, like any quality gate
           ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35))
  Report — every finding is printed and counted, and the run never fails on it; a check starts here while its work list is
           drained, and moves to Gate once its count reaches 0
Gate is the default, declared once here as the type's zero value: a check whose config omits mode is default(CheckMode)
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
```
