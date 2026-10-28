# pwsh/Base.QualityGates/private/Invoke-ScriptAnalyzerShards.ps1

Runs PSScriptAnalyzer over the pending files of each analyzer pass, sharded across background processes, and returns the diagnostics by
pass.

## help

### synopsis

Runs PSScriptAnalyzer over the pending files of each analyzer pass, sharded across background processes, returning the diagnostics by pass.

### description

A single serial Invoke-ScriptAnalyzer call over the whole module tree takes ~90s and prints nothing until it finishes (it looks hung). This
shards each pass's files across background pwsh PROCESSES — the same approach, and for the same reasons, as the L2 'PSScriptAnalyzer' test
(pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1):

- PSScriptAnalyzer's Helper.Initialize is not thread-safe, so ForEach-Object -Parallel (shared runspaces) races and throws. Separate
  processes are fully isolated.
- Each shard imports the analyzer once and pipes its whole file list through a SINGLE Invoke-ScriptAnalyzer call, so the ~3s per-process
  setup is paid once per shard, not per file.
- Each shard imports the vendored analyzer from the loaded code root (Get-CatzcModulesRoot/.vendor).
- Shards run from the repo root (Push-Location/Pop-Location) so the settings' relative CustomRulePath entries resolve (record
  working-directory-mechanics, rule
  [ADR-PWSH-PWD-RESTORESETLOCATION](../../../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-restoresetlocation)/[ADR-PWSH-PWD-PUSHPOPINFINALLY](../../../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-pushpopinfinally)).
- Each shard reads the settings file itself and applies its pass's rule selection (`IncludeRules`, or extra `ExcludeRules`): a job's
  arguments are serialized, and the settings parser wants its own types back.

The passes share one shard budget, split by their file counts, each pass at least one shard. A dot is printed per interval while shards run
so the run never looks hung — a progress bar is banned (record console-output-matters, rule
[ADR-AUTO-CONSOLE-NOBOXDRAWING](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-noboxdrawing)). The external
Invoke-ScriptAnalyzer progress bar is suppressed inside the worker for the same reason.

### parameter `Batch`

One entry per pass with files pending: its `Label`, `Files`, `SettingsPath`, `IncludeRule` and `ExcludeRule`.

### parameter `RepositoryRoot`

The repository root the shards run from.

### outputs

`[hashtable]` Each pass's label mapped to the diagnostic records its shards returned.

## Where it runs

The vendored analyzer ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).
The shards still run from the repository root, because the settings' `CustomRulePath` entries are relative to it.

## Shard budget

The shard count tracks the CPU count, capped so that the process setup the work cannot amortize is not spawned, and it never exceeds the
file count. Each batch gets its share of the budget by file count, at least one shard. Round-robin spreads the heavy modules.

## Settings

Each shard reads the settings itself and does not take them as an argument. A job's arguments are serialized, and the settings parser wants
its own types back.

## Progress

The analyzer draws its own progress bar, and the repository bans progress bars
([ADR-AUTO-CONSOLE-NOBOXDRAWING](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-noboxdrawing)). The shard
suppresses that bar for the duration of the call and restores the preference in `finally`. The parent prints a dot per interval while shards
run. The dots go through the writer chokepoint ([ADR-PWSH-ANNOUNCE-INFORMATIONCHOKEPOINT][r1]), so a Pester run silences them with
everything else. The closing newline fires only when a dot was written.

## Failures

A shard that fails silently would drop its files' diagnostics and let violations pass unnoticed, so any failure is loud. Non-terminating
analyzer errors are captured and surfaced as a shard failure, and a job that did not complete fails the run. There is no transient case to
tolerate: the settings file excludes the built-in `PSReservedCmdletChar` rule, which dereferences the analyzer's thread-unsafe helper
runspace under concurrent load. Any error is real, and the run never retries
([ADR-AUTO-RETRY-NEVERINTESTS](../../../../drs/automation/retry-as-last-resort.md#rule-adr-auto-retry-neverintests)).

[r1]: ../../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationchokepoint
