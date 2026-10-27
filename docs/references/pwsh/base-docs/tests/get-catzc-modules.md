# pwsh/Base.Docs/tests/Get-CatzcModules.Tests.ps1

The tests of `Get-CatzcModules`. The function is private, so it is exercised through the module
([ADR-PWSH-PESTER-PRIVATETHROUGHMODULE](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-privatethroughmodule)).

## Fixture modules

Fixture modules are loaded from a fixture code root: two catzc-shaped modules, one dot-prefixed infrastructure module, and one module loaded
from outside the root.

## Loaded session

The last block reads the real loaded session with nothing mocked, so it runs in both the source run and the build run and proves
`Show-Catzc` lists the modules of whichever tree is loaded
([ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)).
