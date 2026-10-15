---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/private/Find-WindowsGitCredentialManager.ps1.md
    kind: comment-page
    body_sha: "31c0a103849e"
---

# automation/Catzc.Tooling.Provisioning/private/Find-WindowsGitCredentialManager.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Probes the known Windows-side install locations under /mnt/c — the system-wide Git for Windows
install, and the per-user portable install Install-Git produces under LOCALAPPDATA — for the
credential-manager executable (git-credential-manager.exe; the -core suffix on older Git for
Windows releases). Returns the first existing path, or $null when none exists (git is not
installed on the Windows side).
```
