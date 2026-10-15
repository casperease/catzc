---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md
    kind: comment-page
    body_sha: "03ea2bf60033"
    adrs:
      - ADR-AUTO-SPELL#5
      - ADR-AUTO-SPELL#6
      - ADR-AUTO-SPELL#7
---

# automation/Catzc.Base.QualityGates/Export-SpellingTriage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the same cspell scan as Test-Spelling with --words-only, collecting every token the gate flags, and
writes them as UNCATEGORIZED STUBS to a triage queue under out/ (terminology-triage.yml). Nothing here is
accepted vocabulary: a flagged token joins the dictionary only when a human moves it into the terminology
registry (configs/terminology.yml) with a real meaning and category, or spells the token out in the code
([ADR-AUTO-SPELL#7](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell7)). The queue is a to-do
list, not a dictionary — cspell
never reads it, so a token sitting in the queue is still flagged until promoted. It changes no repository file,
so it is an export, not a formatter. The accepted-word list is generated from the registry
(Build-TerminologyDictionary) and is never appended to by a tool
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)).

Tokens already in the registry are skipped (cspell accepts them, so they are not flagged in the first
place); only genuinely new, unaccepted tokens reach the queue.

cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
Repository-relative paths or globs to scan (cspell expands a glob). Defaults to the repository's known text file
types — the same scope Test-Spelling checks. cspell still applies the ignorePaths from cspell.yml.
```

## comment:3

Section `.PARAMETER Exclude` of the comment-based help.

```text
Globs to skip, passed to cspell as --exclude. Defaults to the authored/generated trees that are out of
scope to spell-check, matching Test-Spelling so the tokens queued are exactly the tokens the gate flags.
```

## comment:4

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report which tokens would be queued without writing the triage file. The returned list is the same in
either mode; -DryRun simply skips the write. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:5

Above `[string[]] $Exclude = @(`.

```text
Mirror Test-Spelling's content-scope exclusions, so the tokens queued are exactly the tokens the
gate flags. Third-party noise lives in cspell.yml ignorePaths, not here.
```

## comment:6

Above `$command = (`.

```text
--words-only prints just the flagged tokens (one per line); --unique de-duplicates; --no-summary keeps
the trailing "Issues found" line out of the token stream.
```

## comment:7

Above `$result = Invoke-Executable $command -PassThru -NoAssert -Silent`.

```text
-Silent: capture cspell's output instead of streaming it. Exit 0 = clean, 1 = tokens flagged (expected),
>1 = tool error.
```

## comment:8

Above `$lines = [System.Collections.Generic.List[string]]::new()`.

```text
Emit paste-ready stubs. The blank meaning/category are intentional: a stub pasted into
terminology.yml as-is fails to load and fails Test-Terminology, forcing a human to classify it
([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6),
[ADR-AUTO-SPELL#7](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell7)) before it becomes
accepted vocabulary.
```

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
