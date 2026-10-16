---
catzc:
  immutable:
    with_body_sha: "55be044ddcaf"
    path: docs/references/automation/catzc-tooling-toolchain/tests/Uninstall-Dotnet.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain/tests
    name: uninstall-dotnet-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Toolchain/tests/Uninstall-Dotnet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Context 'an installed SDK' {`, written with `#`.

```text
The installed path: every boundary that touches state outside the repository is mocked — the folder delete,
the PATH seam (Remove-PermanentPath), the persistent variable seam (Set-PermanentEnvironmentVariable), the
lock query (Get-DotnetInstallHolder), the process stop (Stop-DotnetInstallHolder) and the elevation probe.
```
