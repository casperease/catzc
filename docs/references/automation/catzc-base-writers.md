# Catzc.Base.Writers

The console output module. It owns the **one colour-aware writer family** the entire platform logs through — every status line, header,
table, and object dump flows through this module's stream — and the diagnostic renderers that surface exceptions, call stacks, bound
parameters, and the environment when something goes wrong. It is a member of the `Base` group alongside
[Catzc.Base.Asserts](catzc-base-asserts.md) and depends on [Catzc.Base.Objects](catzc-base-objects.md) for the object-shaping helpers that
`Write-Object` delegates to. The design contract that governs these writers is the subject of
[console-output-matters](../../adr/automation/powershell/console-output-matters.md).

## Domains

| Domain   | Area        | Name                                       |
| -------- | ----------- | ------------------------------------------ |
| domain:1 | output      | [Console output](#domain1--console-output) |
| domain:2 | diagnostics | [Diagnostics](#domain2--diagnostics)       |

### domain:1 — Console output

The colour-aware writer family through which every module in the platform emits its output. A single stream carries all status lines,
coloured text, structured headers and footers, and object dumps to the console, so output is uniform across modules, can be suppressed in a
pipe, and never intermixes with raw `Write-Host` calls. `Write-Message` is the primitive writer, routing every line through the module's
private information-stream chokepoint (`Write-InformationColored`), which owns the colour mapping and the suppression of output during a
Pester run; `Write-Object` serialises a structured value through the same stream, delegating the object-shaping work to
[Catzc.Base.Objects](catzc-base-objects.md) before writing; `Write-Header` and `Write-Footer` bracket sections of output with consistent
framing. This is the concrete implementation of [console-output-matters](../../adr/automation/powershell/console-output-matters.md).

### domain:2 — Diagnostics

The renderers a caller uses to expose troubleshooting information when something goes wrong. These functions surface the caught exception
tree, the PowerShell call stack at the point of failure, the bound parameter set of the failing cmdlet, and a snapshot of the environment
the command ran in. They write through the same colour-aware stream as domain 1, so diagnostic output is suppressible and colour-consistent
with normal output; they are distinct from the writer primitives because their audience is a troubleshooting operator reading after a
failure, not an operator watching a run in progress.

## What the module does

Catzc.Base.Writers is the platform's single output channel. Every module that writes to the console does so through this module's writers —
there is no second family, no module-local colour convention, and no raw `Write-Host` call alongside them. Owning the channel as a module
rather than as a pattern enforces the stream contract (colour mapping, suppression, pipe survival) mechanically: a caller cannot
accidentally bypass it by reaching for a lower-level cmdlet.

The split into two domains reflects a split in audience. Domain 1 addresses the operator watching a run in progress: its writers emit status
lines, object dumps, and section markers at normal log level. Domain 2 addresses the same operator after something has failed: its renderers
surface the exception tree, call stack, bound parameters, and environment in a form that makes the failure self-diagnosable without
requiring a debugger. Both domains write through the same stream, so a diagnostic dump looks like the rest of the run's output rather than a
raw error wall.

`Write-Object` is the one function in this module that crosses a module boundary by design. The writing belongs here; the object-shaping
work — sorting dictionary keys, converting to YAML-safe form — belongs to [Catzc.Base.Objects](catzc-base-objects.md), and that is where it
lives. Beyond that dependency and the shared `Base`-group membership with [Catzc.Base.Asserts](catzc-base-asserts.md), this module has no
outbound dependencies: its writers know nothing about configuration, external processes, or any domain module above them.

## Division

The module's public functions, sorted into the domains above.

| Domain                    | Function                      |
| ------------------------- | ----------------------------- |
| domain:1 — Console output | `Write-Message`               |
|                           | `Write-Object`                |
|                           | `Write-Header`                |
|                           | `Write-Footer`                |
| domain:2 — Diagnostics    | `Write-Exception`             |
|                           | `Write-CallStack`             |
|                           | `Write-CmdletParameterSet`    |
|                           | `Write-EnvironmentDiagnostic` |
