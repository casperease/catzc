---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrCitationMap.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-adr-citation-map-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0182b28fdef1"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#3
---

# automation/Catzc.Base.Docs/tests/Get-AdrCitationMap.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrCitationMap' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-AdrCitationMap builds the citation registry the link engine derives every code link from
([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)).
A fixture repository in $TestDrive carries a two-ADR index (neutral widget/gadget codes,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and two
code-less documents that share a file name, so the slug lookup's ambiguity is exercised too.
```
