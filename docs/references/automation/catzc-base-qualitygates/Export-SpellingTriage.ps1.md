---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e6fad7eb5a6c
    adrs:
      - ADR-AUTO-SPELL#{6,7}
---

# automation/Catzc.Base.QualityGates/Export-SpellingTriage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$command = (`, written with `#`.

```text
--words-only prints just the flagged tokens (one per line); --unique de-duplicates; --no-summary keeps
the trailing "Issues found" line out of the token stream.
```

## comment:2

Above `$result = Invoke-Executable $command -PassThru -NoAssert -Silent`, written with `#`.

```text
-Silent: capture cspell's output instead of streaming it. Exit 0 = clean, 1 = tokens flagged (expected),
>1 = tool error.
```

## comment:3

Above `$lines = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
Emit paste-ready stubs. The blank meaning/category are intentional: a stub pasted into
terminology.yml as-is fails to load and fails Test-Terminology, forcing a human to classify it
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6),
[ADR-AUTO-SPELL#7](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell7)) before it becomes
accepted vocabulary.
```
