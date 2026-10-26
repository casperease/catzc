# pwsh/Base.Timeouts/types/TimeoutsConfig.cs

The typed record of the time safeguards (`configs/timeouts.yml`): how long a call may run before it is stopped.

## Registration

It is registered in `Catzc.Base.Config/configs/configs.yml` (type `Catzc.Base.Timeouts.TimeoutsConfig`), so `Get-Config -Config timeouts`
returns this typed record, and `Get-TimeoutSeconds` resolves a limit from it. It mirrors the YAML keys verbatim
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The Claude
Code Bash hook (`.claude/hooks/Assert-BashTimeout/`) compiles this same file, so the hook and the pwsh side share one parser and one set of
defaults.

## Two axes

Limits are keyed on the environment (`devbox` or `pipeline`, from `Get-RunEnvironment`) and the shell, one of the execution engines
(`pwsh`, `bash`, `zsh`), declared once
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). bash carries a foreground and
a background limit (the hook bounds both, and it governs the Bash tool only); every other engine carries one limit, with the same defaults,
for the work bounded outside the hook (`Invoke-WithTimeout`, `Invoke-Executable`, a zsh run).

## Defaults

The sensible defaults are declared here, once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), so an empty
file and a fresh checkout behave the same; the file states only what is tuned.

- The limits are tight on a devbox, where the blockers are tuned together, and looser in a pipeline, where nobody watches and a long build is
  ordinary, but still bounded. zsh takes the pwsh-side limits: the hook does not govern it.
- The test-run defaults: an L0 logic test is milliseconds, an L1 integrity test a couple of seconds, an L2 test that drives a real tool tens
  of seconds, an L3 vertical system test up to two minutes, an L4 test of the released system through its public edge (DNS, TLS, a cold start)
  up to ten; a whole run up to L3 fits in three minutes.
- The wait defaults of `Watch-Blocking` are one second and one millisecond, one pair for every environment. `drain_seconds` is how long
  `Invoke-Executable` waits for a run's output to end after its process exits, before it names a child that holds the output open.
- The machine's run lock has its own keys: how long a run waits past a live holder's deadline, how old a queue ticket may be before it is
  dropped, and the budget a run has in all, the background roof, so a waiter stops early when the holder will not finish within it. The
  default budget, 280 s, sits under the 300 s a background call usually gives its command, so a waiter stops with its own "retry after it"
  line before the call's timeout kills it.

## Validation

Constructing an instance validates the file, collecting every violation into one `ArgumentException`:

- only known keys at every level (`limits`, `executables`, `commands`; devbox or pipeline; pwsh, bash or zsh; foreground or background): an
  unknown key (a typo) fails fast at load;
- every limit is a positive whole number (a YAML plain integer; a quoted `'10'` is rejected); there is no "no limit" value, so every call runs
  inside a safeguard;
- a bash background limit is at least its foreground limit;
- `executables` maps a bare executable name (no directory, no extension) to a positive whole number;
- `commands` maps a function name (Verb-Noun) to a positive whole number, the config layer above a function's own `[TimeLimit]` decoration
  (`Get-TimeoutSeconds -Command`);
- `tests` holds the test-run time limits (`Get-TestTimeLimits`): `level_ms` maps a test tier (`TestTiers.Names`, L0 to L4) to the most
  milliseconds one test of that tier may take, and `run_seconds` is the budget for a whole `Test-Automation` run up to L3 (an L4 run is a stage
  of its own). Both are positive whole numbers, with defaults declared here.

## The members

- `limits` is the resolved limits, defaults filled in: `limits[devbox|pipeline][bash]` is `{ foreground, background }`, and
  `limits[devbox|pipeline][pwsh|zsh]` is that shell's one limit. It is a read-only view for display; resolve through `SecondsFor`.
- `executables` is the per-executable limits in seconds, keyed by the bare executable name (case-insensitive), empty when the file declares
  none.
- `SecondsFor` is the limit for a shell call in an environment; environment and shell are case-insensitive, and `background` applies to bash
  only.
- `SecondsForExecutable` is the limit for an executable that pwsh code runs: its own entry when it has one, otherwise the environment's pwsh
  limit. The name may carry a directory and an extension (`C:\tools\dotnet.exe`); only the bare name is looked up.
