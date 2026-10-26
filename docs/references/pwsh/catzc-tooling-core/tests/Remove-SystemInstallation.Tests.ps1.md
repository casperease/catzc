# pwsh/Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1

The L1 tests of `Remove-SystemInstallation`.

## Hermetic

Every boundary that touches state outside the repository is mocked: the install directory delete (`Remove-Item`), the Machine PATH
(`Get-EnvironmentPath` and `Set-EnvironmentPath`) and the Machine variables (`Set-PermanentEnvironmentVariable`). The seams' real registry
round trips are their own L3 system tests.
