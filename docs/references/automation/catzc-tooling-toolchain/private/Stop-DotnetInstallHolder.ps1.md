---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Stop-DotnetInstallHolder.ps1.md
    kind: comment-page
    body_sha: "3af58a6173f4"
---

# automation/Catzc.Tooling.Toolchain/private/Stop-DotnetInstallHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Stops each holder Get-DotnetInstallHolder named — by process id, nothing else — and waits for it to exit,
so its handles on the install are released. A process that already exited is skipped. Refuses to stop the
calling session itself. Throws when the install is still held afterwards (a process restarted, or a new
holder appeared).
```
