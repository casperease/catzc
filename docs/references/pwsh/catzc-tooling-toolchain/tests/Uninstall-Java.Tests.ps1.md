# pwsh/Catzc.Tooling.Toolchain/tests/Uninstall-Java.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Uninstall-Java' -Tag 'L1', 'logic' {`, written with `#`.

```text
Hermetic logic (L1): every boundary that touches state outside the repository is mocked — the tool manager
(Uninstall-Tool, Remove-Java) and the persistent user environment (Set-PermanentEnvironmentVariable). The real
registry round trip is the seam's own L3 system test (Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1).
```

## comment:2

Above `$script:savedProcessJavaHome = $env:JAVA_HOME`, written with `#`.

```text
The managed body clears the session JAVA_HOME — restore it so the test leaves the process as it found it
([ADR-PWSH-ENV-NOPESTERISOLATION](/docs/adr/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-nopesterisolation)).
```
