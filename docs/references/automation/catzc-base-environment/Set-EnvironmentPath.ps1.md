---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Set-EnvironmentPath.ps1.md
    kind: comment-page
    body_sha: c29c8e5ac152
    adrs:
      - ADR-AUTO-CONSOLE#11
---

# automation/Catzc.Base.Environment/Set-EnvironmentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single seam through which the PATH helpers (Add-/Remove-PermanentPath, the tooling uninstallers)
WRITE the persistent PATH, so tests can Mock the registry boundary
(`Mock Set-EnvironmentPath -ModuleName <module>`) instead of mutating the real machine PATH (which also
broadcasts WM_SETTINGCHANGE). User/Machine scopes are a Windows concept; callers guard Windows-only use
with $IsWindows. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
own.

Because every persistent PATH write passes through here, this is also where it is announced
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)): one line
names the scope and the entries added and removed. Writing the value the
scope already holds is a no-op, so it neither writes nor announces.
```
