# pwsh/Tooling.Toolchain/tests/Uninstall-Dotnet.Tests.ps1

The tests of `Uninstall-Dotnet`. On the installed path every boundary that touches state outside the repository is mocked: the folder delete,
the PATH seam (`Remove-PermanentPath`), the persistent variable seam (`Set-PermanentEnvironmentVariable`), the lock query
(`Get-DotnetInstallHolder`), the process stop (`Stop-DotnetInstallHolder`) and the elevation probe.
