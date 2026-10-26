# pwsh/Base.QualityGates/Test-Terminology.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks the terminology registry: no drift, no orphans, no unjustified entries. Writes a report under out/.

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

## comment:2

Above `$config = $null`, written with `#`.

```text
---- Check 3 (justification / no-coinage): loading validates every entry via TerminologyConfig ----
A missing category/meaning, an abbreviation without an expansion, or an unknown category throws here.
```

## comment:3

Above `$generated = Build-TerminologyDictionary -DryRun -PassThru`, written with `#`.

```text
---- Check 1 (no drift): every generated dictionary must match the registry
([ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](/docs/drs/automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource)) ----
```

## comment:4

Above `foreach ($term in $config.terms) {`, written with `#`.

```text
---- Check 2 (no orphans): every term must be referenced somewhere else in the tree
([ADR-AUTO-SPELL-LIVEVOCABULARYONLY](/docs/drs/automation/spell-out-names.md#rule-adr-auto-spell-livevocabularyonly)) ----
One bulk scan of the spell-checked corpus (minus the registry and its generated dictionaries, which the config names as its defining
files and where every term trivially appears), then look each term up against it — not one grep per term.
```

## comment:5

Above `$reserved = @($config.terms | Where-Object { $_.category -ceq 'reserved' })`, written with `#`.

```text
A reserved term names one thing, so it may stand only in the files its category's scope lists; the scope
ignores case, as the term does.
```
