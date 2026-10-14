# docs/references/automation/catzc-base-timeouts.md

`Catzc.Base.Timeouts`

Owns the time safeguards: how long a call may run before it is stopped, and the means to stop it. One config (`timeouts.yml`) holds every
limit — a deliberately tight default plus per-executable entries for tools whose ordinary runs outlast it — and every consumer resolves its
limit from there, so tuning a blocker is one edit. Nothing waits forever: there is no "no limit" value, and a call that outlives its limit
is stopped and fails with a message that names the limit and where to change it.

## Responsibilities

| Responsibility   | Area   | Name                                                 |
| ---------------- | ------ | ---------------------------------------------------- |
| responsibility:1 | limits | [Configured limits](#responsibility1--configured-limits) |
| responsibility:2 | stop   | [Stop at the limit](#responsibility2--stop-at-the-limit) |

### responsibility:1 — Configured limits

The single source of every time limit. `default_seconds` applies to any call without a more specific entry; `executables` gives a tool its
own limit, keyed by its bare name. The config type validates the file at load — positive whole seconds only, bare executable names only —
and answers the lookup, ignoring a directory or an extension on the name it is asked about. The same value caps the agent tooling: the
Claude Code hook that guards every foreground Bash call reads `default_seconds` from this file.

### responsibility:2 — Stop at the limit

Running a script block inside its limit, in an invoking form that returns the block's output and an asserting form that only passes or
throws. The block runs in the caller's runspace, so it sees what it would see when called directly; a timer outside the pipeline stops it
at the limit, including a native command it is waiting on, and the call then throws a timeout error. The external-process counterpart is
[Catzc.Base.Execution](catzc-base-execution.md)'s streamed `Invoke-Executable`, which kills a child process tree at the executable's limit.

## What the module does

The two responsibilities are a value and its enforcement. The configured limits say how long; the stop-at-the-limit functions and the
process runner make it so. The module sits directly above [Catzc.Base.Config](catzc-base-config.md) (for `timeouts.yml`) and
[Catzc.Base.Objects](catzc-base-objects.md) (the config type's record base), and below
[Catzc.Base.Execution](catzc-base-execution.md), which asks it for each process's limit.

## Division

The module's public functions and configuration file, sorted into the responsibilities above.

| Responsibility                       | Function                 |
| ------------------------------------ | ------------------------ |
| responsibility:1 — Configured limits | `Get-TimeoutSeconds`     |
| config                               | `timeouts.yml`           |
| responsibility:2 — Stop at the limit | `Invoke-WithTimeout`     |
|                                      | `Assert-CompletesWithin` |
