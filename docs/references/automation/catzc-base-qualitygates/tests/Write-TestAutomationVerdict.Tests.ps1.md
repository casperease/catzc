---
catzc:
  immutable:
    with_body_sha: "296f308e0429"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationVerdict.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: write-test-automation-verdict-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the banner's
information-stream output can be asserted (see console-output-matters / Write-InformationColored).
```

## comment:2

Above `function Get-VerdictRaw {`, written with `#`.

```text
The presenter is a private (module-scoped) function, so it is invoked through InModuleScope
([ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). Returns the
RAW banner (ANSI intact) so a caller can assert on colour or strip for text.
```
