---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Update-BatsVendor.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "511d6c329a0e"
---

# automation/Catzc.Tooling.Toolchain/Update-BatsVendor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above ``Invoke-Executable "tar -xzf `"$fileName`"" -WorkingDirectory $staging -Silent``, written with `#`.

```text
A relative name inside the staging folder, so no path carries a drive letter's colon (GNU tar reads one as a
remote host).
```
