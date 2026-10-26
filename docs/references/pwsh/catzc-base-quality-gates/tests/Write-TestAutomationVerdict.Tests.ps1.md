# pwsh/Base.QualityGates/tests/Write-TestAutomationVerdict.Tests.ps1

The test of `Write-TestAutomationVerdict`. The writers' chokepoint returns early during a run (`$global:__PesterRunning`), so the test lifts
that guard in `BeforeAll`, which lets the banner's information-stream output be asserted (see console-output-matters and
`Write-InformationColored`).

The presenter is a private, module-scoped function, so the test invokes it through `InModuleScope`
([ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). The
helper `Get-VerdictRaw` returns the raw banner with its ANSI intact, so a caller can assert on colour or strip it for text.
