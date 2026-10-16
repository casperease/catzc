---
catzc:
  immutable:
    with_body_sha: "903a7ebedf28"
    repo_status: locked
    path: docs/references/automation/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
    folder: docs/references/automation/catzc-base-objects/tests/types
    name: console-text-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConsoleText' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {`, written with `#`.

```text
ConsoleText — the shared console rendering behind every catzc type's ToString(), so an object held in pwsh reads
as one line in "$x", [string]$x and a table cell. Exercised through probe types compiled by Add-Type against the
loaded combined assembly. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
