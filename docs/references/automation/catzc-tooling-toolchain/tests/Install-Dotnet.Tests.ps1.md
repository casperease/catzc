---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Dotnet.Tests.ps1.md
    kind: test-asset
    body_sha: a5def4cb4b47
    adrs:
      - ADR-AUTO-ASSETDEP#3
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Install-Dotnet — shipped install scripts' -Tag 'L1', 'integrity',...`.

```text
Drives Install-Dotnet to the point where it resolves the vendored install script, then reads the REAL script
shipped in the loaded module (the lookup is not mocked), so it runs in both the source run and the build run
([ADR-AUTO-ASSETDEP#3](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep3)). The environment
boundaries are mocked so nothing is downloaded or installed, and the
script's presence check is the stop point: it records the resolved path and halts before the script runs.
```

## comment:2

Above `Describe 'Install-Dotnet' -Tag 'L1', 'logic' {`.

```text
Hermetic logic (L1): the install script, the version probes, the PATH seam (Add-PermanentPath) and the persistent
variable seam (Set-PermanentEnvironmentVariable) are mocked or fixtures under $TestDrive — nothing is downloaded,
and the real user environment is never touched (its round trip is the seam's L3 test).
```
