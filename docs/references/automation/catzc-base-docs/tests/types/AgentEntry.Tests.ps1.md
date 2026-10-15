---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md
    kind: test-asset
    body_sha: "8ae7418aa599"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#2
---

# automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'AgentEntry' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#2' {`.

```text
Validates the compiled AgentEntry type directly — the constructor stops a malformed agents.yml entry from ever
producing an instance. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
