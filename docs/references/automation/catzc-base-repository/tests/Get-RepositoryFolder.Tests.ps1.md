---
catzc:
  immutable:
    with_body_sha: "9246243597b9"
    path: docs/references/automation/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md
    folder: docs/references/automation/catzc-base-repository/tests
    name: get-repository-folder-tests-ps1
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

# automation/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-RepositoryFolder' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-RepositoryFolder over a $TestDrive root (Get-RepositoryRoot mocked): path normalization against the root, never
$PWD. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
