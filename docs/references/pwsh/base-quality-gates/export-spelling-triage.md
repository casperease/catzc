# pwsh/Base.QualityGates/Export-SpellingTriage.ps1

The on-ramp to the terminology registry: it collects the tokens the spell checker flags into a queue of stubs to classify. It never accepts
a token itself.

## help

### synopsis

Collects the spell-checker's flagged tokens into a triage queue for classification, the on-ramp to the terminology registry, never an
automatic acceptance.

### description

Runs the same cspell scan as Test-Spelling with --words-only, collecting every token the gate flags, and writes them as UNCATEGORIZED STUBS
to a triage queue under out/ (terminology-triage.yml). Nothing here is accepted vocabulary: a flagged token joins the dictionary only when a
human moves it into the terminology registry (configs/terminology.yml) with a real meaning and category, or spells the token out in the code
([ADR-AUTO-SPELL-FLAGGEDTOKENREVIEWED](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-flaggedtokenreviewed)). The queue is a
to-do list, not a dictionary — cspell never reads it, so a token sitting in the queue is still flagged until promoted. It changes no
repository file, so it is an export, not a formatter. The accepted-word list is generated from the registry (Build-TerminologyDictionary)
and is never appended to by a tool
([ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource)).

Tokens already in the registry are skipped (cspell accepts them, so they are not flagged in the first place); only genuinely new, unaccepted
tokens reach the queue.

cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).

### parameter `Path`

Repository-relative paths or globs to scan (cspell expands a glob). Defaults to the repository's known text file types — the same scope
Test-Spelling checks. cspell still applies the ignorePaths from cspell.yml.

### parameter `Exclude`

Globs to skip, passed to cspell as --exclude. Defaults to the authored/generated trees that are out of scope to spell-check, matching
Test-Spelling so the tokens queued are exactly the tokens the gate flags. Mirror Test-Spelling's content-scope exclusions, so the tokens
queued are exactly the tokens the gate flags. Third-party noise lives in cspell.yml ignorePaths, not here.

### parameter `DryRun`

Report which tokens would be queued without writing the triage file. The returned list is the same in either mode; -DryRun simply skips the
write. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### outputs

`[string[]]` The flagged tokens queued for triage (or, under -DryRun, that would be queued), ordinal-sorted.

### example 1

```powershell
Export-SpellingTriage
Writes every currently-flagged token to the triage queue for classification.
```

### example 2

```powershell
Export-SpellingTriage -DryRun
Returns which tokens would be queued without writing the file.
```

## Reading cspell

The command runs cspell with `--words-only` to print just the flagged tokens, one per line, `--unique` to de-duplicate them and
`--no-summary` to keep the trailing "Issues found" line out of the token stream. The output is captured, not streamed (`-Silent`). Exit 0
means clean, 1 means flagged tokens, which is the expected case, and anything above 1 is a tool error.

## Stubs

The output is paste-ready stubs. The meaning and the category are blank on purpose: a stub pasted into `terminology.yml` as it stands fails
to load and fails Test-Terminology, which forces a person to classify it
([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning),
[ADR-AUTO-SPELL-FLAGGEDTOKENREVIEWED](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-flaggedtokenreviewed)) before it
becomes accepted vocabulary.
