---
catzc:
  immutable:
    with_body_sha: df07bc970c5f
    repo_status: locked
    path: docs/references/automation/catzc-base-environment/tests/Add-PermanentPath.Tests.ps1.md
    folder: docs/references/automation/catzc-base-environment/tests
    name: add-permanent-path-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Environment/tests/Add-PermanentPath.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:fakeUserPath = $null`, written with `#`.

```text
Keep the persistent (Windows User-registry) PATH entirely IN-MEMORY via the Get-EnvironmentPath/Set-EnvironmentPath
seam, so NOTHING here mutates the real machine PATH or broadcasts WM_SETTINGCHANGE. Every Windows run
of Add-PermanentPath hits this branch (not just the persistence context), so the mocks are global.
```

## comment:2

Above `$script:fakeUserPath = "C:\existing\tool;$tempDir"`, written with `#`.

```text
Seed with the entry already there → Add must detect it and skip the registry write entirely.
(Asserting on Set-EnvironmentPath invocation avoids relying on mock-to-mock state round-tripping,
which hits a Pester $script: scope surprise — see docs/adr test-automation Gotchas.)
```
