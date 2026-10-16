---
catzc:
  immutable:
    with_body_sha: "3258007d7b61"
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrCitationGraphViolations.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-adr-citation-graph-violations-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrCitationGraphViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrCitationGraphViolations' -Tag 'L0', 'logic',...`, written with `#`.

```text
Get-AdrCitationGraphViolations — a rule summary cites only its own domain or a domain its domain depends on, read as declared (not
transitively); prose outside the rule registry is not read. A fixture tree in $TestDrive and a fixture registry, widget <- gadget
<- gizmo; neutral fixture codes ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
