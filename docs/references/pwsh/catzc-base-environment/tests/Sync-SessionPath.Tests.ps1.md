# pwsh/Base.Environment/tests/Sync-SessionPath.Tests.ps1

<!-- cspell:ignore machinebin userbin -->

The L0 logic tests of `Sync-SessionPath`, which rebuilds the session PATH from the registry.

## Seam

The persistent PATH is read through the `Get-EnvironmentPath` seam, mocked per case through `$script:regUser` and `$script:regMachine`. Every
case is deterministic and none reads the machine's registry.
