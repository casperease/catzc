# pwsh/Base.Environment/tests/Add-PermanentPath.Tests.ps1

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
which hits a Pester $script: scope surprise — see docs/drs test-automation Gotchas.)
```

## comment:3

Above `$script:fakeUserPath = $null`, written with `#`.

```text
The persistent PATH lives in memory behind its seam, so no run mutates the machine's PATH or broadcasts a
settings change.
```
