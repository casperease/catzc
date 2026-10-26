# pwsh/Base.Config/tests/Get-ConfigRegistry.Tests.ps1

The tests of the private `Get-ConfigRegistry`, with fixture registries and with the shipped `configs.yml`.

## Fixture registries

The function is private, so it is exercised through the module with `InModuleScope`
([ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)). Each
case resets the session's cache entry before and after
([ADR-PWSH-PESTER-MOCKMODULEBOUNDARIES](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-mockmoduleboundaries)), so a
fixture registry never leaks into the rest of the run.

## Shipped registry

One block reads the shipped `configs.yml` through the real lookup, with nothing mocked, so it runs in both the source run and the build run
and proves the registry resolves inside the loaded module
([ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)).
