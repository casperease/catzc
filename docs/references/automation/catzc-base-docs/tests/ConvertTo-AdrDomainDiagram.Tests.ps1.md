---
catzc:
  immutable:
    with_body_sha: "1b1d4d938f02"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: convert-to-adr-domain-diagram-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Docs/tests/ConvertTo-AdrDomainDiagram.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConvertTo-AdrDomainDiagram' -Tag 'L0', 'logic' {`, written with `#`.

```text
ConvertTo-AdrDomainDiagram — a pure renderer, fed fixture edges and a fixture AdrsConfig for the node roles
(Get-Config mocked). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
