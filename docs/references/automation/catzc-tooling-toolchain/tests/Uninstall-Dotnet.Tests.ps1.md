---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Uninstall-Dotnet.Tests.ps1.md
    kind: test-asset
    body_sha: "46d5af64af68"
---

# automation/Catzc.Tooling.Toolchain/tests/Uninstall-Dotnet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Context 'an installed SDK' {`.

```text
The installed path: every boundary that touches state outside the repository is mocked — the folder delete,
the PATH seam (Remove-PermanentPath), the persistent variable seam (Set-PermanentEnvironmentVariable), the
lock query (Get-DotnetInstallHolder), the process stop (Stop-DotnetInstallHolder) and the elevation probe.
```
