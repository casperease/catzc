# pwsh/Catzc.Base.Execution/tests/Invoke-Executable.StdinPipe.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function script:Start-InputPipeChild {`, written with `#`.

```text
A child pwsh whose stdin is a pipe held open and never written (the shape of a worker or an agent's shell) runs one visible
Invoke-Executable of a stdin reader; inheriting the open pipe would leave the reader waiting forever.
```

## comment:2

Above `$script:inputPipeChild = if ($env:CATZC_BLOCK_REAL_PROCESS -ne '1') {`, written with `#`.

```text
The child's import takes seconds, so it starts here and the rest of the file runs meanwhile; a run that blocks every real process
('1') starts none.
```
