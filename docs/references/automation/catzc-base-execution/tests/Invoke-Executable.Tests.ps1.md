---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/Invoke-Executable.Tests.ps1.md
    kind: test-asset
    body_sha: "36c58aa56b32"
---

# automation/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Use where.exe/which as the test command — real executables on all platforms.
'echo' is a shell builtin on Windows (no echo.exe) and breaks Stream mode.
```

## comment:2

Above `$leaver = 'pwsh -NoProfile -NonInteractive -Command "Start-Process...`.

```text
L2: the child exits at once, but the grandchild it starts inherits the output pipe and holds it for 20 s
(as a dotnet build server does). The run must not wait out the grandchild.
```

## comment:3

Above `($result.Output.Trim() -replace '^/private', '') | Should -Be ($tempDirectory...`.

```text
macOS resolves /var, /tmp → /private/var, /private/tmp, so the child's reported cwd carries a
/private prefix that [IO.Path]::GetTempPath() does not. Normalize both sides.
```

## comment:4

Above `$command = if ($IsWindows) {`.

```text
where.exe /? outputs help — proves the argument arrived intact.
More importantly: a space-containing quoted arg must not be split.
```
