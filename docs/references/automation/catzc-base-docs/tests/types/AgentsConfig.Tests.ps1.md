---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests/types
    name: agents-config-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d42440b23873
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#2
---

# automation/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'AgentsConfig' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#2' {`, written with `#`.

```text
Validates the compiled AgentsConfig type directly — the constructor stops a malformed agents.yml from ever
producing an instance. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
