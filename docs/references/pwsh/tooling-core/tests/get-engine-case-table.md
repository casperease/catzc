# pwsh/Tooling.Core/tests/Get-EngineCaseTable.Tests.ps1

The L0 tests of `Get-EngineCaseTable`, including a pass over the case tables the repository ships.

## Discovery

A case table sits five levels below `pwsh/`: module, tests, assets, engine-cases, file. The walk prunes vendored modules.
