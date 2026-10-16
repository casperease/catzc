---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ScriptAnalyzerDiagnostics.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0aee62528ccd"
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-CONSOLE#8
      - ADR-AUTO-RETRY#1
      - ADR-PWSH-ANNOUNCE#1
---

# automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$root = Get-RepositoryRoot`, written with `#`.

```text
The vendored analyzer ships inside the code tree, so it resolves from the code root
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
The shards still run from the repository root: the settings' CustomRulePath entries are relative to it.
```

## comment:2

Above `$fullRoot = [System.IO.Path]::GetFullPath($root)`, written with `#`.

```text
The result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): a file the analyzer
last found clean, whose bytes and analyzer inputs (Get-ScriptAnalyzerInputs) are unchanged since, is not analyzed
again — it has no diagnostics by construction. Only files with no diagnostics are ever recorded.
```

## comment:3

Above `$shardCount = [Math]::Max(1, [Math]::Min([Environment]::ProcessorCount - 1, 10))`, written with `#`.

```text
Shard count tracks CPU but is capped so we don't spawn more process setup than the work can amortize,
and never exceeds the file count.
```

## comment:4

Above `$savedProgress = $ProgressPreference`, written with `#`.

```text
Invoke-ScriptAnalyzer draws its own Write-Progress bar; this repo bans progress bars (ADR
console-output-matters, rule
[ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)) and
reports shard progress with dots instead. Suppress the
external bar for the duration of the call and restore the preference in finally.
```

## comment:5

Above `$err = $null`, written with `#`.

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

## comment:6

Above `$dotted = $false`, written with `#`.

```text
Print a dot per interval while shards run, rather than a progress bar (ADR console-output-matters,
rule [ADR-AUTO-CONSOLE#8](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console8)). The
dots go through the writer chokepoint
([ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)), so a
Pester run
silences them with everything else. $dotted tracks whether any dot was written so the closing newline only
fires when it is needed.
```

## comment:7

Above `if ($job.State -ne 'Completed') {`, written with `#`.

```text
A silently-failed shard would drop its files' diagnostics and let violations pass unnoticed —
fail loudly instead.
```
