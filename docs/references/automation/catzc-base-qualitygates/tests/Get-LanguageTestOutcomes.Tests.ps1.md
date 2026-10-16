---
catzc:
  immutable:
    with_body_sha: "647d857254fa"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-language-test-outcomes-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-LanguageTestOutcomes' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-LanguageTestOutcomes with the language runners mocked: every discovered test takes the outcome of its result,
or skips with tool_<tool>_missing when the run's source session handed down no managed tool. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `It 'runs the tests under the <Engine> engine with the executable handed down'...`, written with `#`.

```text
Every engine other than the running pwsh, from the model
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
```
