# automation/pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1

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
([ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](/docs/adr/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). Returns the
RAW banner (ANSI intact) so a caller can assert on colour or strip for text.
```
