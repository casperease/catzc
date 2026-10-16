---
catzc:
  immutable:
    with_body_sha: "6adebf45ced9"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestExecutable.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-language-test-executable-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-LanguageTestExecutable' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-LanguageTestExecutable with the test folder discovery and the tool probe mocked: the source session hands down a
language's tool only when it is found at the pin, and probes nothing for a language without test folders. Neutral
fixture paths ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
