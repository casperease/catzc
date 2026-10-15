---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md
    kind: comment-page
    body_sha: "1019da1698d6"
    adrs:
      - ADR-AUTO-SPELL#6
      - ADR-AUTO-SPELL#7
---

# automation/Catzc.Base.QualityGates/Export-SpellingTriage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:9

Above `$command = (`.

```text
--words-only prints just the flagged tokens (one per line); --unique de-duplicates; --no-summary keeps
the trailing "Issues found" line out of the token stream.
```

## comment:10

Above `$result = Invoke-Executable $command -PassThru -NoAssert -Silent`.

```text
-Silent: capture cspell's output instead of streaming it. Exit 0 = clean, 1 = tokens flagged (expected),
>1 = tool error.
```

## comment:11

Above `$lines = [System.Collections.Generic.List[string]]::new()`.

```text
Emit paste-ready stubs. The blank meaning/category are intentional: a stub pasted into
terminology.yml as-is fails to load and fails Test-Terminology, forcing a human to classify it
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6),
[ADR-AUTO-SPELL#7](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell7)) before it becomes
accepted vocabulary.
```
