---
catzc:
  immutable:
    with_body_sha: "8ed1cf7997bb"
    path: docs/references/automation/catzc-base-execution/tests/Invoke-Executable.Tests.ps1.md
    folder: docs/references/automation/catzc-base-execution/tests
    name: invoke-executable-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Use where.exe/which as the test command — real executables on all platforms.
'echo' is a shell builtin on Windows (no echo.exe) and breaks Stream mode.
```

## comment:2

Above `$leaver = 'pwsh -NoProfile -NonInteractive -Command "Start-Process...`, written with `#`.

```text
L2: the child exits at once, but the grandchild it starts inherits the output pipe and holds it for 20 s
(as a dotnet build server does). The run must not wait out the grandchild.
```

## comment:3

Above `($result.Output.Trim() -replace '^/private', '') | Should -Be ($tempDirectory...`, written with `#`.

```text
macOS resolves /var, /tmp → /private/var, /private/tmp, so the child's reported cwd carries a
/private prefix that [IO.Path]::GetTempPath() does not. Normalize both sides.
```

## comment:4

Above `$command = if ($IsWindows) {`, written with `#`.

```text
where.exe /? outputs help — proves the argument arrived intact.
More importantly: a space-containing quoted arg must not be split.
```
