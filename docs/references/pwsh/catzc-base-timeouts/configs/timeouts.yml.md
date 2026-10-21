# pwsh/Catzc.Base.Timeouts/configs/timeouts.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `executables:`, written with `#`.

```text
Time safeguards — how long a call may run before it is stopped. Loaded by Get-Config -Config timeouts and
validated by the TimeoutsConfig type; read through Get-TimeoutSeconds. Every value is a positive whole number
of seconds: there is no "no limit" value, so every call runs inside a safeguard.

Consumers:
  - Invoke-Executable (streamed mode) kills a child process that outlives its limit;
  - Invoke-WithTimeout / Assert-CompletesWithin stop a script block that outlives its limit;
  - the Claude Code PreToolUse hook (.claude/hooks/Assert-BashTimeout/, a C# program Build-AgentHook
    publishes on import) bounds every Bash call an agent makes, foreground and background.

Limits are keyed by environment (devbox | pipeline) and shell, one of the execution engines (pwsh | bash | zsh):

  limits:
    <devbox|pipeline>:
      bash: { foreground: <s>, background: <s> }   # the hook's limits for a Claude/agent Bash call
      pwsh: <s>                                    # Invoke-WithTimeout and Invoke-Executable without an entry
      zsh: <s>                                     # a zsh run; the hook governs bash only, so zsh takes the pwsh-side defaults

  tests:                                           # Test-Automation's timing report (Get-TestTimeLimits)
    level_ms: { L0: <ms>, L1: <ms>, L2: <ms>, L3: <ms>, L4: <ms> }   # the most one test of a tier may take
    run_seconds: <s>                     # the budget for a whole run up to L3, which fails a devbox run over it; L4 is a stage of its own
  commands:
    <Verb-Noun>: <s>                               # overrides a function's own [TimeLimit] decoration

A function whose work is long by nature declares its limit beside its code, as a [Catzc.Base.Timeouts.TimeLimit]
attribute; Get-TimeoutSeconds -Command resolves an exemption, then `commands`, then the decoration, then the
environment's pwsh limit ([ADR-PWSH-ASSERT-DECLAREDTIMELIMIT](/docs/drs/automation/pwsh/assert-idioms.md#rule-adr-pwsh-assert-declaredtimelimit)).

Every key is optional: the sensible defaults are declared once, on TimeoutsConfig, so this file states only what
has been tuned. The devbox defaults are deliberately tight while the blockers are tuned: a call that
legitimately needs longer gets an entry under `executables` or a budget, not a raised default.
```

## comment:2

Above `executables:`, written with `#`.

```text
Per-executable limits, keyed by the executable's name without directory or extension (`dotnet`, not
`C:\...\dotnet.exe`). These are the tools whose ordinary runs outlast the default.
```
