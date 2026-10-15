---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/tests/Remove-PermanentPath.Tests.ps1.md
    kind: comment-page
    body_sha: dcf2ae4f8a46
---

# automation/Catzc.Base.Environment/tests/Remove-PermanentPath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:fakeUserPath = $null`, written with `#`.

```text
Keep the persistent (Windows User-registry) PATH entirely IN-MEMORY via the Get-EnvironmentPath/Set-EnvironmentPath
seam, so NOTHING here mutates the real machine PATH or broadcasts WM_SETTINGCHANGE. Every Windows run
of Remove-PermanentPath hits this branch (not just the persistence context), so the mocks are global.
```
