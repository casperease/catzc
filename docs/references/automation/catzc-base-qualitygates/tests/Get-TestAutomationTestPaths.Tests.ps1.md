---
catzc:
  immutable:
    with_body_sha: "7b6680ecbd7c"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestAutomationTestPaths.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-test-automation-test-paths-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-TestAutomationTestPaths' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-TestAutomationTestPaths over a fixture automation tree in $TestDrive (Get-RepositoryRoot and
Get-ModuleOrder mocked): two modules with tests, one without, and one dot-prefixed infrastructure folder.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
