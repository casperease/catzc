# pwsh/Tooling.Toolchain/tests/Uninstall-Java.Tests.ps1

The tests of `Uninstall-Java`, hermetic logic (L1). Every boundary that touches state outside the repository is mocked: the tool manager
(`Uninstall-Tool`, `Remove-Java`) and the persistent user environment (`Set-PermanentEnvironmentVariable`). The real registry round trip is
the seam's own L3 system test, `Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1`.

The managed body clears the session `JAVA_HOME`, so the test restores it and leaves the process as it found it
([ADR-PWSH-ENV-NOPESTERISOLATION](../../../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-nopesterisolation)).
