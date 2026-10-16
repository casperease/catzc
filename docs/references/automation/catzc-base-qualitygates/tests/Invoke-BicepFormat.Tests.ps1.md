---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-BicepFormat.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "588b5b70ce56"
    adrs:
      - ADR-AUTO-TEST#{3,6}
---

# automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-BicepFormat' -Tag 'L0', 'logic' {`, written with `#`.

```text
The bicep engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
the probe finds a managed Bicep CLI, and the mock writes the --outfile copy the engine compares. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {`, written with `#`.

```text
The fake formatter collapses runs of spaces in every file the --pattern names, in place, as `bicep format
--pattern` does.
```
