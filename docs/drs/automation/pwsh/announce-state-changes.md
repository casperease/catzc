# PowerShell: Announce every state change on the information stream

## Rules: ADR-PWSH-ANNOUNCE

### Rule ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT

Every write to the console goes through the information stream, by way of the writer chokepoint: `Write-Message` →
`Write-InformationColored` → `Write-Information`, or the loader's `Write-ImporterMessage` before the Writers module is loaded. Nothing calls
`Write-Host`, `Out-Host`, `Write-Progress`, `Clear-Host`, a `[Console]` write method, or a `$Host.UI` writer, and nothing assigns a console
property (title, colour, cursor, encoding). The one exception is the output encoding of a redirected session: the importer sets it to UTF-8
(`Set-RedirectedOutputEncoding`), so a captured log carries one encoding, and announces it on its load record
(ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE). An inline liveness dot is `Write-Message '.' -NoHeader -NoNewline`.

- [One stream](#one-stream)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-ANNOUNCE-CHILDOUTPUTRELAYED

In pwsh, the relay ADR-AUTO-CONSOLE-TOOLSSPEAK requires bypasses the chokepoint: a child process's bytes never become a PowerShell record,
and the C# relays (`Invoke-ExecutableStreamed`'s runner, the Pester worker pool) write them to the console directly as they arrive, save and
restore the console encoding around the run, and honour the Pester-run flag. Only what the toolset itself says goes through the information
stream.

- [Child-process output](#child-process-output)

### Rule ADR-PWSH-ANNOUNCE-ANNOUNCEDBYCALLER

When a change is announced by a function other than the one that makes it — because the changing function runs before any writer exists, or
because its caller owns the wording, such as one that masks a secret — the changing function carries a `SuppressMessageAttribute` for
`Measure-AnnounceStateChange` whose justification names where the announcement happens.

- [Delegated announcements](#delegated-announcements)

### Rule ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE

The importer's own load sequence is the load-sequence exception of ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES: the state changes it makes
itself (session preferences, a redirected session's output encoding, roots, vendor modules, `PSModulePath`, the types assembly, the catzc
modules) are announced on the verbose stream through `Write-ImporterMessage -StateChange`, shown by `. .\importer.ps1 -Verbose`. A plain
import shows only its `Loaded in N seconds` line and genuine warnings. The functions the importer calls announce on the information stream
as everywhere else; the session-tool janitor's `PATH` nudges and its advisory recur at every shell open, so the importer runs that janitor
with its information stream shown only under the same `-Verbose`.

- [The importer's load record](#the-importers-load-record)

### Rule ADR-PWSH-ANNOUNCE-CORRECTSTREAM

Use the correct stream: `Write-Message` for status one-liners, `Write-Message -NoHeader` for multiline/tables, `Write-Verbose` for debugging
detail, `Write-Output` only for return values — and never `Write-Warning`/`Write-Error` (both terminate).

- [The output hierarchy](#the-output-hierarchy)

### Rule ADR-PWSH-ANNOUNCE-INFORMATIONRECORD

In pwsh, the announcement ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES requires is an information-stream record written through the chokepoint
(ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT), never a `Write-Verbose` line. The session state it covers is what the commands in the
[state-change table](#what-counts-as-a-state-change) change: `$env:` and `PSModulePath`, `Add-Type` and the assembly loaders,
`Import-Module`/`Remove-Module`, `$global:` variables and preferences, `Push-Location`/`Pop-Location`, the PSReadLine options and key
handlers, `Update-TypeData`/`Update-FormatData`, and the user and machine environment and the PowerShell profile.

- [What counts as a state change](#what-counts-as-a-state-change)
- [Announce where it happens](#announce-where-it-happens)

### Rule ADR-PWSH-ANNOUNCE-UNANNOUNCEDCHANGES

In pwsh, the changes ADR-AUTO-CONSOLE-SILENTTRANSIENTCHANGES leaves unannounced are: a change restored in a `finally` block before the
function returns; a change inside `Start-Job`, `Start-ThreadJob`, or `ForEach-Object -Parallel`; PowerShell's own `$LASTEXITCODE`; the
toolset's private `$global:__<Name>` bookkeeping; and the state a Pester test sets and restores in `AfterEach`/`AfterAll`.

- [Not a state change](#not-a-state-change)

### Rule ADR-PWSH-ANNOUNCE-NATIVETOOLCOMMAND

In pwsh, a native tool runs through `Invoke-Executable`, which writes the resolved command with `Write-Message` before it starts the process
(ADR-AUTO-PRELOG-RUNNERLOGS). A function that starts a tool any other way — the call operator (`& $tool`), a bare native command,
`Start-Process`, or a `[System.Diagnostics.Process]` — writes the resolved command line with `Write-Message` directly before it.

- [Logging a command](#logging-a-command)

### Rule ADR-PWSH-ANNOUNCE-COMMANDLOGLINE

In pwsh, the command log of ADR-AUTO-PRELOG-ALWAYSLOG is a `Write-Message` line on the information stream: never a `Write-Verbose` or
`Write-Debug` line, and never inside a branch on `-Verbose`, `-Debug`, `$VerbosePreference`, or a diagnostic switch. The `-Silent` switch of
ADR-AUTO-PRELOG-SILENTSWITCH is the one way a call leaves it out.

- [Logging a command](#logging-a-command)

## Context

[console-output-matters](../console-output-matters.md) decides what the console shows: status for the user running the automation,
diagnostic detail for the user diagnosing it, and an announcement of every lasting change to the session. This record is how pwsh does it.
Dot-sourcing `importer.ps1` loads modules and a compiled types assembly, sets preferences, moves `PATH` entries, and points environment
variables at tool homes; an installer rewrites `PATH` and the user environment; a quality gate lazy-loads Pester. PowerShell offers many
ways to write those facts to the console, and most cannot be silenced, redirected, or captured, so every line goes through one stream and
one chokepoint, and every state change is announced there.

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

The one thing a raw write offers is a dot without a line break, which a liveness signal needs (ADR-AUTO-CONSOLE-NOBOXDRAWING). The
chokepoint offers that too: `-NoNewline` wraps the text in a `HostInformationMessage` with `NoNewLine` set, the same record `Write-Host`
emits internally, so the host renders it inline while it stays an ordinary information record:

```powershell
while (-not $done) {
    Start-Sleep -Seconds 1
    Write-Message '.' -NoHeader -NoNewline
}
Write-Message '' -NoHeader   # newline after dots
```

A dot written from a background thread job uses the same writer: the job streams to the caller's host (`Start-ThreadJob -StreamingHost`) and
imports the loaded Writers module, so its dots behave like a `Write-Message` on the calling thread. An Azure DevOps logging command is no
exception: the host renders an information record to stdout exactly as it renders `Write-Host`, which is where the agent reads `##vso`
commands, and a test run silences it with everything else.

### The output hierarchy

Each output stream carries one of the audiences of [console-output-matters](../console-output-matters.md):

- **`Write-Message`**
  - When to use: One-liner status with caller prefix — command execution, completion, short results
  - Visible by default: Yes
- **`Write-Message -NoHeader`**
  - When to use: Multiline or headerless output — results, tables, formatted data (add `-ForegroundColor` for colors)
  - Visible by default: Yes
- **`throw` / `Assert-*`**
  - When to use: Something is wrong — execution stops
  - Visible by default: Yes
- **`Write-Verbose`**
  - When to use: Detail that helps debugging but clutters normal output — skip reasons, cache hits
  - Visible by default: No (`-Verbose`)
- **`Write-Debug`**
  - When to use: Internal state dumps for development — variable values, branch decisions
  - Visible by default: No (`-Debug`)
- **`Write-Output`**
  - When to use: Function return values. **Never** use for status messages — it pollutes the pipeline
  - Visible by default: Captured

`Write-Message` is the single public writer, over the private `Write-InformationColored` chokepoint. `-NoHeader` suits any content where the
`[CallerName]` prefix would indent the first line differently from the rest. Never call `Write-Information` or `Write-InformationColored`
directly (`NoRawInformationStream`).

**Do not use `Write-Warning` or `Write-Error`:** the importer sets both preferences to `Stop`, so both terminate
([error-handling](error-handling.md)).

`Write-Verbose` is the diagnostic output, and it deserves the same care as `Write-Message`:

```powershell
# GOOD — verbose captures the decisions the function made
Write-Verbose "Cache hit for tool '$Tool' — skipping version check"
Write-Verbose "Resolved config path: $configPath"
Write-Verbose "$Tool is already installed — skipping"

# BAD — verbose restates what the code obviously does
Write-Verbose "Entering function"
Write-Verbose "Setting variable"
Write-Verbose "Returning result"
```

### What counts as a state change

The session state of ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES, and the PowerShell commands that change it:

- **Environment variables, `PATH`, `PSModulePath`**
  - Changed by: `$env:<Name> = ...`, `[Environment]::SetEnvironmentVariable`, `Set-Item` / `Remove-Item` on `env:`
- **Loaded binaries**
  - Changed by: `Add-Type` (loading), `[Reflection.Assembly]::Load*`, `AssemblyLoadContext.LoadFromAssemblyPath`
- **Loaded modules**
  - Changed by: `Import-Module`, `Remove-Module`
- **Global variables and preferences**
  - Changed by: `$global:<Name> = ...`, `Set-Variable -Scope Global`
- **Working location**
  - Changed by: `Push-Location`, `Pop-Location`
- **Line editor, type and format data**
  - Changed by: `Set-PSReadLineOption`, `Set-PSReadLineKeyHandler`, `Update-TypeData`, `Update-FormatData`
- **What the next session starts with**
  - Changed by: the user and machine environment, the PowerShell profile

A .NET assembly cannot be unloaded, so the importer names the assembly it loads, by its path from the repository root into the per-user
shadow root (`Loaded types ../../Users/<user>/AppData/Local/catzc/types/Catzc.Types.<hash>.dll` on Windows), the vendor modules it imports,
and the modules it loads, evicts, or drops, on its verbose load record (ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE).

### Announce where it happens

The announcement is a `Write-Message` in the block that makes the change. An `if ($DiagnoseLoadTime)` timing line does not announce a change
made outside that branch, because a plain run would make the change and print nothing.

`-Verbose` does not announce. A state change is a fact about the session, and the always-on information stream is where facts go; the
verbose stream is for the diagnostic detail behind them (ADR-PWSH-ANNOUNCE-CORRECTSTREAM). The importer's own load record is the one
exception ([below](#the-importers-load-record)).

### Not a state change

`What is not a state change of this session in pwsh`

The exemptions of ADR-AUTO-CONSOLE-SILENTTRANSIENTCHANGES, as PowerShell spells them:

- **Restored before return.** A function that sets a variable for the duration of a call and restores it in `finally` (a scoped
  `Write-EnvironmentSet`, `Push-Location` paired with `Pop-Location`) leaves no lasting change.
- **Another runspace or process.** A scriptblock handed to `Start-Job`, `Start-ThreadJob` or `ForEach-Object -Parallel` changes its own
  runspace, not the caller's.
- **PowerShell's own bookkeeping.** `$LASTEXITCODE` is the automatic variable PowerShell sets after every native call; mirroring it is not a
  change the toolset makes.
- **The toolset's private bookkeeping.** A `$global:__<Name>` variable (the types load registry, the load-time collector, the test-run flag)
  crosses module scopes for the toolset's own use. The state it records is announced where that state changes.
- **Tests.** A test sets state on purpose and restores it in `AfterEach`/`AfterAll`, and its output belongs to Pester.

### Logging a command

[log-before-invoke](../log-before-invoke.md) decides that every external command is logged, exactly and on every run, before it runs. In
pwsh that log line is a status line like any other, so it takes the status path: `Write-Message` on the information stream.
`Invoke-Executable` writes it for every call that goes through it, and the `Invoke-*` tool wrappers inherit it. A function that starts a
process another way has nothing writing the line for it, so it writes the line itself, with every variable expanded, right before the call:

```powershell
Write-Message "widget pack $Path --output $outputFolder"
& widget pack $Path --output $outputFolder
```

The verbose and debug streams are off by default, so a command logged there is missing from exactly the run that needs it. The command line
is never routed there, and never written only when a diagnostic switch is set.

### Child-process output

`Child-process output is relayed, not re-written`

A child's output is its own bytes, never a PowerShell record, so routing it through the chokepoint would mean decoding and re-writing every
line; the C# relays write it straight through instead (ADR-PWSH-ANNOUNCE-CHILDOUTPUTRELAYED). The command that started the child is
announced before it runs ([log-before-invoke](../log-before-invoke.md)).

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
Printing those lines at every shell open is noise (ADR-AUTO-CONSOLE-REPORTOUTCOMES), so they are written with
`Write-ImporterMessage -StateChange`, which puts them on the verbose stream. A plain import shows one `Loaded in N seconds (...)` line, plus
anything that actually needs attention: a warning, `Built <dll>` for a freshly compiled assembly, the stale-types notice, and the
`-DiagnoseLoadTime` timings. `. .\importer.ps1 -Verbose` shows the full record.

The shim is an advanced script so that it accepts `-Verbose`; dot-sourced, it sets the preference in the caller's scope for the length of
the import, and PowerShell restores it afterwards. `-Verbose` reaches Invoke-Importer but not the bootstrap and vendor module functions that
make the changes, so Invoke-Importer hands it to the loader's writer with `Set-ImporterVerbosity`, a setting held in
`Catzc.Internal.Loader.psm1`. While the import runs, Invoke-Importer quiets the session-wide preference and restores it in a `finally`
(ADR-PWSH-ANNOUNCE-UNANNOUNCEDCHANGES), so `-Verbose` shows the load record rather than every function each `Import-Module` dot-sources and
exports.

The exception covers only the importer's own load. The functions it calls, such as the janitors that adjust `PATH`, are ordinary public
functions and announce on the information stream, so a person who runs `Sync-SessionTools` at the prompt sees every nudge. The same nudges
at every shell open are part of the load record, not news: a session's `PATH` starts from the registry each time, so the session-tool
janitor re-points `dotnet` and appends the same hint folder on every import. The importer therefore quiets the session-wide information
preference around that one janitor unless its own `-Verbose` is set, and restores it in a `finally`; a common parameter would reach only the
janitor's scope, while the preference reaches the writer chokepoint in its own module (ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT). The janitor
itself announces unconditionally either way, which is what the analyzer rule checks.

## Decision

Console output takes one stream through one chokepoint, and every lasting session change is announced there, where it happens, naming what
changed and to what; the rules above spell out the exemptions, the relay and the command log.

### How this is enforced

- **`Measure-NoRawConsoleWrite`** (`pwsh/.scriptanalyzer/NoRawConsoleWrite.psm1`) flags every way past the information stream: `Write-Host`,
  `Out-Host`, `Write-Progress`, `Clear-Host`, the `[Console]` write methods and property assignments, writes through
  `[Console]::Out`/`Error`, and the `$Host.UI` writers. It supersedes the built-in `PSAvoidUsingWriteHost`, which the analyzer settings
  exclude so a `Write-Host` is reported once. Its one justified suppression is `Set-RedirectedOutputEncoding` in the importer module, the
  exception ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT names.
- **`Measure-AnnounceStateChange`** (`pwsh/.scriptanalyzer/AnnounceStateChange.psm1`) flags a state change of the kinds in the table above
  that no information-stream writer (or `Write-ImporterMessage -StateChange`, ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE) in the same or an
  enclosing block announces, and passes the exemptions of ADR-PWSH-ANNOUNCE-UNANNOUNCEDCHANGES. It checks that a change is announced; what
  the line says is a review concern.
- **`Measure-NoRawInformationStream`** keeps `Write-Information` inside the two chokepoint functions, `Write-InformationColored` and
  `Write-ImporterMessage`.
- **Writers emit on the information stream.** `Write-InformationColored` emits via `Write-Information`, carrying colour as embedded ANSI so
  it survives a pipe.
- **Test suppression is a guard at the chokepoint, not a stream preference.** Pester captures the information stream around each test and
  replays it, so `$InformationPreference = 'SilentlyContinue'` does not stop writer output — only not writing it does. `Test-Automation`
  sets `$global:__PesterRunning`, and the chokepoint and the child-output relay return before writing. Tests that assert writer output lift
  the flag for their own `Describe`.
- **`Write-Message -NoNewline`** provides the inline dot, so no liveness signal needs a raw write.
- **Code review** checks the wording: an announcement names the target and its new value, and a suppression's justification names where the
  delegated announcement happens.

## Consequences

- Every console line can be silenced, redirected, or captured by the caller, and none leaks into test output.
- A function's return value stays clean: status never enters the pipeline.
- A plain import shows one line. Its full record, naming the session settings, the roots, the vendor and catzc modules, and the types
  assembly it loads, is one `-Verbose` away; each line states a fact the session depends on.
- A new state-changing function cannot land unannounced; the analyzer names the change and the function.
