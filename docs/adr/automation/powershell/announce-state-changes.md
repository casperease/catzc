# docs/adr/automation/powershell/announce-state-changes.md

`ADR: Announce every state change on the information stream`

## Rules: ADR-AUTO-ANNOUNCE

### Rule ADR-AUTO-ANNOUNCE:1

Every write to the console goes through the information stream, by way of the writer chokepoint: `Write-Message` →
`Write-InformationColored` → `Write-Information`, or the bootstrap's `Write-ImporterMessage` before the Writers module is loaded. Nothing
calls `Write-Host`, `Out-Host`, `Write-Progress`, `Clear-Host`, a `[Console]` write method, or a `$Host.UI` writer, and nothing assigns a
console property (title, colour, cursor, encoding). An inline liveness dot is `Write-Message '.' -NoHeader -NoNewline`.

- [One stream](#one-stream)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-ANNOUNCE:2

Every lasting change a function makes to the state of the session is announced on the information stream, where it happens, naming what
changed and to what. The session's state is its environment variables (`PATH` and `PSModulePath` included), the binaries and assemblies
loaded into it, the modules imported into or removed from it, its global variables and preferences, its working location, its line editor
and its type and format data, plus the user environment and profile it reads at start. Announce when something actually changes; a converge
that finds everything in place changes nothing and says nothing.

- [What counts as a state change](#what-counts-as-a-state-change)
- [Announce where it happens](#announce-where-it-happens)

### Rule ADR-AUTO-ANNOUNCE:3

A change that is not a lasting change of this session is not announced: a change the function restores before it returns (in a `finally`
block), a change made in another runspace or process (a job, a parallel `ForEach-Object`), PowerShell's own `$LASTEXITCODE`, the toolset's
private `$global:__<Name>` bookkeeping, and the state a test sets and restores around itself.

- [Not a state change](#not-a-state-change)

### Rule ADR-AUTO-ANNOUNCE:4

A child process's own output is the tool speaking (ADR-AUTO-CONSOLE#4): it is relayed to the console as it streams, not re-written through
the chokepoint. Only what the toolset itself says goes through the information stream.

- [Child-process output](#child-process-output)

### Rule ADR-AUTO-ANNOUNCE:5

When a change is announced by a function other than the one that makes it — because the changing function runs before any writer exists, or
because its caller owns the wording, such as one that masks a secret — the changing function carries a `SuppressMessageAttribute` for
`Measure-AnnounceStateChange` whose justification names where the announcement happens.

- [Delegated announcements](#delegated-announcements)

### Rule ADR-AUTO-ANNOUNCE:6

The importer's own load sequence is the one exception to ADR-AUTO-ANNOUNCE#2: the state changes it makes itself (session preferences, roots,
vendor modules, `PSModulePath`, the types assembly, the catzc modules) are announced on the verbose stream through
`Write-ImporterMessage -StateChange`, shown by `. .\importer.ps1 -Verbose`. A plain import shows only its `Loaded in N seconds` line and
genuine warnings. The functions the importer calls announce on the information stream as everywhere else.

- [The importer's load record](#the-importers-load-record)

## Context

The console session is where the user works. Dot-sourcing `importer.ps1` into it loads modules and a compiled types assembly, sets
preferences, moves `PATH` entries, and points environment variables at tool homes; an installer rewrites `PATH` and the user environment; a
quality gate lazy-loads Pester. Each of these changes what the next command in that session does. When they happen silently, the user is
left with questions the scrollback cannot answer: why does `dotnet` resolve from this folder, which build of the types is loaded, where did
this `PSModulePath` entry go. The only way to find out is to read source or re-run with diagnostics, which is exactly what
[console-output-matters](console-output-matters.md) rules out: a reader understands what happened by reading the output once, top to bottom.

So the scrollback is made a complete record of how the session reached its state. Every change is announced as it happens, with the value it
set, and every announcement travels the same stream as every other line the toolset writes.

### One stream

`One stream for everything the console shows`

The information stream is the one channel the toolset writes to the console through, because it is the one that stays in the caller's
control. A record on it obeys `$InformationPreference` and `-InformationAction`, can be redirected with `6>` or captured with `6>&1` and
`-InformationVariable`, and never enters the pipeline, so a function's return value stays clean. `Write-Host` emits on the same stream but
always renders, whatever the preference says. A `[Console]` or `$Host.UI` write goes around PowerShell's streams entirely: it cannot be
redirected, captured, or silenced.

Routing every write through one chokepoint gives three guarantees at one place. The output is controllable, as above. It is silent during a
Pester run, because `Write-InformationColored` returns before writing while `$global:__PesterRunning` is set, so no writer leaks into test
output and no test needs its own guard. And it is headed with its caller (`[Invoke-Importer] ...`), so every line names the function that
wrote it.

The one thing a raw write offers is a dot without a line break, which a liveness signal needs (ADR-AUTO-CONSOLE#8). The chokepoint offers
that too: `-NoNewline` wraps the text in a `HostInformationMessage` with `NoNewLine` set, the same record `Write-Host` emits internally, so
the host renders it inline while it stays an ordinary information record. A dot written from a background thread job uses the same writer:
the job streams to the caller's host (`Start-ThreadJob -StreamingHost`) and imports the loaded Writers module, so its dots behave like a
`Write-Message` on the calling thread. An Azure DevOps logging command is no exception either. The host renders an information record to
stdout exactly as it renders `Write-Host`, which is where the agent reads `##vso` commands, and a test run silences it with everything else.

### What counts as a state change

A state change is anything that makes a later command in the same session behave differently:

| State                                         | Changed by                                                                                         |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Environment variables, `PATH`, `PSModulePath` | `$env:<Name> = ...`, `[Environment]::SetEnvironmentVariable`, `Set-Item` / `Remove-Item` on `env:` |
| Loaded binaries                               | `Add-Type` (loading), `[Reflection.Assembly]::Load*`, `AssemblyLoadContext.LoadFromAssemblyPath`   |
| Loaded modules                                | `Import-Module`, `Remove-Module`                                                                   |
| Global variables and preferences              | `$global:<Name> = ...`, `Set-Variable -Scope Global`                                               |
| Working location                              | `Push-Location`, `Pop-Location`                                                                    |
| Line editor, type and format data             | `Set-PSReadLineOption`, `Set-PSReadLineKeyHandler`, `Update-TypeData`, `Update-FormatData`         |
| What the next session starts with             | the user and machine environment, the PowerShell profile                                           |

Loading a binary is a state change like any other, and the clearest case for announcing one: a .NET assembly cannot be unloaded, so the
build the session holds decides which types every later call sees until the process ends. The importer therefore names the assembly it loads
(`Loaded types automation/.compiled/Catzc.Types.<hash>.dll`), the vendor modules it imports, and the modules it loads, evicts, or drops, on
its verbose load record (ADR-AUTO-ANNOUNCE#6).

Writing a file in the repository is not a session state change; the repository's own rules govern those. The user and machine environment
and the profile are the exception, because they are what the next session starts from: changing them is changing the console the user opens
tomorrow.

### Announce where it happens

The announcement sits in the block that makes the change, so it runs exactly when the change runs. A line printed in an unrelated branch, an
`if ($DiagnoseLoadTime)` timing line for example, does not announce a change made outside that branch, because a plain run would make the
change and print nothing. The line names the target and the value: `Session PATH: prepended 'C:\...\dotnet'`,
`User environment: JAVA_HOME='...'`, `Loaded vendor module powershell-yaml 0.4.12`. A function that makes several related changes may
announce them on one line built as it goes, and a function that only converges announces the changes it actually made: an installer re-run
on a box that already has the right `JAVA_HOME` writes nothing and says nothing. That keeps this rule consistent with ADR-AUTO-CONSOLE#5: a
state change is always worth reporting, and a no-op is not a change.

`-Verbose` does not announce. A state change is a fact about the session, and the always-on information stream is where facts go; the
verbose stream is for the diagnostic detail behind them (ADR-AUTO-CONSOLE#2). The importer's own load record is the one exception
([below](#the-importers-load-record)).

### Not a state change

`What is not a state change of this session`

Some changes leave the session as they found it, or never touch it, and announcing them would be noise:

- **Restored before return.** A function that sets a variable for the duration of a call and restores it in `finally` (a scoped
  `Write-EnvironmentSet`, `Push-Location` paired with `Pop-Location`) leaves no lasting change.
- **Another runspace or process.** A scriptblock handed to `Start-Job`, `Start-ThreadJob` or `ForEach-Object -Parallel` changes its own
  runspace, not the caller's.
- **PowerShell's own bookkeeping.** `$LASTEXITCODE` is the automatic variable PowerShell sets after every native call; mirroring it is not a
  change the toolset makes.
- **The toolset's private bookkeeping.** A `$global:__<Name>` variable (the types load registry, the load-time collector, the test-run flag)
  crosses module scopes for the toolset's own use. The state it records is announced where that state changes.
- **Tests.** A test sets state on purpose and restores it in `AfterEach`/`AfterAll`, and its output belongs to Pester.

### Child-process output

`Child-process output is relayed, not re-written`

When the toolset runs an external tool, the tool's output streams to the console as it arrives (ADR-AUTO-CONSOLE#4), and a parallel test
runner relays each worker's output the same way. That output is the child's own bytes, never a PowerShell record, so the C# relays
(`Invoke-ExecutableStreamed`'s runner, the Pester worker pool) write it to the console directly, saving and restoring the console encoding
around the run. The command that started the child is announced before it runs ([log-before-invoke](../log-before-invoke.md)); the relay
honours the same Pester-run flag as the chokepoint.

### Delegated announcements

Two situations put the announcement in a different function from the change. The importer's loader runs before any writer is loaded, so the
importer announces the roots and internal modules on its own `Roots:` line, the first point a writer exists. And a thin I/O seam whose
caller owns the wording, such as the process-environment seam behind `Write-EnvironmentSet`, which masks secrets as `***`, would print the
plaintext secret if it announced its own writes. The changing function then carries a `SuppressMessageAttribute` for
`Measure-AnnounceStateChange` whose justification names where the announcement happens, so a reader of either function finds the other.

### The importer's load record

`The importer's load record is verbose`

`. .\importer.ps1` runs at the start of every session and makes the same expected changes each time: it sets the preferences, anchors the
roots, imports the vendor modules, prepends the vendor root to `PSModulePath`, loads the types assembly, and loads the catzc modules.
Printing those lines at every shell open is noise (ADR-AUTO-CONSOLE#5), so they are written with `Write-ImporterMessage -StateChange`, which
puts them on the verbose stream. A plain import shows one `Loaded in N seconds (...)` line, plus anything that actually needs attention: a
warning, `Built <dll>` for a freshly compiled assembly to commit, the stale-types notice, and the `-DiagnoseLoadTime` timings.
`. .\importer.ps1 -Verbose` shows the full record.

The shim is an advanced script so that it accepts `-Verbose`. Dot-sourced, it sets the preference in the caller's scope for the length of
the import, and PowerShell restores it afterwards. `-Verbose` reaches Invoke-Importer, but not the bootstrap and vendor module functions
that make the changes, so Invoke-Importer hands it to the bootstrap writer with `Set-ImporterVerbosity`. The setting lives in the bootstrap
module and goes away with it. While the import runs, Invoke-Importer quiets the session-wide preference and restores it in a `finally`
(ADR-AUTO-ANNOUNCE#3), so `-Verbose` shows the load record rather than every function each `Import-Module` dot-sources and exports.

The exception covers only the importer's own load. The functions it calls, such as the janitors that adjust `PATH`, are ordinary public
functions and announce on the information stream like any other caller's. A clean devbox gives them nothing to report.

## Decision

Every write to the console goes through the information stream via the writer chokepoint, and every lasting change to the session's state is
announced there, where it happens, naming what changed and to what. Changes that are restored, made elsewhere, or private bookkeeping are
not announced; child-process output is relayed as the tool's own; a delegated announcement is recorded with a justified suppression.

### How this is enforced

- **`Measure-NoRawConsoleWrite`** (`automation/.scriptanalyzer/NoRawConsoleWrite.psm1`) flags every way past the information stream:
  `Write-Host`, `Out-Host`, `Write-Progress`, `Clear-Host`, the `[Console]` write methods and property assignments, writes through
  `[Console]::Out`/`Error`, and the `$Host.UI` writers. It supersedes the built-in `PSAvoidUsingWriteHost`, which the analyzer settings
  exclude so a `Write-Host` is reported once.
- **`Measure-AnnounceStateChange`** (`automation/.scriptanalyzer/AnnounceStateChange.psm1`) flags a state change of the kinds in the table
  above that no information-stream writer (or `Write-ImporterMessage -StateChange`, ADR-AUTO-ANNOUNCE#6) in the same or an enclosing block
  announces, and passes the exemptions of ADR-AUTO-ANNOUNCE#3. It checks that a change is announced; what the line says is a review concern.
- **`Measure-NoRawInformationStream`** keeps `Write-Information` inside the two chokepoint functions, `Write-InformationColored` and
  `Write-ImporterMessage`.
- **`Write-Message -NoNewline`** provides the inline dot, so no liveness signal needs a raw write.
- **Code review** checks the wording: an announcement names the target and its new value, and a suppression's justification names where the
  delegated announcement happens.

## Consequences

- The scrollback of a session is a complete record of how it reached its state: which modules and which types build it loaded, which `PATH`
  entries moved and why, which variables an installer set.
- Every console line can be silenced, redirected, or captured by the caller, and none leaks into test output.
- A plain import shows one line. Its full record, naming the session settings, the roots, the vendor and catzc modules, and the types
  assembly it loads, is one `-Verbose` away; each line states a fact the session now depends on.
- A new state-changing function cannot land unannounced; the analyzer names the change and the function.
