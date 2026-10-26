# pwsh/Tooling.Toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1

The tests of `Get-RegisteredInstallProduct`. The fixture entries stand in for two uninstall-registry views: the bundle registers only in the
32-bit one and its MSI in the 64-bit one, under the same display name, which is the shape the .NET runtime installers leave.
