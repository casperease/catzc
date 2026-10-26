# Catzc.Base.Engines

Owns the model of the repository's three execution engines, pwsh, bash and zsh: the one declaration of everything that differs between them,
from how each is started and how it quotes a literal to its strict mode and importer entry
([ADR-AUTO-ENGINE](../../../drs/automation/execution-engines.md)). It does not locate an engine's executable on a machine (that is
[Catzc.Base.Execution](../base-execution/index.md)'s `Resolve-EngineExecutable`) or run anything; it is the data the code that does reads.

## Responsibilities

| Responsibility   | Area  | Name                                                   |
| ---------------- | ----- | ------------------------------------------------------ |
| responsibility:1 | model | [The engine model](#responsibility1--the-engine-model) |

### responsibility:1 — The engine model

The repository's own code runs under exactly three execution engines, and this module declares them once. Each engine names its executable
and how it is located (beside the running PowerShell for pwsh; through its `tools.yml` entry for the POSIX engines), the script files it
runs and its shebang, its non-interactive start and command flag, its quoting of a literal, the statement that loads an entry script
silently, its strict mode, its time safeguard, the line endings and executable bit its scripts need, and its importer entry. From these it
composes the arguments that start the engine, load an entry, and run one command. The set of engines is closed: the three instances are the
only ones, and every list of engines elsewhere reads the model's names rather than restating them. Per-engine fixture tables check the start
and the locator under all three engines side by side.

## What the module does

It is the foundation the engine-aware code stands on. The modules that key a setting per shell, the black-box test runners that start the
engine, and the executable lookup all read the model, so a difference between the engines is stated once. The module has no dependencies, so
it can sit below every module that needs it, including those below `Catzc.Base.Execution`.

## Division

The module's public function, sorted into the responsibility above.

| Responsibility                      | Function              |
| ----------------------------------- | --------------------- |
| responsibility:1 — The engine model | `Get-ExecutionEngine` |
