---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "436b6c1a68a9"
    adrs:
      - ADR-AUTO-TEST#25
---

# automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$entryLine = if ($EntryScript) {`, written with `#`.

```text
The one seam between the two runs: which entry script loads the modules. Source run (default) —
the repository importer; build run — the build's Import-Catzc.ps1 with its named arguments.
```

## comment:2

Above `$entryLiteral = "$EntryScript" -replace "'", "''"`, written with `#`.

```text
The build run's entry also reaches the language bridge, so the Go and Python tests start the build
(New-PesterRunConfiguration).
```

## comment:3

Above `$languageEntries = foreach ($language in ($LanguageExecutable.Keys |...`, written with `#`.

```text
The tools this source session located reach the language bridge the same way, as a hashtable literal in
language order: a build's engine cannot locate them.
```

## comment:4

Above `$content = @"`, written with `#`.

```text
The Pester configuration itself comes from the ONE shared builder (New-PesterRunConfiguration) so this
worker path and the manual single-check path (Invoke-TestFile) can never drift apart — the worker has
the full toolset imported, so it reaches the private through module scope like ConvertTo-
TestAutomationRowSet below. Only the strict-mode discipline stays inline: strict is scope-dynamic and
the test scopes chain to the process's top scope, so the worker script itself must be the one to set
it (tests run strict — [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)).
```
