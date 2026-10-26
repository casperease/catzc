# pwsh/Base.Timeouts/types/BashSafeguard.cs

The Bash time safeguard's verdict on one Claude Code Bash call: it returns nothing to let the call through, or the reason to deny it
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)).

## One implementation

The PreToolUse hook (`.claude/hooks/Assert-BashTimeout/`) compiles this same file, so the hook's decision and its L0 tests in
`Catzc.Base.Timeouts` are one implementation.

## The rule

Every Bash call runs inside a limit from `TimeoutsConfig` for the run environment (`devbox` or `pipeline`):

- a foreground call passes `timeout` (ms) no larger than `limits.<env>.bash.foreground`;
- a background call, whose `timeout` the Bash tool ignores, starts with a GNU `timeout <duration>` no longer than
  `limits.<env>.bash.background`, around a single command (`BoundedCommand`, in the bash grammar). A compound command would leave the
  commands after the first unbounded, so it is denied: longer work goes in a script.

A call that breaks this is denied.

## Why denial is the only verdict

The hook never rewrites a command: a hook "allow" skips the permission prompt and a rewritten command can slip past deny rules, so denial is
the only verdict that leaves every other safeguard in place. What the context changes is the reason: the main session raises the blocker
with the user, a subagent (payload `agent_id`) reports it to its coordinator, a pipeline fixes the call or the limit.

## The members

- `EnvironmentOf` names the run environment by the same test as `Test-IsRunningInPipeline`: either variable set to any non-empty value means
  a pipeline.
- `Decide` is the verdict for one hook payload: null to let the call through, or the reason to deny it. Its `logLine` is a tab-separated
  record of a denial (null when allowed), the tuning list of blockers.
- `FindConfig` is how the hook, which runs outside cats, finds the modules folder: by the one top-level folder that holds this config
  ([ADR-AUTO-LAYERS](../../../../drs/automation/layers.md)).
- `ConfigModulePath` is the module's folder without the namespace: the hook runs before any session and cannot resolve it
  ([DDR-TRACK-MODULENAMESPACE](../../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)).
