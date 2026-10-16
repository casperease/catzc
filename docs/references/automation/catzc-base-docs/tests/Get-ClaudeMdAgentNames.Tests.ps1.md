---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "584009f6737e"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-AGENTS#3
---

# automation/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ClaudeMdAgentNames' -Tag 'L0', 'logic', 'ADR-REPO-AGENTS#3' {`, written with `#`.

```text
Get-ClaudeMdAgentNames over fixture CLAUDE.md files in $TestDrive. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
