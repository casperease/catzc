---
catzc:
  immutable:
    with_body_sha: "1fd0ab551e02"
    path: docs/references/automation/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-agent-front-matter-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
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
