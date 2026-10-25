# pwsh/Catzc.Base.QualityGates/private/Invoke-ScriptAnalyzerShards.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
- Shards run from the repo root (Push-Location/Pop-Location) so the settings' relative CustomRulePath entries resolve (ADR
  working-directory-mechanics, rule
  [ADR-PWSH-PWD-RESTORESETLOCATION](../../../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-restoresetlocation)/[ADR-PWSH-PWD-PUSHPOPINFINALLY](../../../../drs/automation/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-pushpopinfinally)).
- Each shard reads the settings file itself and applies its pass's rule selection (`IncludeRules`, or extra `ExcludeRules`): a job's
  arguments are serialized, and the settings parser wants its own types back.

The passes share one shard budget, split by their file counts, each pass at least one shard. A dot is printed per interval while shards run
so the run never looks hung — a progress bar is banned (ADR console-output-matters, rule
[ADR-AUTO-CONSOLE-NOBOXDRAWING](../../../../drs/automation/console-output-matters.md#rule-adr-auto-console-noboxdrawing)). The external
Invoke-ScriptAnalyzer progress bar is suppressed inside the worker for the same reason.

### parameter `Batch`

One entry per pass with files pending: its `Label`, `Files`, `SettingsPath`, `IncludeRule` and `ExcludeRule`.

### parameter `RepositoryRoot`

The repository root the shards run from.

### outputs

`[hashtable]` Each pass's label mapped to the diagnostic records its shards returned.

## comment:1

Above `$analyzerPath = Join-Path (Get-CatzcModulesRoot) '.vendor/PSScriptAnalyzer'`, written with `#`.

```text
The vendored analyzer ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](/docs/drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency)).
The shards still run from the repository root: the settings' CustomRulePath entries are relative to it.
```

## comment:2

Above `$budget = [Math]::Min([Math]::Max(1,...`, written with `#`.

```text
Shard count tracks CPU but is capped so we don't spawn more process setup than the work can amortize,
and never exceeds the file count.
```

## comment:3

Above `$savedProgress = $ProgressPreference`, written with `#`.

```text
Invoke-ScriptAnalyzer draws its own Write-Progress bar; this repo bans progress bars (ADR
console-output-matters, rule
[ADR-AUTO-CONSOLE-NOBOXDRAWING](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-noboxdrawing)) and
reports shard progress with dots instead. Suppress the
external bar for the duration of the call and restore the preference in finally.
```

## comment:4

Above `$err = $null`, written with `#`.

```text
Capture non-terminating analyzer errors (-ErrorAction SilentlyContinue + -ErrorVariable) and
surface any as a shard failure, rather than letting a shard silently drop its files' diagnostics.
This used to special-case an intermittent NullReferenceException and tell the user to re-run; that
flake was root-caused to the built-in PSReservedCmdletChar rule dereferencing PSScriptAnalyzer's
thread-unsafe helper runspace under concurrent load, and eliminated by excluding that rule in
PSScriptAnalyzerSettings.psd1. So there is no transient case to tolerate — any error is real and
fails loudly (ADR diagnostics-over-retry; we never retry,
[ADR-AUTO-RETRY-NEVERINTESTS](/docs/drs/automation/retry-as-last-resort.md#rule-adr-auto-retry-neverintests)).
```

## comment:5

Above `$dotted = $false`, written with `#`.

```text
Print a dot per interval while shards run, rather than a progress bar (ADR console-output-matters,
rule [ADR-AUTO-CONSOLE-NOBOXDRAWING](/docs/drs/automation/console-output-matters.md#rule-adr-auto-console-noboxdrawing)). The
dots go through the writer chokepoint
([ADR-PWSH-ANNOUNCE-INFORMATIONSTREAMCHOKEPOINT](/docs/drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-informationstreamchokepoint)), so a
Pester run
silences them with everything else. $dotted tracks whether any dot was written so the closing newline only
fires when it is needed.
```

## comment:6

Above `if ($item.Job.State -ne 'Completed') {`, written with `#`.

```text
A silently-failed shard would drop its files' diagnostics and let violations pass unnoticed —
fail loudly instead.
```
