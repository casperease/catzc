# pwsh/Tooling.Toolchain/tests/Install-Bicep.Tests.ps1

The tests of `Install-Bicep` and `Uninstall-Bicep` with the generic engine mocked. On Windows and macOS both delegate to the `bicep` entry
of `tools.yml` (winget in user scope, brew). On Linux, `Install-Bicep` installs the verified release binary through
`Install-BicepStandalone`, tested on its own, and `Uninstall-Bicep` removes it from `~/.local/bin`.
