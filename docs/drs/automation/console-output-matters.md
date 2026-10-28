# Automation: Console output matters

## Rules: ADR-AUTO-CONSOLE

### Rule ADR-AUTO-CONSOLE-EVERYLINEEARNSPLACE

Console output is a first-class UX concern — every line must earn its place, so a reader understands what happened top-to-bottom, once,
without re-running anything.

- [What good output looks like](#what-good-output-looks-like)
- [Two audiences](#two-audiences)

### Rule ADR-AUTO-CONSOLE-LOGCOMMANDS

Log commands, not commentary — log the exact, copy-pasteable command (e.g. `uv python install 3.13 --default`) rather than a paraphrase like
"Now installing…". A readable description may be added beside the command, never in its place.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-TOOLSSPEAK

Let tools speak for themselves — an external tool's own output flows to the console as it arrives, unchanged; the toolset does not capture
it to re-format it, prefix its lines, or re-write it as its own messages.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-REPORTOUTCOMES

Report outcomes, not steps, and stay silent when there is nothing meaningful to report.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-SELFCONTAINEDERRORS

Errors must be self-contained — the error message alone must diagnose the problem without reading the source.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-SPARINGCOLOUR

Use color sparingly and consistently (red=error, yellow=warning, green=success, cyan=headers, default=everything else) — the default color
is the signal that nothing is wrong.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-NOBOXDRAWING

No side borders or box drawing (they break copy-paste) — vertical headers and blank-line separators are fine; and no progress bars — print a
dot per interval instead.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-OPTINTIMESTAMPS

Timestamps are opt-in through the `CATZC_MESSAGE_TIMESTAMPS` environment variable — CI platforms already timestamp every line, so they are
never needed there.

- [Output practice](#output-practice)

### Rule ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING

Announce work before it blocks. Before any operation that leaves the session unresponsive for more than ~5 seconds — a slow external tool, a
scan or format pass over many files, a first-time lazy module load, a long cloud call — write a status line first, naming what is about to
happen, so silence never reads as a hang. This refines ADR-AUTO-CONSOLE-REPORTOUTCOMES: staying silent is right for fast work, wrong for
slow work.

- [Announce work before it blocks](#announce-work-before-it-blocks)

### Rule ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES

Every lasting change a function makes to the state of the session is announced on the always-shown status output, where it happens, naming
what changed and to what. The session's state is its environment variables (`PATH` and the module search path included), the binaries and
libraries loaded into it, the modules loaded into or removed from it, its global variables and preferences, its working location, its line
editor and display configuration, plus the user environment and profile it reads at start. Announce when something actually changes; a
converge that finds everything in place changes nothing and says nothing. The toolset's own load sequence, which makes the same expected
changes at every session start, records them on diagnostic output instead (ADR-AUTO-CONSOLE-REPORTOUTCOMES).

- [Session state changes](#session-state-changes)
- [What counts as a state change](#what-counts-as-a-state-change)
- [Announce where it happens](#announce-where-it-happens)

### Rule ADR-AUTO-CONSOLE-SILENTTRANSIENTCHANGES

A change that is not a lasting change of this session is not announced: a change the function restores before it returns, a change made in
another process or concurrent worker (a background job, a parallel loop), the engine's own bookkeeping (such as the exit code it records
after a native call), the toolset's private session bookkeeping, and the state a test sets and restores around itself.

- [Not a state change](#not-a-state-change)

## Context

The console is the whole user interface of a CLI automation platform — no GUI, dashboard or notification system — so every line of output is
a UX decision. Automation output fails in one of two ways:

**Too noisy.** Every step, variable and decision is logged; the line that matters is buried, and a CI log becomes megabytes of noise. When
everything is highlighted, nothing is.

**Too silent.** A 30-second step gives no sign of whether it works or hangs, and a failure arrives without saying what was attempted, so the
user re-runs with diagnostics on and hopes.

Both fail one test: **can the user understand what happened by reading the output once, top to bottom, without re-running anything?**

### What good output looks like

Good output tells a story: what is happening, what happened, and what went wrong — in that order of priority, with nothing else.

```text
[Invoke-Importer] Loaded in 0.5 seconds (module import 0.3s, session initializer/finalizer 0.2s)
[Install-Poetry] poetry install --no-root
[Invoke-Executable] poetry install --no-root
Installing dependencies from lock file
[Invoke-Python] python deploy.py --env prod
Deployed 3 services
```

Each line earns its place:

- The importer reports load time (is the shell healthy?)
- Commands are logged before execution (what is about to happen?)
- Tool output flows through naturally (what did the tool say?)
- No decoration, no borders, no emoji, no "Step 1 of 5"

### Two audiences

`Status output and diagnostic output`

The toolset writes for two readers. **Status output** is for the user running the automation: what happened, what was executed, what
changed. It is always shown, and every line carries the name of the function that wrote it. **Diagnostic output** is for the user diagnosing
the automation: why a decision was made, what was skipped, what path was resolved. It is shown on request. A function's return value is data
for its caller, never a status line, and a failure stops execution with a self-contained error. There is no third path between "fine" and
"stop": no warnings and no errors that let execution carry on. Each engine maps these onto its own output channels.

**Diagnostic output deserves the same care as status output.** It is the window underneath when something misbehaves. Information needed
once to understand the code's behaviour is needed again, so a diagnostic line written while debugging stays in; it turns a 30-minute
debugging session into a 30-second re-run with diagnostics on.

```text
GOOD — diagnostic lines capture the decisions the function made
Cache hit for tool 'python' — skipping version check
Resolved config path: /repo/pwsh/Base.Config/configs/configs.yml
python is already installed — skipping

BAD — diagnostic lines restate what the code obviously does
Entering function
Setting variable
Returning result
```

The distinction between status and diagnostic output is about audience, not importance. Both deserve thoughtful content.

### Output practice

**Log commands, not commentary.** Every wrapper around an external tool logs the exact command before it runs
([log-before-invoke](log-before-invoke.md#rule-adr-auto-prelog-logresolvedcommand)). It is the most valuable output: it says what ran, and
it can be copy-pasted to reproduce. "Now installing Poetry..." adds nothing the command does not say better.

**Let tools speak for themselves.** The user knows what `poetry install` output looks like; capturing, re-formatting or prefixing it makes
it harder to read and impossible to search for in the tool's documentation. How an engine relays a child's output is its twin record's
concern.

**Report outcomes, not steps.** "Poetry 2.1 installed successfully" is an outcome; "Checking if poetry is installed... Checking version...
Done" is narration nobody reads.

**Silence is acceptable.** `Assert-Command python` succeeds silently — the absence of an error _is_ the output; "Python found!" adds only
noise.

**Errors must be self-contained.** "'Python' is not installed" diagnoses; "Assertion failed" does not. The `Assert-*` library builds
structured messages by convention.

**Use color sparingly and consistently.** GitHub Actions and Azure DevOps render ANSI colors in their log viewers, so color choices matter
everywhere, not only in local terminals.

| Color   | Meaning                                       |
| ------- | --------------------------------------------- |
| Red     | Errors — something failed                     |
| Yellow  | Warnings — something needs attention          |
| Green   | Success confirmations (use sparingly)         |
| Cyan    | Headers and section dividers                  |
| Default | Everything else — normal informational output |

Consistent color creates a visual language the human eye learns to scan. In a 200-line CI log, a single red line jumps out immediately. If
half the output is colorized for decoration, that signal is lost. Do not colorize normal output for emphasis — the default color _is_ the
signal that nothing is wrong.

**No side borders or box drawing.** Never wrap output in decorative frames:

```text
# WRONG — cannot copy-paste the content without editing out the borders
| Deploying to prod   |
| 3 services updated  |

# WRONG
+---------------------+
| Environment: prod   |
+---------------------+

# RIGHT — headers and footers are fine, content is plain
--- Deploying to prod ---
3 services updated
```

Side borders (`|`, `+--+`, `║`) force the user to strip decoration from every line before using it. Headers (`---`, `===`, `Write-Header`)
and blank-line separators frame the output vertically without touching the content.

**No progress bars.** A progress bar overwrites previous lines, vanishes from CI logs, clutters an interactive terminal, and costs code
(percentages, time estimates, activity IDs). A dot (`.`) per interval on one line, ended when the work finishes, says the operation is alive
in CI logs, terminals and redirected output alike, and goes through the toolset's writer, so a test run silences it with no special
handling.

**Timestamps are opt-in.** Every status line carries its caller's name as a prefix (`[Invoke-Executable] poetry install`); timestamps are
for local debugging only, since CI platforms timestamp every line natively.

### Announce work before it blocks

Silence is right for fast work and wrong for slow work: a function quiet for several seconds is indistinguishable from a hung one, and the
user cannot tell whether to wait or kill it. The up-front line is not step narration but the signal that the process is alive; it is the one
place "report outcomes, not steps" yields, since the _start_ of a long operation is itself an outcome worth reporting.

The line goes _before_ the blocking call — one printed once the work is done cannot say it is in progress. For an open-ended operation, pair
it with a dot-per-interval liveness signal (ADR-AUTO-CONSOLE-NOBOXDRAWING) rather than leaving the console frozen. `Invoke-Executable`
covers the common case: it logs the exact command before running it (ADR-AUTO-CONSOLE-LOGCOMMANDS,
[log-before-invoke](log-before-invoke.md)), so a function whose slow step _is_ a single external call inherits the announcement for free.
The rule bites where the slow work is not a logged external call — a large in-process loop, a module import, an in-memory computation —
where nothing else would print.

### Session state changes

`Announce every lasting change to the session`

The console session is where the user works. Loading the toolset into it loads modules and compiled types, sets preferences, moves `PATH`
entries, and points environment variables at tool homes; an installer rewrites `PATH` and the user environment; a quality gate lazy-loads
its test framework. Each of these changes what the next command in that session does. When they happen silently, the user is left with
questions the scrollback cannot answer: why does `dotnet` resolve from this folder, which build of the types is loaded, where did this
module search path entry go. The only way to find out is to read the source or re-run with diagnostics, which is exactly what
ADR-AUTO-CONSOLE-EVERYLINEEARNSPLACE rules out.

So the scrollback is made a complete record of how the session reached its state. Every change is announced as it happens, with the value it
set, and every announcement travels the same writer as every other line the toolset writes.

### What counts as a state change

A state change is anything that makes a later command in the same session behave differently:

- **Environment variables**, `PATH` and the module search path included.
- **Loaded binaries**: an assembly or library loaded into the session.
- **Loaded modules**: a module loaded into or removed from the session.
- **Global variables and preferences**.
- **The working location**, when a function moves it and leaves it moved.
- **The line editor and display configuration**: key handlers, editor options, and the type and format data the engine renders with.
- **What the next session starts with**: the user and machine environment, and the shell profile.

Loading a binary is a state change like any other, and the clearest case for announcing one: a loaded assembly cannot be unloaded, so the
build the session holds decides which types every later call sees until the process ends. The toolset therefore names the assembly it loads,
the vendor modules it loads, and the modules it loads, evicts, or drops.

Writing a file in the repository is not a session state change; the repository's own rules govern those. The user and machine environment
and the profile are the exception, because they are what the next session starts from: changing them is changing the console the user opens
tomorrow.

### Announce where it happens

The announcement sits in the block that makes the change, so it runs exactly when the change runs. A line printed in an unrelated branch, a
timing line printed only under a diagnostic switch for example, does not announce a change made outside that branch, because a plain run
would make the change and print nothing. The line names the target and the value: `Session PATH: prepended 'C:\...\dotnet'`,
`User environment: JAVA_HOME='...'`, `Loaded vendor module powershell-yaml 0.4.12`. A function that makes several related changes may
announce them on one line built as it goes, and a function that only converges announces the changes it actually made: an installer re-run
on a box that has the right `JAVA_HOME` writes nothing and says nothing. That keeps this rule consistent with
ADR-AUTO-CONSOLE-REPORTOUTCOMES: a state change is always worth reporting, and a no-op is not a change.

Diagnostic output does not announce. A state change is a fact about the session, and the always-shown status output is where facts go;
diagnostic output is for the detail behind them. The toolset's own load sequence is the one exception: it makes the same expected changes at
every session start, so printing them at every shell open is noise (ADR-AUTO-CONSOLE-REPORTOUTCOMES), and its record of them is diagnostic
output, one switch away. The functions the load sequence calls announce on status output like any other caller's.

### Not a state change

`What is not a state change of this session`

Some changes leave the session as they found it, or never touch it, and announcing them would be noise:

- **Restored before return.** A function that sets a variable or moves the working location for the duration of a call and restores it
  before it returns, even on failure, leaves no lasting change.
- **Another process or worker.** Work handed to a background job or a parallel loop changes its own process or runspace, not the caller's.
- **The engine's own bookkeeping.** The exit code an engine records after every native call is the engine's state; mirroring it is not a
  change the toolset makes.
- **The toolset's private bookkeeping.** Session-wide records the toolset keeps for its own use (the types load registry, the load-time
  collector, the test-run flag) cross module boundaries for the toolset alone. The state they record is announced where that state changes.
- **Tests.** A test sets state on purpose and restores it around itself, and its output belongs to the test runner.

## Decision

Console output is a first-class UX concern. Every line must earn its place. Functions write status for the user running them and diagnostic
detail for the user diagnosing them, log commands before execution, report outcomes not steps, stay silent when there is nothing meaningful
to say, and announce a long-running operation before it blocks so silence never reads as a hang. Every lasting change to the session's state
is announced where it happens, naming what changed and to what; changes that are restored, made elsewhere, or private bookkeeping are not.

### How this is enforced

- **The Writers module** — provides all output functions: `Write-Message`, `Write-Object`, `Write-Header`, `Write-Exception`, and others.
  These are the building blocks for uniform console output, and the only way the toolset writes to the console.
- **`Write-Message`** — the principal communication tool. Every message includes the calling function name automatically
  (`[Invoke-Executable] poetry install`), so the user always knows which function produced the output, and honours
  `CATZC_MESSAGE_TIMESTAMPS`.
- **Test runs are silent** — the writer checks the test-run flag the test runner sets and writes nothing while it is set, so no line leaks
  into test output and no test needs its own guard; a child process's relayed output honours the same flag.
- **`Invoke-Executable`** — logs the exact command via `Write-Message` before execution. All `Invoke-*` wrappers inherit this.
- **Analyzer rules** — `Measure-NoRawConsoleWrite` flags a write that goes around the writer, and `Measure-AnnounceStateChange` flags a
  state change that no announcement covers and passes the exemptions of ADR-AUTO-CONSOLE-SILENTTRANSIENTCHANGES. They check that a change is
  announced; what the line says is a review concern.
- **Console-ready C# types** — every catzc C# object interpolated into a message or shown in a table renders as one readable line, not its
  type name.
- **Code review** — output quality is a review concern, same as logic correctness. A function that spams the console or swallows errors is a
  bug. An announcement names the target and its new value.

## Consequences

- Users can read CI logs top-to-bottom and understand what happened without re-running.
- Interactive sessions are clean — output is signal, not noise.
- Copy-paste debugging works — commands are logged exactly as executed.
- The output is the documentation. When a user runs `Install-DevBoxTools`, the console tells them what was installed, at what versions, and
  whether it succeeded. No README needed for the happy path.
- The scrollback of a session is a complete record of how it reached its state: which modules and which types build it loaded, which `PATH`
  entries moved and why, which variables an installer set.
- A new state-changing function cannot land unannounced; the analyzer names the change and the function.
