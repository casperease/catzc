# pwsh/Tooling.Toolchain/tests/Install-Java.Tests.ps1

The tests of `Install-Java`, hermetic logic (L1). The tool manager (`Install-Tool`), the installed-version probe, command resolution and the
persistent user environment (`Set-PermanentEnvironmentVariable`) are mocked; the JDK layout is a fixture under `TestDrive`. The real registry
round trip is the seam's own L3 system test, `Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1`.
