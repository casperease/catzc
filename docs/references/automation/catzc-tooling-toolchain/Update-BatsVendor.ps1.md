---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Update-BatsVendor.ps1.md
    kind: comment-page
    body_sha: cc4a2c7c38b0
---

# automation/Catzc.Tooling.Toolchain/Update-BatsVendor.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above ``Invoke-Executable "tar -xzf `"$fileName`"" -WorkingDirectory $staging -Silent``.

```text
A relative name inside the staging folder, so no path carries a drive letter's colon (GNU tar reads one as a
remote host).
```
