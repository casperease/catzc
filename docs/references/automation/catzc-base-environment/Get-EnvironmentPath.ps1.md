---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Get-EnvironmentPath.ps1.md
    kind: comment-page
    body_sha: d00c31a8b1a0
---

# automation/Catzc.Base.Environment/Get-EnvironmentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single seam through which the PATH helpers (Add-/Remove-PermanentPath, Sync-SessionPath, the tooling
uninstallers) READ the persistent PATH, so tests can Mock the registry boundary
(`Mock Get-EnvironmentPath -ModuleName <module>`) instead of reading the real machine. Paired with
Set-EnvironmentPath for writes. User/Machine scopes are a Windows concept; callers guard Windows-only use
with $IsWindows. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
own.
```
