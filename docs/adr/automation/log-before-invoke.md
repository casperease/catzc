# ADR: Log the exact command before every invocation

## Rules: ADR-PRELOG

### Rule ADR-PRELOG:1

Log the full, resolved command string (all variables expanded, all arguments in place) via `Write-Message` as the last step before
invocation. The log entry must be copy-pasteable.

- [Why this must be automatic, not opt-in](#why-this-must-be-automatic-not-opt-in)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PRELOG:2

`Invoke-Executable` does this automatically; functions using it get logging for free. Functions that bypass it with direct `& $tool` calls
must add their own logging.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PRELOG:3

Do not paraphrase: log the actual command (e.g. `uv python install 3.13 --default`), not a description like "Installing Python...". A
readable description may be added but never substituted.

- [Why this must be automatic, not opt-in](#why-this-must-be-automatic-not-opt-in)

### Rule ADR-PRELOG:4

Do not conditionally log: the command is logged on every run, not behind `-Verbose` or `-Debug`.

- [Why this must be automatic, not opt-in](#why-this-must-be-automatic-not-opt-in)

### Rule ADR-PRELOG:5

Use the `-Silent` switch (on `Invoke-Executable`, `Invoke-Python`, `Invoke-Poetry`, `Invoke-Dotnet`) to suppress the command log line for
noisy plumbing calls or commands carrying a runtime secret ADO cannot mask.

- [Secrets are not a concern](#secrets-are-not-a-concern)

## Context

When an external command fails, the first question is always: "What exactly did it run?" If the answer requires reading source code, adding
`-Verbose`, or reproducing the issue with debug flags, you have already lost minutes. In a CI pipeline where the environment is gone after
the run, those minutes turn into a full rebuild cycle.

PowerShell automation is fundamentally about orchestrating external tools — `az`, `dotnet`, `winget`, `poetry`, `git`. Each of these has
dozens of flags, and the difference between success and failure is often a single argument or a missing quote. If the exact invocation is
not in the log, you are guessing.

### Why this must be automatic, not opt-in

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
  (`Invoke-Python`, `Invoke-Poetry`, `Invoke-Dotnet`) delegate to `Invoke-Executable` and inherit this behavior automatically.

## Consequences

- Every CI log contains the exact commands that ran, in order. Debugging starts with the log, not with the source code.
- Failed commands can be copy-pasted and re-run manually for immediate reproduction.
- No one needs to re-run a pipeline with `-Verbose` to find out what happened — the information is already there.
- Secret masking is ADO's responsibility. The automation code logs freely and ADO redacts what needs redacting.

## Dora explains

DORA's research links comprehensive, automatic logging and rapid troubleshooting to deployment reliability and reduced incident response
time. Logging the exact command before every invocation ensures the log contains the information needed to reproduce and diagnose failures
without re-running.

- [Monitoring and observability](https://dora.dev/capabilities/monitoring-and-observability/) — logging every command and its output
  provides the observability needed to diagnose failures in CI and production without re-running.
- [Continuous delivery](https://dora.dev/capabilities/continuous-delivery/) — exact command logs enable fast copy-paste reproduction and
  debugging, reducing time-to-diagnosis and pipeline iteration cycles.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — automatic logging through `Invoke-Executable` ensures
  consistency and prevents the "forgot to log" bugs in production.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
