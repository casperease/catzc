---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md
    kind: comment-page
    body_sha: "72ea4705e63d"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-CONSOLE#8
      - ADR-AUTO-RETRY#1
      - ADR-PWSH-ANNOUNCE#1
      - ADR-PWSH-PWD#2
      - ADR-PWSH-PWD#3
---

# automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The analysis engine behind Test-ScriptAnalyzer. A single serial Invoke-ScriptAnalyzer pass over the whole
module tree takes ~90s and prints nothing until it finishes (it looks hung). This shards the file list
across background pwsh PROCESSES — the same approach, and for the same reasons, as the L2 'PSScriptAnalyzer'
test (automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1):

  - PSScriptAnalyzer's Helper.Initialize is not thread-safe, so ForEach-Object -Parallel (shared runspaces)
    races and throws. Separate processes are fully isolated.
  - Each shard imports the analyzer once and pipes its whole file list through a SINGLE
    Invoke-ScriptAnalyzer call, so the ~3s per-process setup is paid once per shard, not per file.
  - Each shard imports the vendored analyzer from the loaded code root (Get-CatzcModulesRoot/.vendor).
  - Shards run from the repo root (Push-Location/Pop-Location) so the settings' relative CustomRulePath
    entries resolve (ADR working-directory-mechanics, rule
    [ADR-PWSH-PWD#2](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd2)/[ADR-PWSH-PWD#3](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd3)).

A dot is printed per interval while shards run so the run never looks hung — a progress bar is banned
(ADR console-output-matters, rule
[ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)). The
external Invoke-ScriptAnalyzer progress bar is suppressed
inside the worker for the same reason.
A result cache under out/cache/ skips every file the analyzer last found clean whose bytes and analyzer inputs
(Get-ScriptAnalyzerInputs: the settings, the custom rules, the vendored analyzer, the spelling oracle's word lists)
are unchanged since ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)); only clean files
are recorded, so a cached run reports exactly the diagnostics a full run would. A pipeline starts without the cache.
```

## comment:2

Above `$root = Get-RepositoryRoot`.

```text
The vendored analyzer ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
The shards still run from the repository root: the settings' CustomRulePath entries are relative to it.
```

## comment:3

Above `$fullRoot = [System.IO.Path]::GetFullPath($root)`.

```text
The result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): a file the analyzer
last found clean, whose bytes and analyzer inputs (Get-ScriptAnalyzerInputs) are unchanged since, is not analyzed
again — it has no diagnostics by construction. Only files with no diagnostics are ever recorded.
```

## comment:4

Above `$shardCount = [Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10))`.

```text
Shard count tracks CPU but is capped so we don't spawn more process setup than the work can amortize,
and never exceeds the file count.
```

## comment:5

Above `$savedProgress = $ProgressPreference`.

```text
Invoke-ScriptAnalyzer draws its own Write-Progress bar; this repo bans progress bars (ADR
console-output-matters, rule
[ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)) and
reports shard progress with dots instead. Suppress the
external bar for the duration of the call and restore the preference in finally.
```

## comment:6

Above `$err = $null`.

```text
Capture non-terminating analyzer errors (-ErrorAction SilentlyContinue + -ErrorVariable) and
surface any as a shard failure, rather than letting a shard silently drop its files' diagnostics.
This used to special-case an intermittent NullReferenceException and tell the user to re-run; that
flake was root-caused to the built-in PSReservedCmdletChar rule dereferencing PSScriptAnalyzer's
thread-unsafe helper runspace under concurrent load, and eliminated by excluding that rule in
PSScriptAnalyzerSettings.psd1. So there is no transient case to tolerate — any error is real and
fails loudly (ADR diagnostics-over-retry; we never retry,
[ADR-AUTO-RETRY#1](/docs/adr/automation/retry-as-last-resort.md#rule-adr-auto-retry1)).
```

## comment:7

Above `$dotted = $false`.

```text
Print a dot per interval while shards run, rather than a progress bar (ADR console-output-matters,
rule [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)). The
dots go through the writer chokepoint
([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)), so a
Pester run
silences them with everything else. $dotted tracks whether any dot was written so the closing newline only
fires when it is needed.
```

## comment:8

Above `if ($job.State -ne 'Completed') {`.

```text
A silently-failed shard would drop its files' diagnostics and let violations pass unnoticed —
fail loudly instead.
```

## comment:9

Above `$root = Get-RepositoryRoot`.

```text
The vendored analyzer ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
The shards still run from the repository root: the settings' CustomRulePath entries are relative to it.
```

## comment:10

Above `$fullRoot = [System.IO.Path]::GetFullPath($root)`.

```text
The result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): a file the analyzer
last found clean, whose bytes and analyzer inputs (Get-ScriptAnalyzerInputs) are unchanged since, is not analyzed
again — it has no diagnostics by construction. Only files with no diagnostics are ever recorded.
```

## comment:11

Above `$shardCount = [Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10))`.

```text
Shard count tracks CPU but is capped so we don't spawn more process setup than the work can amortize,
and never exceeds the file count.
```

## comment:12

Above `$savedProgress = $ProgressPreference`.

```text
Invoke-ScriptAnalyzer draws its own Write-Progress bar; this repo bans progress bars (ADR
console-output-matters, rule
[ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)) and
reports shard progress with dots instead. Suppress the
external bar for the duration of the call and restore the preference in finally.
```

## comment:13

Above `$err = $null`.

```text
Capture non-terminating analyzer errors (-ErrorAction SilentlyContinue + -ErrorVariable) and
surface any as a shard failure, rather than letting a shard silently drop its files' diagnostics.
This used to special-case an intermittent NullReferenceException and tell the user to re-run; that
flake was root-caused to the built-in PSReservedCmdletChar rule dereferencing PSScriptAnalyzer's
thread-unsafe helper runspace under concurrent load, and eliminated by excluding that rule in
PSScriptAnalyzerSettings.psd1. So there is no transient case to tolerate — any error is real and
fails loudly (ADR diagnostics-over-retry; we never retry,
[ADR-AUTO-RETRY#1](/docs/adr/automation/retry-as-last-resort.md#rule-adr-auto-retry1)).
```

## comment:14

Above `$dotted = $false`.

```text
Print a dot per interval while shards run, rather than a progress bar (ADR console-output-matters,
rule [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)). The
dots go through the writer chokepoint
([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)), so a
Pester run
silences them with everything else. $dotted tracks whether any dot was written so the closing newline only
fires when it is needed.
```

## comment:15

Above `if ($job.State -ne 'Completed') {`.

```text
A silently-failed shard would drop its files' diagnostics and let violations pass unnoticed —
fail loudly instead.
```
