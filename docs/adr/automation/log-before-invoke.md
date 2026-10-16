---
catzc:
  derived:
    path: docs/adr/automation/log-before-invoke.md
    folder: docs/adr/automation
    name: log-before-invoke
    filetype: md
    kind: adr
    language: markdown
    track: docs
    body_sha: "2c0702674ab9"
    defines:
      - ADR-AUTO-PRELOG#{1,2,4,5}
    adrs:
      - ADR-AUTO-CONSOLE#3
    links:
      - docs/adr/automation/console-output-matters.md#rule-adr-auto-console3
      - docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce10
---

# ADR: Log the exact command before every invocation

## Rules: ADR-AUTO-PRELOG

### Rule ADR-AUTO-PRELOG:1

Log the full, resolved command string (all variables expanded, all arguments in place) via `Write-Message` as the last step before
invocation. The log entry must be copy-pasteable: the command itself, never a paraphrase of it
([ADR-AUTO-CONSOLE#3](console-output-matters.md#rule-adr-auto-console3)).

- [Automatic, not opt-in](#automatic-not-opt-in)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-PRELOG:2

The toolset's executable runner, `Invoke-Executable`, does this automatically, so a function that runs a tool through it gets the log line
for free. A function that starts a tool any other way logs the command itself, before it starts it.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-PRELOG:4

Do not conditionally log: the command is logged on every run, on the always-shown status output, never only behind a diagnostic switch.

- [Automatic, not opt-in](#automatic-not-opt-in)

### Rule ADR-AUTO-PRELOG:5

Use the `-Silent` switch (on `Invoke-Executable`, `Invoke-Python`, `Invoke-Poetry`, `Invoke-Dotnet`) to suppress the command log line for
noisy plumbing calls or commands carrying a runtime secret ADO cannot mask.

- [Secrets are not a concern](#secrets-are-not-a-concern)

## Context

When an external command fails, the first question is always: "What exactly did it run?" If the answer requires reading the source code,
adding `-Verbose`, or reproducing the issue with debug flags, you have already lost minutes. In a CI pipeline where the environment is gone
after the run, those minutes turn into a full rebuild cycle.

PowerShell automation is fundamentally about orchestrating external tools — `az`, `dotnet`, `winget`, `poetry`, `git`. Each of these has
dozens of flags, and the difference between success and failure is often a single argument or a missing quote. If the exact invocation is
not in the log, you are guessing.

### Automatic, not opt-in

`Why this must be automatic, not opt-in`

**Developers will not add logging.** If logging is a conscious choice per call site, it will be missing from exactly the call that fails.
The function that "obviously works" and does not need logging is the one that breaks at 3 AM in production.

**Verbose/Debug flags are off by default.** If the command is only logged behind `-Verbose`, you will not have it when you need it. The log
must be there on every run, not just when someone remembered to enable diagnostics.

**Copy-paste debugging.** When the log shows the exact command, you can copy it, paste it into a terminal, and run it manually. This is the
fastest debugging workflow — no reproduction steps, no guessing what the automation actually did. If the command is paraphrased or partially
logged, this workflow breaks.

### Secrets are not a concern

Secrets never live in the codebase — they come from ADO pipeline variables. ADO's agent automatically masks any value registered as a secret
variable, replacing it with `***` in all log output. Since secrets always originate from ADO, they are always registered, and they are
always masked. The automation code logs freely.

On a developer's machine, the developer already has direct access to every value the automation uses. Logging a connection string to your
own terminal is not a security event.

## Decision

Every function that invokes an external command must log the exact command string immediately before execution.

### How this is enforced

- **`Invoke-Executable`** — logs the full command string via `Write-Message` before execution. All `Invoke-*` tool wrappers
  (`Invoke-Python`, `Invoke-Poetry`, `Invoke-Dotnet`) delegate to `Invoke-Executable` and inherit this behavior automatically. How pwsh logs
  a tool started outside it, and on which stream, is [announce-state-changes](../pwsh/announce-state-changes.md#rule-adr-pwsh-announce10).

## Consequences

- Every CI log contains the exact commands that ran, in order. Debugging starts with the log, not with the source code.
- Failed commands can be copy-pasted and re-run manually for immediate reproduction.
- No one needs to re-run a pipeline with `-Verbose` to find out what happened — the information is already there.
- Secret masking is ADO's responsibility. The automation code logs freely and ADO redacts what needs redacting.
