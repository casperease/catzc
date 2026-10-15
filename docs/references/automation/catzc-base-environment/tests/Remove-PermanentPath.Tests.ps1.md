---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/tests/Remove-PermanentPath.Tests.ps1.md
    kind: test-asset
    body_sha: e3b46921f6a0
---

# automation/Catzc.Base.Environment/tests/Remove-PermanentPath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:fakeUserPath = $null`.

```text
Keep the persistent (Windows User-registry) PATH entirely IN-MEMORY via the Get-EnvironmentPath/Set-EnvironmentPath
seam, so NOTHING here mutates the real machine PATH or broadcasts WM_SETTINGCHANGE. Every Windows run
of Remove-PermanentPath hits this branch (not just the persistence context), so the mocks are global.
```
