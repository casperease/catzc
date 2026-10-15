---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md
    kind: comment-page
    body_sha: "6c7d5173a586"
    adrs:
      - ADR-AUTO-SPELL#5
      - ADR-AUTO-SPELL#8
---

# automation/Catzc.Base.QualityGates/Test-Terminology.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
