# docs/references/automation/catzc-base-timeouts.md

`Catzc.Base.Timeouts`

Owns the time safeguards: how long a call may run before it is stopped, and the means to stop it. One config (`timeouts.yml`) holds every
limit, keyed by where the run happens (devbox or pipeline) and which shell runs it (bash or pwsh), plus per-executable entries for tools
whose ordinary runs outlast the default. Every consumer resolves its limit from there, so tuning a blocker is one edit. Nothing waits
forever: there is no "no limit" value, and a call that outlives its limit is stopped and fails with a message that names the limit and where
to change it.

## Responsibilities

| Responsibility   | Area       | Name                                                             |
| ---------------- | ---------- | ---------------------------------------------------------------- |
| responsibility:1 | limits     | [Configured limits](#responsibility1--configured-limits)         |
| responsibility:2 | stop       | [Stop at the limit](#responsibility2--stop-at-the-limit)         |
| responsibility:3 | exemptions | [Budget exemptions](#responsibility3--budget-exemptions)         |
| responsibility:4 | agents     | [Agent shell safeguard](#responsibility4--agent-shell-safeguard) |

### responsibility:1 — Configured limits

The single source of every time limit. `limits.<devbox|pipeline>` gives bash a foreground and a background limit and pwsh one limit;
`executables` gives a tool its own limit, keyed by its bare name. Every key is optional: the sensible defaults are declared once, on the
config type — tight on a devbox, looser but still bounded in a pipeline — so the file states only what has been tuned. The config type
validates the file at load (known keys only, positive whole seconds only, a background limit never below its foreground limit, bare
executable names only) and answers the lookup for the run environment the session is in.

### responsibility:2 — Stop at the limit

Running a script block inside its limit, in an invoking form that returns the block's output, an asserting form that only passes or throws,
and a testing form that answers whether it finished in time. The block runs in the caller's runspace, so it sees what it would see when
called directly; a timer outside the pipeline stops it at the limit, including a native command it is waiting on, and the call then throws a
timeout error. The external-process counterpart is [Catzc.Base.Execution](catzc-base-execution.md)'s streamed `Invoke-Executable`, which
kills a child process tree at the executable's limit.

### responsibility:3 — Budget exemptions

A piece of work can carry an immutable budget GUID — minted and registered in the managed-GUID registry, passed by the call site — so it can
be exempted while it is tuned. `timeout-exemptions.yml` names exempt budgets one at a time or as an inclusive GUID range, optionally scoped
to an environment and a shell, each with a reason. An exemption raises the budget's limit to its scope's ceiling and never removes it. The
config type rejects overlapping entries, non-canonical GUIDs and missing reasons; an integrity test holds every named GUID to the registry.
Work that must never run exempt asserts so.

### responsibility:4 — Agent shell safeguard

The verdict on each Bash call a coding agent makes, which a compiled Claude Code hook applies before the call runs. A foreground call must
pass a timeout within the bash foreground limit; a background call — whose tool timeout is not applied — must start with a `timeout` prefix
within the bash background limit around a single command. A call that breaks this is denied, never rewritten, with a reason that fits who
asked: the main session raises the blocker with the user, a subagent reports it to its coordinator, a pipeline fixes the call or its limit.
The hook compiles this module's own config and verdict types, so it cannot drift from the limits the pwsh side resolves.

## What the module does

The first two responsibilities are a value and its enforcement: the configured limits say how long, and the stop-at-the-limit functions and
the process runner make it so. Exemptions loosen a limit for named work without ever lifting it, and the agent shell safeguard applies the
same limits to the shell calls an agent makes. The module sits above [Catzc.Base.Config](catzc-base-config.md) (for its configs),
[Catzc.Base.Objects](catzc-base-objects.md) (the config types' record base) and [Catzc.Base.Repository](catzc-base-repository.md) (the run
environment), and below [Catzc.Base.Execution](catzc-base-execution.md), which asks it for each process's limit.

## Division

The module's public functions and configuration files, sorted into the responsibilities above.

| Responsibility                           | Function                    |
| ---------------------------------------- | --------------------------- |
| responsibility:1 — Configured limits     | `Get-TimeoutSeconds`        |
|                                          | `Get-TestTimeLimits`        |
| config                                   | `timeouts.yml`              |
| responsibility:2 — Stop at the limit     | `Invoke-WithTimeout`        |
|                                          | `Assert-CompletesWithin`    |
|                                          | `Test-CompletesWithin`      |
| responsibility:3 — Budget exemptions     | `Get-TimeoutExemption`      |
|                                          | `Test-IsTimeoutExempt`      |
|                                          | `Assert-IsNotTimeoutExempt` |
| config                                   | `timeout-exemptions.yml`    |
| responsibility:4 — Agent shell safeguard | `BashSafeguard` (type)      |
