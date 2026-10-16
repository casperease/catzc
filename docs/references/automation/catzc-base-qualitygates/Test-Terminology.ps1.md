---
catzc:
  immutable:
    with_body_sha: cd1bd54bdc93
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/Test-Terminology.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: test-terminology-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-SPELL#{5,8}
---

# automation/Catzc.Base.QualityGates/Test-Terminology.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$registryPath = Join-Path $root...`, written with `#`.

```text
The registry's own file inside the scanned corpus — a corpus exclusion, not an asset read (the registry
itself is loaded through Get-Config), so it names the file in the repository tree being scanned.
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
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)) ----
```

## comment:4

Above `$cspellDir = Join-Path $root '.cspell'`, written with `#`.

```text
---- Check 2 (no orphans): every term must be referenced somewhere else in the tree
([ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)) ----
One bulk scan of the spell-checked corpus (minus the registry and its generated lists, where every
term trivially appears), then look each term up against it — not one grep per term. The generated
per-category dictionaries live at the repository root's .cspell/ (see .cspell/README.md).
```
