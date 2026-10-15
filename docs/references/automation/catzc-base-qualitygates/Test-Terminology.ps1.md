---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md
    kind: comment-page
    body_sha: "9f3c91b18c45"
    adrs:
      - ADR-AUTO-SPELL#5
      - ADR-AUTO-SPELL#6
      - ADR-AUTO-SPELL#8
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-Terminology.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The read-only verifier over configs/terminology.yml and its generated dictionary — the counterpart to
Build-TerminologyDictionary. It enforces the three things code review cannot mechanically catch
([ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md),
[ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)-[ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)):

  1. No drift — the generated per-category dictionaries (.cspell/<category>.txt) match what
     Build-TerminologyDictionary would produce from the registry
     ([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)). They are
     gitignored and
     regenerated on import, so this catches a hand-edited word list.
  2. No orphans — every registry entry is referenced somewhere in the spell-scanned tree; an entry no
     code uses is dead vocabulary and must be removed
     ([ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)).
  3. No unjustified entry — every entry declares a category and a meaning, and every abbreviation carries
     its expansion ([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)).
     This is enforced by the TerminologyConfig type at load, so a malformed
     registry fails to load and is reported here.

A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
through Write-QualityGateReport, which writes out/test-terminology/, prints every issue, and throws once
listing them all; -PassThru returns the result object instead.

It needs the source tree: it scans the catzc repository, so it throws in build mode (Assert-SourceTree).
```

## comment:2

Above `$registryPath = Join-Path $root...`.

```text
The registry's own file inside the scanned corpus — a corpus exclusion, not an asset read (the registry
itself is loaded through Get-Config), so it names the file in the repository tree being scanned.
```

## comment:3

Above `$config = $null`.

```text
---- Check 3 (justification / no-coinage): loading validates every entry via TerminologyConfig ----
A missing category/meaning, an abbreviation without an expansion, or an unknown category throws here.
```

## comment:4

Above `$generated = Build-TerminologyDictionary -DryRun -PassThru`.

```text
---- Check 1 (no drift): every generated dictionary must match the registry
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)) ----
```

## comment:5

Above `$cspellDir = Join-Path $root '.cspell'`.

```text
---- Check 2 (no orphans): every term must be referenced somewhere else in the tree
([ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)) ----
One bulk scan of the spell-checked corpus (minus the registry and its generated lists, where every
term trivially appears), then look each term up against it — not one grep per term. The generated
per-category dictionaries live at the repository root's .cspell/ (see .cspell/README.md).
```

## comment:6

Above `$registryPath = Join-Path $root...`.

```text
The registry's own file inside the scanned corpus — a corpus exclusion, not an asset read (the registry
itself is loaded through Get-Config), so it names the file in the repository tree being scanned.
```

## comment:7

Above `$config = $null`.

```text
---- Check 3 (justification / no-coinage): loading validates every entry via TerminologyConfig ----
A missing category/meaning, an abbreviation without an expansion, or an unknown category throws here.
```

## comment:8

Above `$generated = Build-TerminologyDictionary -DryRun -PassThru`.

```text
---- Check 1 (no drift): every generated dictionary must match the registry
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)) ----
```

## comment:9

Above `$cspellDir = Join-Path $root '.cspell'`.

```text
---- Check 2 (no orphans): every term must be referenced somewhere else in the tree
([ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)) ----
One bulk scan of the spell-checked corpus (minus the registry and its generated lists, where every
term trivially appears), then look each term up against it — not one grep per term. The generated
per-category dictionaries live at the repository root's .cspell/ (see .cspell/README.md).
```
