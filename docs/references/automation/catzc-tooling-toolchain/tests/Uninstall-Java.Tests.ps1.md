---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Uninstall-Java.Tests.ps1.md
    kind: test-asset
    body_sha: "83f91db28a0b"
    adrs:
      - ADR-PWSH-ENV#4
---

# automation/Catzc.Tooling.Toolchain/tests/Uninstall-Java.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Uninstall-Java' -Tag 'L1', 'logic' {`.

```text
Hermetic logic (L1): every boundary that touches state outside the repository is mocked — the tool manager
(Uninstall-Tool, Remove-Java) and the persistent user environment (Set-PermanentEnvironmentVariable). The real
registry round trip is the seam's own L3 system test (Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1).
```

## comment:2

Above `$script:savedProcessJavaHome = $env:JAVA_HOME`.

```text
The managed body clears the session JAVA_HOME — restore it so the test leaves the process as it found it
([ADR-PWSH-ENV#4](/docs/adr/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env4)).
```
