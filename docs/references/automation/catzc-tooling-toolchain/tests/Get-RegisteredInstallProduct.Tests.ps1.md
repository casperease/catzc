---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "01b867c5c5f4"
---

# automation/Catzc.Tooling.Toolchain/tests/Get-RegisteredInstallProduct.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:entries = @{`, written with `#`.

```text
Two uninstall-registry views: the bundle registers only in the 32-bit one, its MSI in the 64-bit one, under the
same display name — the shape the .NET runtime installers leave.
```
