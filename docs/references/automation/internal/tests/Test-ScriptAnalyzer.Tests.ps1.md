---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Test-ScriptAnalyzer.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3df484ba0b86"
    adrs:
      - ADR-AUTO-CACHE#10
      - ADR-PWSH-FORMAT#5
---

# automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'PSScriptAnalyzer' -Tag 'L2', 'integrity', 'greedy' {`, written with `#`.

```text
greedy: the analysis shards across min(ProcessorCount - 1, 10) background pwsh processes of its own —
stacked on the parallel worker pool that fan-out oversubscribes the machine (and inflates neighbouring
tests' wall clock against the level time limits); the greedy phase runs it after the pool instead.
```

## comment:2

Above `$script:targetFiles = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Draw the exact files from the one shared selector (Get-AutomationSourceFiles), so this gate cannot
drift from Test-ScriptAnalyzer
([ADR-PWSH-FORMAT#5](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format5)). The
selector covers module *.ps1
(root, private/), tests/**/*.Tests.ps1 recursively (so tests/types/ is included), the
.internal/.scriptanalyzer infrastructure folders (bootstrap, TestKit, custom analyzer rules, and
their tests), the root importer.ps1, and authored .psd1 config; .vendor, .compiled, and generated
manifests are excluded as build output. Sorted here for stable, reproducible shard assignment.
```

## comment:3

Above `$allDiagnostics = & (Get-Module Catzc.Base.QualityGates) {`, written with `#`.

```text
The one analysis engine Test-ScriptAnalyzer runs (Get-ScriptAnalyzerDiagnostics): the file list sharded
across background processes, each importing the vendored analyzer once, and its result cache, which skips
every file the analyzer last found clean whose bytes and analyzer inputs are unchanged since
([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)) — a pipeline, without the
cache, analyzes every file. A shard error fails the run loudly inside the engine.
```
