---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/private/Test-IsWslSession.ps1.md
    kind: reference
    body_sha: "533b3e72d3c7"
    adrs: []
---

# automation/Catzc.Tooling.Provisioning/private/Test-IsWslSession.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A WSL distribution sets WSL_DISTRO_NAME, and a WSL kernel identifies itself in /proc/version
("microsoft"). Either signal means the Linux session is backed by a Windows host, so
Windows-side tools are reachable under /mnt/c. Never true outside Linux.
```
