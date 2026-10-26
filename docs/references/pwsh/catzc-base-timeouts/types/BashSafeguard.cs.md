# pwsh/Base.Timeouts/types/BashSafeguard.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The Bash time safeguard's verdict on one Claude Code Bash call
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](/docs/drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)). The PreToolUse hook
(.claude/hooks/Assert-BashTimeout/) compiles this same file, so the hook's decision and its L0 tests in
Catzc.Base.Timeouts are one implementation.

Every Bash call runs inside a limit from TimeoutsConfig for the run environment (devbox | pipeline):
  - a foreground call passes `timeout` (ms) no larger than limits.<env>.bash.foreground;
  - a background call — whose `timeout` the Bash tool ignores — starts with a GNU `timeout <duration>`
    no longer than limits.<env>.bash.background, around a single command (BoundedCommand, in the bash grammar).
    A compound command would leave the commands after the first unbounded, so it is denied: put longer work in a
    script.
A call that breaks this is denied. The hook never rewrites a command: a hook "allow" skips the permission prompt
and a rewritten command can slip past deny rules, so denial is the only verdict that leaves every other
safeguard in place. What the context changes is the reason: the main session raises the blocker with the user,
a subagent (payload `agent_id`) reports it to its coordinator, a pipeline fixes the call or the limit.
```

## comment:2

Above `public static string EnvironmentOf(string tfBuild, string githubActions)`, written with `//`.

```text
The run environment, by the same test as Test-IsRunningInPipeline: either variable set to any non-empty
value means a pipeline.
```

## comment:3

Above `public static string Decide(string payload, TimeoutsConfig config, string...`, written with `//`.

```text
The verdict for one hook payload: null to let the call through, or the reason to deny it. logLine is a
tab-separated record of a denial (null when allowed) — the tuning list of blockers.
```

## comment:4

Above `public static string FindConfig(string repositoryRoot)`, written with `//`.

```text
The hook runs outside cats, so it finds the modules folder by the one top-level folder that holds this config
([ADR-AUTO-LAYERS](/docs/drs/automation/layers.md)).
```

## comment:5

Above `public const string ConfigModulePath = "Base.Timeouts/configs/timeouts.yml";`, written with `//`.

```text
The module's folder, without the namespace: the hook runs before any session and cannot resolve it
([DDR-TRACK-MODULENAMESPACE](/docs/drs/design/tracks.md#rule-ddr-track-modulenamespace)).
```
