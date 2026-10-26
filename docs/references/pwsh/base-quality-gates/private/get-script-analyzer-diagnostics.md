# pwsh/Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1

Runs PSScriptAnalyzer over a file list in two cached passes, sharded across background processes, and returns the diagnostics. The result
cache lets an unchanged clean file skip the analyzer.

## help

### synopsis

Runs PSScriptAnalyzer over a file list in two cached passes, sharded across background processes, returning diagnostics.

### description

The analysis engine behind Test-ScriptAnalyzer. The settings hand the engine two entry rules: `Measure-CatzcRules` runs every custom check
but the spelling one, and `Measure-CatzcSpelling` runs the spelling check, which reads the spelling oracle's word lists. So the analysis
runs as two passes, `rules` (every rule but `Measure-CatzcSpelling`) and `spelling` (that rule alone), each with its own result cache under
out/cache/ (`script-analyzer.json`, `script-analyzer-spelling.json`). A pass skips every file it last found clean whose bytes and the pass's
inputs (Get-ScriptAnalyzerInputs `-Pass`) are unchanged since
([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)); only clean files are
recorded, so a cached run reports exactly the diagnostics a full run would. A dictionary edit changes only the spelling pass's inputs, so it
re-runs that pass alone. A pipeline starts without the cache.

The files a pass has pending are analyzed by Invoke-ScriptAnalyzerShards, which shards them across background pwsh processes; the two passes
share its shard budget.

### parameter `Path`

The files to analyze.

### parameter `SettingsPath`

Path to the PSScriptAnalyzerSettings.psd1 to apply.

### parameter `NoCache`

Analyze every file, ignoring the result caches (which are still refreshed).

### outputs

The PSScriptAnalyzer diagnostic records of both passes (empty when there are no violations).

## Result cache

A file the analyzer last found clean, whose bytes and analyzer inputs (Get-ScriptAnalyzerInputs) are unchanged since, is not analyzed again.
It has no diagnostics by construction, and only files with no diagnostics are ever recorded
([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)).

## Two passes

Each pass is cached on its own inputs. The spelling entry rule reads the dictionaries and every other rule does not, so a dictionary edit
re-runs the spelling pass alone.
