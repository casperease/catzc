---
catzc:
  immutable:
    with_body_sha: a33a52233a3a
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/tests/types/AdrDomainEdge.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests/types
    name: adr-domain-edge-tests-ps1
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

# automation/Catzc.Base.Docs/tests/types/AdrDomainEdge.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'AdrDomainEdge' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#9' {`, written with `#`.

```text
AdrDomainEdge — one From/To edge of the ADR domain graph; the constructor holds both ends non-empty and distinct.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
