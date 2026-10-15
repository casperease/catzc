---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md
    kind: test-asset
    body_sha: ae59cf9a7277
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
The probed branch: a tool with candidate paths is asserted from the probe record, never by its bare name on
PATH. The probe is mocked whole. Fixture tokens are neutral
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
