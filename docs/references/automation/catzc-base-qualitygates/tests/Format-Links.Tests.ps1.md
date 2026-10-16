---
catzc:
  immutable:
    with_body_sha: e99297ad31c8
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Format-Links.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: format-links-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-LINK#8
---

# automation/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Format-Links' -Tag 'L0', 'logic' {`, written with `#`.

```text
Format-Links is the link aligner and the repository-wide migration
([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)), tested in isolation: every test
builds its own fixture repository in $TestDrive — a two-ADR index with neutral widget/gadget codes
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)),
an .editorconfig, and the source files under test — and aligns only that tree (-RepositoryRoot, -Path).
```
