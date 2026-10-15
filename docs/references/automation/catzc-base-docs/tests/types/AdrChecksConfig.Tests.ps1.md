---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/AdrChecksConfig.Tests.ps1.md
    kind: test-asset
    body_sha: fe21470dd7be
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'AdrChecksConfig' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {`.

```text
AdrChecksConfig — the ADR checks' settings (adr-checks.yml): every key optional with its default declared once on the type, and
every violation collected into one throw. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
