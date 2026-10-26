# pwsh/Base.Timeouts/tests/types/BoundedCommand.Tests.ps1

The tests of `BoundedCommand`, the command grammar of the time safeguard, run across the execution engines.

## The cases

Every case runs on every engine, from the per-engine fixture table: a case that does not apply to an engine says why there
(`n/a: <reason>`), so pwsh, bash and zsh parity reads side by side in one file.
