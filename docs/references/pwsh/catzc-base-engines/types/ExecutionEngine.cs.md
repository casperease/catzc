# pwsh/Base.Engines/types/ExecutionEngine.cs

One of the repository's execution engines, the shells its own code runs under
([ADR-AUTO-ENGINE](../../../../drs/automation/execution-engines.md)). Everything that differs between the engines is declared here, once, so
no caller restates a flag, a quote rule or a file name.

## What it holds

How the engine's executable is named and located, which script files it runs, how it is started non-interactively, how it loads an entry
script and runs a command, its strict mode, its time safeguard, the line endings and executable bit its scripts need, and its importer
entry. The three instances live in `ExecutionEngines`. The type has no public constructor, so no caller invents a fourth.

A model type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Locating the executable

`Locate` is `LocateByPsHome` or `LocateByTool`. The first finds the executable beside the running PowerShell (`$PSHOME`). The second goes
through the engine's `tools.yml` entry, named by `ToolKey` (the existence check is `Resolve-ToolExecutable`).

## Time safeguard

`TimeSafeguard` says how a call is bounded in time in this engine
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)).

## Command prefix

`CommandPrefix` is what goes before a catzc command in this engine: nothing in pwsh, where the commands are native, and `cats ` in bash and
zsh, the dispatcher `importer.sh` defines, which runs the command through pwsh. A command's text is the same in every engine.

## Quote

`Quote(text)` returns the text as one literal string in the engine's own quoting: single quotes, with an embedded single quote written the
engine's way (`''` in pwsh, `'\''` in bash and zsh).

## StartArguments

`StartArguments(entry, command)` returns the arguments, after the executable, that start the engine non-interactively, load the entry script
and run the catzc command: the non-interactive arguments, the command flag, then one command text
`<source the entry>; <command prefix><command>`.
