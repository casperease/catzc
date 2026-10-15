---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "111d24d5b579"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The typed record over one tools.yml entry. It rejects keys it does not map (a dropped key would be invisible
to every caller), and these pin the optional flags the provisioning loops branch on. Fixture tokens are
neutral ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
