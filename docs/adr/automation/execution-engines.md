---
catzc:
  derived:
    path: docs/adr/automation/execution-engines.md
    kind: adr
    language: markdown
    filekind: md
    track: docs
    body_sha: "9f2c295bbc83"
    defines:
      - ADR-AUTO-ENGINE#{1-7}
    adrs:
      - ADR-AUTO-BASH#{3,6}
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-DEPS#3
      - ADR-AUTO-GO#3
      - ADR-AUTO-PARITY#1
      - ADR-AUTO-PY#3
    links:
      - docs/adr/automation/bash/bash-test-artifacts.md
---

# ADR: Execution engines — pwsh, bash and zsh, declared once

## Rules: ADR-AUTO-ENGINE

### Rule ADR-AUTO-ENGINE:1

An **execution engine** is a shell the repository's own code runs under, and there are exactly three: pwsh, bash and zsh, where pwsh is
PowerShell 7. They are declared once, in the `ExecutionEngines` model (`Catzc.Base.Engines`); every list of engines in the codebase — config
keys per shell, the columns of a per-engine fixture table, an engine argument's allowed values — is that model's `Names`, never a restated
literal list. The set is closed: a fourth engine is a decision for this ADR, not a value added to a list.

- [Three engines](#three-engines)

### Rule ADR-AUTO-ENGINE:2

Everything that differs between the engines is a property of its `ExecutionEngine`, declared once: how its executable is named and located,
the script files it runs, its shebang, its non-interactive start, how it loads an entry script and runs a command (`StartArguments`), its
quoting, its strict mode, its time safeguard, the line endings and executable bit its scripts need, its importer entry, and its command
prefix. A caller reads the property; it never restates a flag, a quote rule, or a file name.

- [One model of what differs](#one-model-of-what-differs)

### Rule ADR-AUTO-ENGINE:3

An engine's executable is located the way its model says, by `Resolve-EngineExecutable`: pwsh from the home folder of the running
PowerShell, so a started engine is the caller's own PowerShell and never another one first on `PATH`; each POSIX engine (ADR-AUTO-ENGINE#6)
through its `tools.yml` entry and the existence check (ADR-AUTO-DEPS#3), never the WSL launcher.

- [Locating an engine](#locating-an-engine)

### Rule ADR-AUTO-ENGINE:4

A black-box test in another language starts the engine from the contract its runner sets, never from a hardcoded command: `CATZC_ENGINE`
(the engine's name), `CATZC_ENGINE_EXECUTABLE`, `CATZC_ENGINE_ENTRY` (the script that loads catzc into the engine), and
`CATZC_ENGINE_START`, the model's start arguments as a JSON array that loads the entry and ends in the command text, with `{command}` where
the test's command goes (ADR-AUTO-GO#3, ADR-AUTO-PY#3, ADR-AUTO-BASH#3). Every Go and Python black-box test runs once per engine, three runs
titled `<test> [pwsh]`, `<test> [bash]` and `<test> [zsh]`, unchanged between them.

- [The black-box contract](#the-black-box-contract)

### Rule ADR-AUTO-ENGINE:5

A behaviour that differs between the engines is tested side by side, in a per-engine fixture table: one row per case, one column per engine
— pwsh, bash and zsh — every column filled or naming why the case does not apply (`n/a: <reason>`). The tables live at
`<module>/tests/assets/engine-cases/<subject>.yml`, loaded by `Get-EngineCaseTable`, and their columns are the engines of the model.

- [Fixture tables per engine](#fixture-tables-per-engine)

### Rule ADR-AUTO-ENGINE:6

Each engine reaches catzc through its importer entry at the repository root. The **POSIX engine**s are the engines whose importer entry is
`importer.sh`, read from the model's `ImporterEntry` and never listed; they share that one generated, committed root file, which each of
them loads into its session, and there is no copy per shell. It defines one dispatcher, `cats`: with no arguments it lists the catzc
commands; otherwise it runs its first argument as a catzc command in pwsh with the PowerShell entry loaded — `CATZC_IMPORTER`, else pwsh's
own importer entry at the repository root — passing an argument that starts with `-` as a parameter name and every other argument as one
PowerShell literal. The model's `CommandPrefix` (`cats` and a space for the POSIX engines, none for pwsh) is how a command text reaches
catzc in that engine, so one test's command text is the same under every engine.

- [The cats dispatcher](#the-cats-dispatcher)

### Rule ADR-AUTO-ENGINE:7

**auto** is the engine value that names no particular engine: a setting or argument that says `auto` takes whatever engine its sensible
default resolves to (ADR-AUTO-DEFAULT#6), and names pwsh, bash or zsh only when it needs that one. `auto` is not a fourth engine and never
appears in the model's `Names`; it is a choice left open.

- [Leaving the engine open](#leaving-the-engine-open)

## Context

PowerShell is the engine every module runs under. Bash is the shell the Claude Code agents run commands in, the shell of every Linux CI
agent, and the shell `importer.sh` brings the repository's commands to. zsh is the default login shell on macOS and the interactive shell of
many developers elsewhere, so a user's own terminal reaches catzc from it as often as from bash. What differs between the engines, left to
each place that needs it, becomes a `pwsh -NoProfile -Command` string in each black-box test, a `"bash", "pwsh"` list in each config type
that keys a setting per shell, and a quote rule in each place that builds a command line. Each copy is a place to get another engine wrong,
and nothing keeps the copies in step.

### Three engines

There are three engines and the set is closed. Another engine means another set of quoting, strict-mode, and start rules for everything the
repository runs; it is a decision for this ADR, not a value someone adds to a list. So the list lives in one place, `ExecutionEngines`, and
every other list is read from it. `ExecutionEngine` has no public constructor: the model's three instances are the only engines there are.

zsh earns its place beside bash because it is where a macOS user types, and because it costs little: it shares bash's POSIX quoting, its GNU
`timeout` safeguard, its LF and executable-bit needs, and its importer entry, so most of its column repeats bash's and the model states the
few differences once.

### One model of what differs

The model is data with a few small methods, in C# so every module and every config type can read it with no PowerShell call. What it
declares:

| Property                   | pwsh                             | bash                               | zsh                                  |
| -------------------------- | -------------------------------- | ---------------------------------- | ------------------------------------ |
| executable, located by     | `pwsh`, beside `$PSHOME`         | `bash`, its `tools.yml` entry      | `zsh`, its `tools.yml` entry         |
| script extensions          | `.ps1`, `.psm1`                  | `.sh`                              | `.zsh`                               |
| shebang                    | —                                | `#!/usr/bin/env bash`              | `#!/usr/bin/env zsh`                 |
| non-interactive start      | `-NoProfile -NonInteractive`     | `--noprofile --norc`               | `-f` (no startup files)              |
| command flag               | `-Command`                       | `-c`                               | `-c`                                 |
| a quote in a literal       | `''`                             | `'\''`                             | `'\''`                               |
| loading an entry, silently | `. '<entry>' *> $null`           | `source '<entry>' >/dev/null 2>&1` | `source '<entry>' >/dev/null 2>&1`   |
| strict mode                | `Set-StrictMode -Version Latest` | `set -euo pipefail`                | `setopt ERR_EXIT NO_UNSET PIPE_FAIL` |
| time safeguard             | `Invoke-WithTimeout`             | `timeout`                          | `timeout`                            |
| line endings, exec bit     | any, none                        | LF, required                       | LF, required                         |
| importer entry             | `importer.ps1`                   | `importer.sh`                      | `importer.sh`                        |
| command prefix             | —                                | `cats` and a space                 | `cats` and a space                   |

`StartArguments(entry, command)` composes the start from these: the non-interactive arguments, the command flag, then one command text that
loads the entry and runs the command, behind the engine's command prefix.

A setting keyed per shell takes a key for every engine. The time limits (`timeouts.yml`) give zsh one limit per environment with the
pwsh-side defaults, because the Bash hook governs the Bash tool only; bash keeps its foreground and background limits for the hook.

The Pester workers, the isolated test runs, and the snapshot priming start pwsh too, but they are not engine-neutral: Pester is a PowerShell
framework, so those starts are pwsh by nature and stay so.

### Locating an engine

The engine a test starts should be the engine the caller runs, so pwsh comes from `$PSHOME`, the folder of the running PowerShell, rather
than from `PATH`, where an older or a second PowerShell may come first. The POSIX engines have no such anchor: each is a tool, declared in
`tools.yml` with sensible defaults per platform and found by the existence check, which excludes the WSL launcher that would run a different
system's shell. On Windows the bash engine is Git Bash's, and zsh is the MSYS2 package installed into Git Bash's tree in user space
(`Install-Zsh`), so the POSIX engines share one runtime and one code path (ADR-AUTO-PARITY#1); elsewhere each is the system's own.

### The black-box contract

A Go or Python test starts the engine as a process. A test that builds that start itself —
`pwsh -NoProfile -Command ". '<entry>' *> $null; <command>"`, with PowerShell's quoting rule copied into Go and Python — runs under one
engine only. So the runner hands it the start: the executable, and the arguments from the model with the entry quoted in the engine's own
rule and `{command}` where the test's command goes. The test fills in its command and runs the process. The same test therefore runs under
any engine the runner names, with no change to the test, which is what running each black-box test under all three engines needs. The runner
names the engine through `CATZC_ENGINE` and the file that loads catzc into it through `CATZC_ENGINE_ENTRY`; for the POSIX engines it also
sets `CATZC_IMPORTER`, the PowerShell entry `cats` loads, which is the build's entry in a build run.

### Fixture tables per engine

A rule that differs between engines is easiest to get wrong for the engine nobody looked at. A per-engine fixture table puts every answer
next to the others, case by case, and a case that does not apply to one engine says why instead of being silently missing. The engine start
and the engine locator are tested that way (`Catzc.Base.Engines/tests/assets/engine-cases/`), as is the time-safeguard grammar
(`Catzc.Base.Timeouts`).

### Verifying zsh

Two of bash's checks do not reach zsh, so zsh is verified another way:

- **ShellCheck does not analyse zsh.** The shell-script checks give a `*.zsh` file the LF and executable-bit checks and a `zsh -n` syntax
  check in place of ShellCheck (ADR-AUTO-BASH#6).
- **bats is bash-only.** zsh is verified through the per-engine Go and Python black-box runs (ADR-AUTO-ENGINE#4) and the engine-case tables
  (ADR-AUTO-ENGINE#5), not through bats.

### The cats dispatcher

catzc's commands are PowerShell functions, so a session in a POSIX engine cannot call them directly. Rather than one shell wrapper per
command, which would be a second copy of every command's surface, `importer.sh` defines one dispatcher, `cats`, the name the system goes by
in prose: `cats Get-RepositoryRoot` runs that command in pwsh, with catzc imported and its import output discarded. It quotes every value
argument as a PowerShell literal, so a value with a space or a quote stays one value, and passes `-Name` arguments through as parameter
names. It finds the repository from its own path, in the form pwsh reads (`cygpath -m` under Git Bash), and runs under every POSIX engine
alike, so they share one importer rather than each keeping a copy. Each call starts a fresh pwsh and pays the import, which suits a command
or a test, not a loop: for many commands in a row, start pwsh.

`importer.sh` is a root-config file, generated from its source in `Catzc.Base.RootConfig` and committed so a fresh clone has it; it is LF,
as every `*.sh` is, and checked by `Test-ShellScripts` (ADR-AUTO-BASH#6). Bash tests call catzc exactly this way
([bash test artifacts](bash/bash-test-artifacts.md)).

### Leaving the engine open

Most work does not care which engine runs it; it only needs one. Naming pwsh, bash or zsh where any would do pins a choice the caller never
made, and the pin outlives the reason. So a setting or argument that takes an engine accepts `auto`, the value that leaves the choice open:
the caller gets whatever engine the setting's sensible default resolves to, declared once on its config type (ADR-AUTO-DEFAULT#6). Naming an
engine is for work that needs that one. `auto` is a value, not an engine: the model's three instances stay the only engines there are.

## Decision

The repository runs its own code under three execution engines, declared once (ADR-AUTO-ENGINE#1), with everything that differs between them
declared once on the model (ADR-AUTO-ENGINE#2), located the way the model says (ADR-AUTO-ENGINE#3), started by black-box tests from the
contract their runner sets (ADR-AUTO-ENGINE#4), tested side by side in per-engine fixture tables (ADR-AUTO-ENGINE#5), and reached from the
POSIX engines through `importer.sh` and its `cats` dispatcher (ADR-AUTO-ENGINE#6).

### How this is enforced

- **`ExecutionEngines`** (`Catzc.Base.Engines`) is the only place the engines are constructed; `Get-ExecutionEngine` returns them.
- **`Resolve-EngineExecutable`** (`Catzc.Base.Execution`) locates an engine's executable by its model.
- **`Get-EngineContract`** (`Catzc.Base.Languages`) builds the black-box contract `Invoke-GoTest`, `Invoke-PythonTest` and `Invoke-BashTest`
  set, and the language bridge runs every Go and Python test once per engine.
- **`importer.sh`** is a generated root-config file (`Build-RootConfig`, drift-checked by `Test-GeneratedFiles`), and the Bash tests
  exercise its `cats` dispatcher in both run modes.
- **The fixture tables** `engine-start.yml` and `engine-locator.yml` check the model under every engine, and the shape of every engine case
  table in the repository, a column per engine, is checked by an integrity test.

## Consequences

- A new place that needs an engine difference reads it from the model; a fix to a quote rule or a start flag is one edit.
- The black-box tests are engine-neutral: they run under all three engines, unchanged, so a Go or Python test costs three runs.
- A user of a POSIX engine gets every catzc command through one dispatcher, at the cost of a pwsh start and an import per call.
- zsh needs its own install on Windows and its own syntax check in place of ShellCheck; in return its column mostly repeats bash's.
- The model is a dependency of the modules below `Catzc.Base.Execution` that key settings per shell, so it sits in its own foundation
  module, `Catzc.Base.Engines`, with no dependencies of its own.
