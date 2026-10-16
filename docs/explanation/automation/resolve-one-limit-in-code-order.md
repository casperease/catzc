---
catzc:
  derived:
    path: docs/explanation/automation/resolve-one-limit-in-code-order.md
    kind: explanation
    language: markdown
    track: docs
    body_sha: f02beea63479
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-FAILFAST#7
    links:
      - docs/.assets/explanation/adr-auto-failfast--resolve-one-limit-in-code-order--implementation.drawio.md
      - docs/.assets/explanation/adr-auto-failfast--resolve-one-limit-in-code-order--implementation.drawio.png
      - docs/adr/automation/fail-fast-with-asserts.md
      - docs/adr/automation/sensible-defaults.md
      - docs/explanation/automation/a-stopped-run-names-its-limit.md
      - docs/explanation/automation/callers-value-else-config-else-default.md
      - docs/explanation/automation/index.md
      - docs/explanation/automation/one-resolver-every-consumer-but-the-hook.md
      - docs/explanation/automation/one-rule-per-stage-and-two-gaps.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# Get-TimeoutSeconds resolves the environment, the config entry, then the exemption ceiling, in that order

```text
Get-TimeoutSeconds resolves the run environment, then the config entry or default, then the exemption ceiling, in that code order.

1  Get-RunEnvironment      Devbox or Pipeline, the first thing the resolver reads
2  timeouts.yml            the limits config: 22 executable entries today, no limits block
3  TimeoutsConfig          the typed record with the defaults; SecondsFor and SecondsForExecutable
4  timeout-exemptions.yml  the exemptions and ceilings; exempt: [] today
5  Get-TimeoutSeconds      -Executable, -Shell -Background, -Budget: one answer in seconds
6  Assert-BashTimeout      the hook asks TimeoutsConfig.SecondsFor for bash directly
7  Invoke-Executable       defaults -TimeoutSeconds to Get-TimeoutSeconds -Executable
8  Invoke-WithTimeout      defaults -Seconds to Get-TimeoutSeconds -Budget

Supports ADR-AUTO-FAILFAST#7 and ADR-AUTO-DEFAULT#6 (implementation lens).
```

`Get-TimeoutSeconds` is a short function, and its code order is the resolution order of the time safeguard. It reads the run environment,
loads the limits config as its typed record, asks that record for the limit of an executable or a shell, and only then, for a budget that is
exempt, raises the answer to the exemption ceiling. Each consumer in cats asks it from a parameter default, so the caller's explicit value,
the config, and the default on the type are tried in exactly that order.

![Get-TimeoutSeconds resolves the environment, the config entry, then the exemption ceiling](../../.assets/explanation/adr-auto-failfast--resolve-one-limit-in-code-order--implementation.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-auto-failfast--resolve-one-limit-in-code-order--implementation.drawio.md).

## Walkthrough

1. **Get-RunEnvironment.** The first call. It returns `Devbox` or `Pipeline`, and `-EnvironmentAssertIs` is passed through only when the
   caller gave it, to verify the environment rather than select it.
2. **timeouts.yml.** The limits config of `Catzc.Base.Timeouts`, loaded next through `Get-Config -Config timeouts`. Today it holds 22
   entries under `executables`, among them `pwsh` 360, `dotnet` 600, `az` 1800, `gh` 120 and `go` 900, and no `limits` block: every
   environment and shell limit is the declared default.
3. **TimeoutsConfig.** The record the file becomes. `SecondsFor(environment, shell, background)` answers a shell's limit, and
   `SecondsForExecutable(environment, name)` answers an executable's own entry, looked up by the bare name with directory and extension
   dropped, or else the environment's pwsh limit. An entry is not keyed by environment and replaces the limit: `gh`, `cspell`, `prettier`
   and `markdownlint-cli2` at 120 seconds and `tar` at 300 sit below the pipeline's pwsh default of 600.
4. **timeout-exemptions.yml.** The exemptions config, loaded only when a budget is given. Its record validates each entry and declares the
   ceilings, 600 seconds on a devbox and 3600 in a pipeline for every shell. The list is empty today.
5. **Get-TimeoutSeconds.** Three parameter sets. `-Executable` returns `SecondsForExecutable` and stops there. The default set takes
   `-Shell`, `-Background` for bash, and `-Budget`: it takes `SecondsFor`, and when `Get-TimeoutExemption` finds the budget for this
   environment and shell, returns the larger of that limit and `CeilingFor`. Because `-Budget` belongs to the shell set only, an
   executable's limit cannot be exempted. The third set, `-Command`, resolves a function's `[TimeLimit]` declaration: an exemption for its
   budget, then a `commands` entry, then the declaration, then the pwsh limit.
6. **Assert-BashTimeout.** The hook does not call the function. It constructs `TimeoutsConfig` from `timeouts.yml` itself and asks
   `SecondsFor(environment, "bash", background)` for the foreground or background limit of the call it is judging.
7. **Invoke-Executable.** Its `-TimeoutSeconds` is bound to at least one second, and when the caller omits it the default mode asks
   `Get-TimeoutSeconds -Executable` with the executable name `CliRunner` parses from the command. The function has no `-Budget`.
8. **Invoke-WithTimeout.** Its `-Seconds` defaults to `Get-TimeoutSeconds -Budget $Budget`, as do `Assert-CompletesWithin` and
   `Test-CompletesWithin`, which call it. A value the caller passes is bounded the same way and overrides everything.

## Why it holds

- The limits live in one config keyed by run environment and execution engine, with sensible defaults on the config type and per-executable
  entries, and no "no limit" value; `Invoke-Executable` kills a process tree at its executable's limit, the in-process wrappers stop a
  script block at theirs, and an exemption raises a budget's limit to a ceiling but never lifts it (ADR-AUTO-FAILFAST#7).
- The explicit value, else the module's configuration read through `Get-Config`, else the default declared once on the config type, is the
  one resolution order of every configurable setting (ADR-AUTO-DEFAULT#6).

## Where the code and the ADR differ

The ADR presents a per-executable entry as the remedy for a call that needs longer, but an entry replaces the limit in every environment and
may lower it. The ADR lets an exemption raise an agent's bash limit, and the exemptions file accepts a bash ceiling and a `shell: bash`
scope, but the hook never reads them. The ADR bounds every external call, yet `Invoke-Executable -Direct` has no limit.

## See also

- [Fail fast with inline assertions](../../adr/automation/fail-fast-with-asserts.md) and
  [Sensible defaults for all parameters](../../adr/automation/sensible-defaults.md) — the decisions this article explains.
- The other lenses on the same resolution: [meta](callers-value-else-config-else-default.md),
  [architecture](one-resolver-every-consumer-but-the-hook.md), [operations](a-stopped-run-names-its-limit.md) and
  [governance](one-rule-per-stage-and-two-gaps.md).
- [The automation explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
