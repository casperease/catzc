# pwsh/Tooling.Toolchain/tests/Install-Shellcheck.Tests.ps1

The tests of `Install-Shellcheck` and `Uninstall-Shellcheck` with the generic engine mocked. On Windows and macOS both delegate to the
`shellcheck` entry of `tools.yml` (winget in user scope, brew). The Linux apt path needs root and a Linux host, so it is not exercised here.
