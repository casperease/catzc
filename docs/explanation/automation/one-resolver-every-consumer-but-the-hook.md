---
catzc:
  derived:
    path: docs/explanation/automation/one-resolver-every-consumer-but-the-hook.md
    kind: explanation
    language: markdown
    track: docs
    body_sha: "6338c39818a8"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-FAILFAST#7
    links:
      - docs/.assets/explanation/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.md
      - docs/.assets/explanation/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.png
      - docs/adr/automation/fail-fast-with-asserts.md
      - docs/adr/automation/sensible-defaults.md
      - docs/explanation/automation/a-stopped-run-names-its-limit.md
      - docs/explanation/automation/callers-value-else-config-else-default.md
      - docs/explanation/automation/index.md
      - docs/explanation/automation/one-rule-per-stage-and-two-gaps.md
      - docs/explanation/automation/resolve-one-limit-in-code-order.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# One resolver serves every consumer but the hook, which compiles the same config type

```text
One resolver, Get-TimeoutSeconds, serves every consumer of the time safeguard but the hook, which compiles the same config type.

1  Get-RunEnvironment       the environment axis: Devbox or Pipeline, read from the session
2  TimeoutsConfig           the type that maps timeouts.yml and declares every default
3  TimeoutExemptionsConfig  the type that maps timeout-exemptions.yml and declares the ceilings
4  Get-TimeoutSeconds       the resolver: environment, config, then exemption, one answer
5  Assert-BashTimeout       the hook that bounds an agent's Bash calls; it compiles TimeoutsConfig itself
6  Invoke-Executable        a native tool's run, bounded by its executable's limit
7  Invoke-WithTimeout       a script block's run, bounded by the pwsh limit or a budget's ceiling

Supports ADR-AUTO-FAILFAST#7 and ADR-AUTO-DEFAULT#6 (architecture lens).
```

The time safeguard of cats has one resolver. `Get-TimeoutSeconds` reads the run environment, the limits config and the exemptions, and hands
every consumer in pwsh its limit, so tuning a limit is one edit to one file. The one consumer that does not call it is the Bash hook, a
compiled program that runs before every shell call a coding agent makes; it compiles the resolver's own config type into itself, so the hook
and the pwsh side share one parser and one set of defaults without sharing a process.

![One resolver serves every consumer but the hook](../../.assets/explanation/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-auto-failfast--one-resolver-every-consumer-but-the-hook--architecture.drawio.md).

## Walkthrough

1. **Get-RunEnvironment.** The environment axis of the limits. It answers `Devbox` or `Pipeline` from the one pipeline-detection function,
   `Test-IsRunningInPipeline` in the internal loader, which reads the variables an Azure DevOps or GitHub Actions agent sets. A caller may
   pin the expected environment with `-EnvironmentAssertIs`; the guard verifies and never selects.
2. **TimeoutsConfig.** The typed record that `Get-Config -Config timeouts` returns. It validates `timeouts.yml` when it loads, keeps the
   per-executable entries, and declares the sensible defaults once, for both environments and for every execution engine, with a foreground
   and a background limit for bash.
3. **TimeoutExemptionsConfig.** The typed record behind `timeout-exemptions.yml`. It validates each exemption, a single budget GUID or an
   inclusive range, with a reason and, optionally, a scope, and declares the default ceilings: 600 seconds on a devbox, 3600 in a pipeline.
4. **Get-TimeoutSeconds.** The resolver. With `-Executable` it returns the executable's own entry or the environment's pwsh limit; with
   `-Shell` it returns that engine's limit, and with `-Budget` it raises an exempt budget to the ceiling through `Get-TimeoutExemption`,
   never lowering it. A third form, `-Command`, resolves a function's own `[TimeLimit]` declaration the same way.
5. **Assert-BashTimeout.** The PreToolUse hook in `.claude/hooks/`. It does not call the resolver; its project compiles `TimeoutsConfig.cs`
   and `BashSafeguard.cs` from the module's own sources, loads `timeouts.yml`, detects the environment by the same test, and denies a call
   outside the bash limits. It never reads the exemptions.
6. **Invoke-Executable.** The wrapper for every native tool. In its default mode it asks `Get-TimeoutSeconds -Executable` for the bare
   executable's limit and kills the whole process tree past it.
7. **Invoke-WithTimeout.** The wrapper for in-process work. It asks `Get-TimeoutSeconds -Budget` for the pwsh limit or the budget's ceiling,
   and stops the script block past it. `Assert-CompletesWithin` and `Test-CompletesWithin` are its assertion and boolean forms.

## Why it holds

- The limits live in one config owned by `Catzc.Base.Timeouts`, keyed by run environment and execution engine, with sensible defaults
  declared on its config type; `Invoke-Executable`, `Invoke-WithTimeout` and the hook are the consumers the decision names, and the hook
  compiles the module's own config and verdict types so its limits are the ones `Get-TimeoutSeconds` resolves (ADR-AUTO-FAILFAST#7).
- The sensible default is declared exactly once, on the config type, so no function and no second file restates it (ADR-AUTO-DEFAULT#6).

## Where the code and the ADR differ

The ADR lets an exemption raise the limit of an agent's bash call, and the exemptions file accepts a bash ceiling and a `shell: bash` scope,
but the hook reads `TimeoutsConfig` only, so no bash exemption can raise a limit. The ADR also bounds every external call, yet
`Invoke-Executable -Direct` runs with no limit.

## See also

- [Fail fast with inline assertions](../../adr/automation/fail-fast-with-asserts.md) and
  [Sensible defaults for all parameters](../../adr/automation/sensible-defaults.md) — the decisions this article explains.
- The other lenses on the same resolution: [meta](callers-value-else-config-else-default.md),
  [implementation](resolve-one-limit-in-code-order.md), [operations](a-stopped-run-names-its-limit.md) and
  [governance](one-rule-per-stage-and-two-gaps.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
