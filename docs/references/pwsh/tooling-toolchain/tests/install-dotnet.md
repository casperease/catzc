# pwsh/Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1

The tests of `Install-Dotnet`, in two groups.

## The shipped install scripts

This group drives `Install-Dotnet` to the point where it resolves the vendored install script, then reads the real script shipped in the
loaded module. The lookup is not mocked, so the test runs in both the source run and the build run
([ADR-AUTO-ASSETDEP-COVEREDBYREALTEST](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-coveredbyrealtest)).
The environment boundaries are mocked so nothing is downloaded or installed, and the script's presence check is the stop point: it records
the resolved path and halts before the script runs.

## The logic

This group is hermetic logic (L1). The install script, the version probes, the PATH seam (`Add-PermanentPath`) and the persistent variable
seam (`Set-PermanentEnvironmentVariable`) are mocked or fixtures under `TestDrive`. Nothing is downloaded, and the real user environment is
never touched; its round trip is the seam's L3 test.
