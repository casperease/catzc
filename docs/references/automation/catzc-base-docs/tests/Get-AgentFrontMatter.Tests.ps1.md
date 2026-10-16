---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1fd0ab551e02"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#1
---

# automation/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AgentFrontMatter' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#1' {`, written with `#`.

```text
Get-AgentFrontMatter over fixture agent files in $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
