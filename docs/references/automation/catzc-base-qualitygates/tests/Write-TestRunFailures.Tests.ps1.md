---
catzc:
  immutable:
    with_body_sha: "69fbf910a159"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestRunFailures.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: write-test-run-failures-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Write-TestRunFailures' -Tag 'L0', 'logic' {`, written with `#`.

```text
Write-TestRunFailures over fixture rows and file entries, with the console seam (Write-Message / Write-Header /
Write-Footer) mocked and its lines collected. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
