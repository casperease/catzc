---
catzc:
  immutable:
    with_body_sha: "4679ae4fa14e"
    path: docs/references/automation/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests/types
    name: agent-entry-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#2
---

# automation/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'AgentEntry' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#2' {`, written with `#`.

```text
Validates the compiled AgentEntry type directly — the constructor stops a malformed agents.yml entry from ever
producing an instance. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
