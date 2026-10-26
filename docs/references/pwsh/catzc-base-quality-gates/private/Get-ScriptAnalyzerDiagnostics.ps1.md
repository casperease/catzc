# pwsh/Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs PSScriptAnalyzer over a file list in two cached passes, sharded across background processes, returning diagnostics.

### description

The analysis engine behind Test-ScriptAnalyzer. The settings hand the engine two entry rules: `Measure-CatzcRules` runs every custom check
but the spelling one, and `Measure-CatzcSpelling` runs the spelling check, which reads the spelling oracle's word lists. So the analysis
runs as two passes, `rules` (every rule but `Measure-CatzcSpelling`) and `spelling` (that rule alone), each with its own result cache under
out/cache/ (`script-analyzer.json`, `script-analyzer-spelling.json`). A pass skips every file it last found clean whose bytes and the pass's
inputs (Get-ScriptAnalyzerInputs `-Pass`) are unchanged since
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)); only
clean files are recorded, so a cached run reports exactly the diagnostics a full run would. A dictionary edit changes only the spelling
pass's inputs, so it re-runs that pass alone. A pipeline starts without the cache.

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

## comment:1

Above `$batch = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
The result cache ([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](/docs/drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)): a file the analyzer
last found clean, whose bytes and analyzer inputs (Get-ScriptAnalyzerInputs) are unchanged since, is not analyzed
again — it has no diagnostics by construction. Only files with no diagnostics are ever recorded.
```

## comment:2

Above `$spellingRule = 'Measure-CatzcSpelling'`, written with `#`.

```text
Two passes, each cached on its own inputs: the spelling entry rule reads the dictionaries, every other rule does not, so a dictionary
edit re-runs the spelling pass alone ([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](/docs/drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)).
```
