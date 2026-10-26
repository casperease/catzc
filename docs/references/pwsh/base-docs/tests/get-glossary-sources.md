# pwsh/Base.Docs/tests/Get-GlossarySources.Tests.ps1

The tests of `Get-GlossarySources`. The function is private, so it is exercised through the module (`InModuleScope`, per
[ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).

## Seams

Discovery is redirected to the fixture sources under `tests/assets/glossary/` through the `Resolve-ConfigEntry` seam, so every source still
loads through `Get-Config` and the `GlossaryConfig` type; git is mocked at `Get-GitTrackedPath`. The fixture owners are loaded modules
(`Get-Config` resolves validation in the owner's scope), and the fixture terms are neutral
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

A mock defines only the parameters its caller passed, so `-All` and `-Module` are probed, not read bare (strict mode).
