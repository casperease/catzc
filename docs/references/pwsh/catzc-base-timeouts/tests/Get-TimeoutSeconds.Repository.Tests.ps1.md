# pwsh/Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1

The repository test of the declared time limit: it scans the shipped scripts and fails a default that is a number literal.

## What it pins

A function bounds its own long-running work through `Get-TimeoutSeconds -Command` and its `[TimeLimit]` decoration, never a number literal as
the parameter default
([ADR-PWSH-ASSERT-DECLAREDTIMELIMIT](../../../../drs/automation/pwsh/assert-idioms.md#rule-adr-pwsh-assert-declaredtimelimit)). It reads the
shipped .ps1 files by syntax tree, so it runs in the source and the build run alike.

## The scan depth

Scripts reach four levels below `pwsh/` (module, tests, types, file); the walk prunes the vendored modules.
