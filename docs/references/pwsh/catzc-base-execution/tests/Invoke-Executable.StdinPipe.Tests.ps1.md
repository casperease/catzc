# pwsh/Base.Execution/tests/Invoke-Executable.StdinPipe.Tests.ps1

The tests of the stdin handling of `Invoke-Executable`: a visible run must not wait on a stdin nobody can answer.

## The child

A child pwsh whose stdin is a pipe held open and never written (the shape of a worker or an agent's shell) runs one visible
`Invoke-Executable` of a stdin reader. Inheriting the open pipe would leave the reader waiting forever.

## Starting it early

The child's import takes seconds, so it starts at the top of the file and the rest of the file runs meanwhile. A run that blocks every real
process (`CATZC_BLOCK_REAL_PROCESS` set to `1`) starts none, while `tier` arms the L0 and L1 Describes alone and leaves the child running.
