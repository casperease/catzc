# docs/adr/automation/execution-engines.md

`ADR: Execution engines — pwsh and bash, declared once`

## Rules: ADR-AUTO-ENGINE

### Rule ADR-AUTO-ENGINE:1

An **execution engine** is a shell the repository's own code runs under, and there are exactly two: pwsh (PowerShell 7) and bash. They are
declared once, in the `ExecutionEngines` model (`Catzc.Base.Engines`); every list of engines in the codebase — config keys per shell, the
columns of a per-engine fixture table, an engine argument's allowed values — is that model's `Names`, never a restated literal list.

- [Two engines](#two-engines)

### Rule ADR-AUTO-ENGINE:2

Everything that differs between the engines is a property of its `ExecutionEngine`, declared once: how its executable is named and located,
the script files it runs, its shebang, its non-interactive start, how it loads an entry script and runs a command (`StartArguments`), its
quoting, its strict mode, its time safeguard, the line endings and executable bit its scripts need, and its importer entry. A caller reads
the property; it never restates a flag, a quote rule, or a file name.

- [One model of what differs](#one-model-of-what-differs)

### Rule ADR-AUTO-ENGINE:3

An engine's executable is located the way its model says, by `Resolve-EngineExecutable`: pwsh beside the running PowerShell (`$PSHOME`), so
a started engine is the caller's own PowerShell and never another one first on `PATH`; bash through its `tools.yml` entry and the existence
check (ADR-AUTO-DEPS#3), never the WSL launcher.

- [Locating an engine](#locating-an-engine)

### Rule ADR-AUTO-ENGINE:4

A black-box test in another language starts the engine from the contract its runner sets, never from a hardcoded command: `CATZC_ENGINE`
(the engine's name), `CATZC_ENGINE_EXECUTABLE`, `CATZC_ENGINE_ENTRY` (the script that loads catzc into the engine), and
`CATZC_ENGINE_START`, the model's start arguments as a JSON array that loads the entry and ends in the command text, with `{command}` where
the test's command goes (ADR-AUTO-GO#3, ADR-AUTO-PY#3, ADR-AUTO-BASH#3). Every Go and Python black-box test runs once per engine, titled
`<test> [<engine>]`, unchanged between them.

- [The black-box contract](#the-black-box-contract)

### Rule ADR-AUTO-ENGINE:5

A behaviour that differs between the engines is tested side by side, in a per-engine fixture table: one row per case, one column per engine,
every column filled or naming why the case does not apply (`n/a: <reason>`). The tables live at
`<module>/tests/assets/engine-cases/<subject>.yml`, loaded by `Get-EngineCaseTable`, and their columns are the engines of the model.

- [Fixture tables per engine](#fixture-tables-per-engine)

### Rule ADR-AUTO-ENGINE:6

Each engine reaches catzc through its importer entry at the repository root. bash's is `importer.sh`, a generated, committed root file that
must be sourced and defines one dispatcher, `cats`: with no arguments it lists the catzc commands; otherwise it runs its first argument as a
catzc command in pwsh with the PowerShell entry loaded — `CATZC_IMPORTER`, else the repository's `importer.ps1` — passing an argument that
starts with `-` as a parameter name and every other argument as one PowerShell literal. The model's `CommandPrefix` (`cats ` for bash, none
for pwsh) is how a command text reaches catzc in that engine, so one test's command text is the same under both.

- [The cats dispatcher](#the-cats-dispatcher)

## Context

PowerShell is the engine every module runs under. Bash is the second: it is the shell the Claude Code agents run commands in, the shell of
every Linux CI agent, and the shell `importer.sh` brings the repository's commands to. Before this decision the difference between the two
lived wherever someone needed it: a `pwsh -NoProfile -Command` string in each black-box test, a `"bash", "pwsh"` list in each config type
that keys a setting per shell, a quote rule in each place that built a command line. Each copy was a place to get the other engine wrong,
and nothing kept the copies in step.

### Two engines

There are two engines and the set is closed. A third would mean a third set of quoting, strict-mode, and start rules for everything the
repository runs; it is a decision for this ADR, not a value someone adds to a list. So the list lives in one place, `ExecutionEngines`, and
every other list is read from it. `ExecutionEngine` has no public constructor: the model's two instances are the only engines there are.

### One model of what differs

The model is data with a few small methods, in C# so every module and every config type can read it with no PowerShell call. What it
declares:

| Property                   | pwsh                             | bash                               |
| -------------------------- | -------------------------------- | ---------------------------------- |
| executable, located by     | `pwsh`, beside `$PSHOME`         | `bash`, its `tools.yml` entry      |
| script extensions          | `.ps1`, `.psm1`                  | `.sh`                              |
| shebang                    | —                                | `#!/usr/bin/env bash`              |
| non-interactive start      | `-NoProfile -NonInteractive`     | `--noprofile --norc`               |
| command flag               | `-Command`                       | `-c`                               |
| a quote in a literal       | `''`                             | `'\''`                             |
| loading an entry, silently | `. '<entry>' *> $null`           | `source '<entry>' >/dev/null 2>&1` |
| strict mode                | `Set-StrictMode -Version Latest` | `set -euo pipefail`                |
| time safeguard             | `Invoke-WithTimeout`             | `timeout`                          |
| line endings, exec bit     | any, none                        | LF, required                       |
| importer entry             | `importer.ps1`                   | `importer.sh`                      |
| command prefix             | —                                | `cats `                            |

`StartArguments(entry, command)` composes the start from these: the non-interactive arguments, the command flag, then one command text that
loads the entry and runs the command, behind the engine's command prefix.

The Pester workers, the isolated test runs, and the snapshot priming start pwsh too, but they are not engine-neutral: Pester is a PowerShell
framework, so those starts are pwsh by nature and stay so.

### Locating an engine

The engine a test starts should be the engine the caller runs, so pwsh comes from `$PSHOME`, the folder of the running PowerShell, rather
than from `PATH`, where an older or a second PowerShell may come first. Bash has no such anchor: it is a tool, declared in `tools.yml` with
sensible defaults per platform (Git Bash on Windows, the system bash elsewhere) and found by the existence check, which excludes the WSL
launcher that would run a different system's bash.

### The black-box contract

A Go or Python test starts the engine as a process. It used to build that start itself —
`pwsh -NoProfile -Command ". '<entry>' *> $null; <command>"`, with PowerShell's quoting rule copied into Go and Python. Now the runner hands
it the start: the executable, and the arguments from the model with the entry already quoted in the engine's own rule and `{command}` where
the test's command goes. The test fills in its command and runs the process. The same test therefore runs under any engine the runner names,
with no change to the test, which is what running the black-box tests under bash needs. The runner names the engine through `CATZC_ENGINE`
and the file that loads catzc into it through `CATZC_ENGINE_ENTRY`; for bash it also sets `CATZC_IMPORTER`, the PowerShell entry `cats`
loads, which is the build's entry in a build run.

### Fixture tables per engine

A rule that differs between engines is easiest to get wrong for the engine nobody looked at. A per-engine fixture table puts both answers
next to each other, case by case, and a case that does not apply to one engine says why instead of being silently missing. The engine start
and the engine locator are tested that way (`Catzc.Base.Engines/tests/assets/engine-cases/`), as is the time-safeguard grammar
(`Catzc.Base.Timeouts`).

### The cats dispatcher

catzc's commands are PowerShell functions, so a Bash session cannot call them directly. Rather than one Bash wrapper per command, which
would be a second copy of every command's surface, `importer.sh` defines one dispatcher, `cats`, the name the system goes by in prose:
`cats Get-RepositoryRoot` runs that command in pwsh, with catzc imported and its import output discarded. It quotes every value argument as
a PowerShell literal, so a value with a space or a quote stays one value, and passes `-Name` arguments through as parameter names. It finds
the repository from its own path, in the form pwsh reads (`cygpath -m` under Git Bash), and runs under zsh as well as bash. Each call starts
a fresh pwsh and pays the import, which suits a command or a test, not a loop: for many commands in a row, start pwsh.

`importer.sh` is a root-config file, generated from its source in `Catzc.Base.RootConfig` and committed so a fresh clone has it; it is LF,
as every `*.sh` is, and checked by `Test-ShellScripts` (ADR-AUTO-BASH#6). Bash tests call catzc exactly this way
([bash test artifacts](bash/bash-test-artifacts.md)).

## Decision

The repository runs its own code under two execution engines, declared once (ADR-AUTO-ENGINE#1), with everything that differs between them
declared once on the model (ADR-AUTO-ENGINE#2), located the way the model says (ADR-AUTO-ENGINE#3), started by black-box tests from the
contract their runner sets (ADR-AUTO-ENGINE#4), tested side by side in per-engine fixture tables (ADR-AUTO-ENGINE#5), and reached from bash
through `importer.sh` and its `cats` dispatcher (ADR-AUTO-ENGINE#6).

### How this is enforced

- **`ExecutionEngines`** (`Catzc.Base.Engines`) is the only place the engines are constructed; `Get-ExecutionEngine` returns them.
- **`Resolve-EngineExecutable`** (`Catzc.Base.Execution`) locates an engine's executable by its model.
- **`Get-EngineContract`** (`Catzc.Base.Languages`) builds the black-box contract `Invoke-GoTest`, `Invoke-PythonTest` and `Invoke-BashTest`
  set, and the language bridge runs every Go and Python test once per engine.
- **`importer.sh`** is a generated root-config file (`Build-RootConfig`, drift-checked by `Test-GeneratedFiles`), and the Bash tests
  exercise its `cats` dispatcher in both run modes.
- **The fixture tables** `engine-start.yml` and `engine-locator.yml` check the model under both engines, and the shape of every engine case
  table in the repository is checked by an integrity test.

## Consequences

- A new place that needs an engine difference reads it from the model; a fix to a quote rule or a start flag is one edit.
- The black-box tests are engine-neutral: they run under both engines, unchanged.
- A Bash user gets every catzc command through one dispatcher, at the cost of a pwsh start and an import per call.
- The model is a dependency of the modules below `Catzc.Base.Execution` that key settings per shell, so it sits in its own foundation
  module, `Catzc.Base.Engines`, with no dependencies of its own.
