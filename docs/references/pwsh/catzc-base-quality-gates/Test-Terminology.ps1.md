# pwsh/Base.QualityGates/Test-Terminology.ps1

The quality gate for terminology: it checks the registry for drift, orphans and unjustified entries, and writes a report to the output
folder.

## help

### synopsis

Checks the terminology registry for drift, orphans and unjustified entries and writes a report to the output folder.

### description

The read-only verifier over configs/terminology.yml and its generated dictionary — the counterpart to Build-TerminologyDictionary. It
enforces the three things code review cannot mechanically catch ([ADR-AUTO-SPELL](../../../drs/automation/spell-out-names.md),
[ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource)-[ADR-AUTO-SPELL-LIVEVOCABULARYONLY](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)):

1. No drift — the generated per-category dictionaries (`.cspell/<category>.txt`) match what Build-TerminologyDictionary would produce from
   the registry ([ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource)).
   They are gitignored and regenerated on import, so this catches a hand-edited word list.
2. No orphans — every registry entry is referenced somewhere in the spell-scanned tree; an entry no code uses is dead vocabulary and must be
   removed ([ADR-AUTO-SPELL-LIVEVOCABULARYONLY](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)).
3. No unjustified entry — every entry declares a category and a meaning, and every abbreviation carries its expansion
   ([ADR-AUTO-SPELL-CATEGORYANDMEANING](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning)). This is
   enforced by the TerminologyConfig type at load, so a malformed registry fails to load and is reported here.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-terminology/, prints every issue, and throws once listing them all; -PassThru returns the
result object instead.

It needs the source tree: it scans the catzc repository, so it throws in build mode (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-terminology`.

### parameter `PassThru`

Return a result object ({ Subject, IssueCount, Issues, ReportPath, TermCount }) instead of throwing.

### outputs

Throws on any issue; with -PassThru, returns the result object.

### example 1

```powershell
Test-Terminology
```

### example 2

```powershell
$result = Test-Terminology -PassThru; $result.IssueCount
```

## Checks

1. Drift: every generated dictionary must match the registry
   ([ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource)).
2. Orphans: every term must be referenced somewhere else in the tree
   ([ADR-AUTO-SPELL-LIVEVOCABULARYONLY](../../../drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)). The command
   makes one bulk scan of the spell-checked corpus and looks each term up against it, not one grep per term. The registry and its generated
   dictionaries are left out of the corpus, because the config names them as its defining files and every term trivially appears there.
3. Justification: loading validates every entry through TerminologyConfig. A missing category or meaning, an abbreviation without an
   expansion, or an unknown category throws.

## Reserved terms

A reserved term names one thing, so it may stand only in the files its category's scope lists. The scope ignores case, as the term does.
