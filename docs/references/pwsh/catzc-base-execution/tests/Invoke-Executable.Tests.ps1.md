# pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1

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

## comment:5

Above `function script:Start-InputPipeChild {`, written with `#`.

```text
A child pwsh whose stdin is a pipe held open and never written (the shape of a worker or an agent's shell) runs one visible
Invoke-Executable of a stdin reader; inheriting the open pipe would leave the reader waiting forever.
```

## comment:6

Above `$script:inputPipeChild = if ($env:CATZC_BLOCK_REAL_PROCESS -ne '1') {`, written with `#`.

```text
The child's import takes seconds, so it starts here and the rest of the file runs meanwhile; a run that blocks every real process
('1') starts none.
```
