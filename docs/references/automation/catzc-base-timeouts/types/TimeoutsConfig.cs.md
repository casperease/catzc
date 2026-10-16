---
catzc:
  immutable:
    with_body_sha: "7f5aa1c12590"
    path: docs/references/automation/catzc-base-timeouts/types/TimeoutsConfig.cs.md
    folder: docs/references/automation/catzc-base-timeouts/types
    name: timeouts-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Timeouts/types/TimeoutsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The time safeguards (configs/timeouts.yml) — how long a call may run before it is stopped. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Timeouts.TimeoutsConfig), so Get-Config -Config timeouts
returns this typed record; Get-TimeoutSeconds resolves a limit from it. Mirrors the YAML keys verbatim
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The Claude Code Bash
hook (.claude/hooks/Assert-BashTimeout/) compiles this same file, so the hook and the pwsh side share one parser
and one set of defaults.

Limits are keyed on two axes: the environment (devbox | pipeline, from Get-RunEnvironment) and the shell, one of the
execution engines (pwsh | bash | zsh). bash carries a foreground and a background limit (the hook bounds both, and
it governs the Bash tool only); every other engine carries one limit, with the same defaults, for the work bounded
outside the hook (Invoke-WithTimeout, Invoke-Executable, a zsh run). The sensible defaults are declared here, once
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), so an empty file and a
fresh checkout behave the same; the file states only what is tuned.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only known keys at every level ('limits', 'executables', 'commands'; devbox | pipeline; pwsh | bash | zsh;
    foreground | background) — an unknown key (a typo) fails fast at load;
  - every limit is a positive whole number (a YAML plain integer — a quoted '10' is rejected); there is no
    "no limit" value, so every call runs inside a safeguard;
  - a bash background limit is at least its foreground limit;
  - 'executables' maps a bare executable name (no directory, no extension) to a positive whole number;
  - 'commands' maps a function name (Verb-Noun) to a positive whole number — the config layer above a function's own
    [TimeLimit] decoration (Get-TimeoutSeconds -Command);
  - 'tests' holds the test-run time limits (Get-TestTimeLimits): 'level_ms' maps a test tier (TestTiers.Names, L0 to
    L4) to the most milliseconds one test of that tier may take, and 'run_seconds' is the budget for a whole
    Test-Automation run up to L3 (an L4 run is a stage of its own). Both are positive whole numbers, with defaults
    declared here.
```

## comment:2

Above `private static readonly Dictionary<string, int> TestLevelDefaults = new...`, written with `//`.

```text
The sensible test-run defaults: an L0 logic test is milliseconds, an L1 integrity test a couple of seconds, an L2
test that drives a real tool tens of seconds, an L3 vertical system test up to two minutes, an L4 test of the
released system through its public edge (DNS, TLS, a cold start) up to ten; a whole run up to L3 fits in three
minutes.
```

## comment:3

Above `private static readonly string[] Shells = new...`, written with `//`.

```text
The shells a limit is keyed by: the execution engines, declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
```

## comment:4

Above `private static readonly Dictionary<string, int> Defaults = new...`, written with `//`.

```text
The sensible defaults: tight on a devbox, where the blockers are tuned together; looser in a pipeline, where
nobody watches and a long build is ordinary — but still bounded. zsh takes the pwsh-side limits: the hook does
not govern it.
```

## comment:5

Above `public IDictionary limits { get; }`, written with `//`.

```text
The resolved limits, defaults filled in: limits[devbox|pipeline][bash] is { foreground, background },
limits[devbox|pipeline][pwsh|zsh] is that shell's one limit. A read-only view for display; resolve through
SecondsFor.
```

## comment:6

Above `public IReadOnlyDictionary<string, int> executables { get; }`, written with `//`.

```text
Per-executable limits in seconds, keyed by the bare executable name (case-insensitive). Empty when the file
declares none.
```

## comment:7

Above `public int SecondsFor(string environment, string shell, bool background)`, written with `//`.

```text
The limit for a shell call in an environment. environment is devbox | pipeline and shell is pwsh | bash | zsh
(case-insensitive); background applies to bash only.
```

## comment:8

Above `public int SecondsForExecutable(string environment, string executable)`, written with `//`.

```text
The limit for an executable that pwsh code runs: its own entry when it has one, otherwise the environment's
pwsh limit. The name may carry a directory and an extension (`C:\tools\dotnet.exe`); only the bare name is
looked up.
```
