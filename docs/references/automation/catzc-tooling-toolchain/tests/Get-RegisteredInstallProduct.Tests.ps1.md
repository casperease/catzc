---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1.md
    kind: test-asset
    body_sha: e945b9822b5c
---

# automation/Catzc.Tooling.Toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:entries = @{`.

```text
Two uninstall-registry views: the bundle registers only in the 32-bit one, its MSI in the 64-bit one, under the
same display name — the shape the .NET runtime installers leave.
```
