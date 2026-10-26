# pwsh/Base.Engines/tests/types/ExecutionEngine.Tests.ps1

The test file of the `ExecutionEngine` model. It checks the model against per-engine fixture tables (`Get-EngineCaseTable`).

## Why it is shaped so

Every case runs under every engine, side by side, so a behaviour that differs between pwsh, bash and zsh differs on purpose
([ADR-AUTO-ENGINE](../../../../../drs/automation/execution-engines.md)).
