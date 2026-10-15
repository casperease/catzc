---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Remove-SystemInstallation.ps1.md
    kind: comment-page
    body_sha: "0ae32a4180ca"
    adrs:
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Tooling.Core/Remove-SystemInstallation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Shared helper for Remove-NodeJs, Remove-Python, etc. Deletes the
directory, removes matching entries from the system (Machine) PATH,
and clears the specified Machine environment variables. Windows-only.

Every persistent write goes through its seam — Set-EnvironmentPath for
the PATH, Set-PermanentEnvironmentVariable for a variable — which
announces the change; Windows broadcasts WM_SETTINGCHANGE on each
persistent write, so running shells pick it up
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33)).
```

## comment:2

Section `.PARAMETER ExtraPathDirs` of the comment-based help.

```text
Subdirectory names under InstallDir that are also on PATH
(e.g. 'Scripts' for Python, 'wbin' for AzCli).
```
