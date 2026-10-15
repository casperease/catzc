---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationVerdict.Tests.ps1.md
    kind: test-asset
    body_sha: cfa71ad433a4
    adrs:
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the banner's
information-stream output can be asserted (see console-output-matters / Write-InformationColored).
```

## comment:2

Above `function Get-VerdictRaw {`.

```text
The presenter is a private (module-scoped) function, so it is invoked through InModuleScope
([ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). Returns the
RAW banner (ANSI intact) so a caller can assert on colour or strip for text.
```
