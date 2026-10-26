# .claude/hooks/Assert-BashTimeout/Program.cs

The Claude Code PreToolUse hook that denies a Bash call that does not run inside the time safeguard
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)).

## One decision, shared

The decision is `Catzc.Base.Timeouts.BashSafeguard` and the limits are `Catzc.Base.Timeouts.TimeoutsConfig`. They are the module's own source
files, compiled into this program (see the `.csproj`), so the hook, `Get-TimeoutSeconds` and the L0 tests share one parser, one set of
defaults and one verdict
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## What the file does itself

Only the input and output: it reads the payload from stdin, loads `timeouts.yml`, detects the run environment, prints a denial, and appends
each denial to `out/time-safeguard.log`, the list of blockers to tune. `LoadYaml` returns `timeouts.yml` as the nested dictionary
`TimeoutsConfig` takes, typed the way the module's YAML loader types it: a plain integer is a number, a plain float a double, and a quoted
scalar stays a string.

## Denying when it cannot decide

The safeguard is a control: when it cannot decide, it denies, and the reason names why
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)).

## The git topic commands

The git topic commands change the repository, so they run only at the user's hand
([FDR-GIT-USERRUNSGIT](../../../../drs/flow/git-topic-flow.md#rule-fdr-git-userrunsgit)); the hook denies them as well.

## Why a compiled program

It runs before every Bash call, and as a compiled program it starts in about a third of the time a pwsh script does. `Build-AgentHook`
publishes it to `.claude/hooks/bin/`, from where the repository root is three folders up.
