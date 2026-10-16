---
catzc:
  immutable:
    with_body_sha: "8058b5d5a3d1"
    path: docs/references/automation/catzc-base-qualitygates/types/TerminologyConfig.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: terminology-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-SPELL#{5,8}
---

# automation/Catzc.Base.QualityGates/types/TerminologyConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The terminology registry (configs/terminology.yml) and its validity rules: a non-empty 'categories' map
(each category a mapping with a required 'description' and an optional 'scope' — a list of repo-relative
globs bounding where that category's terms are legitimate) and a non-empty 'terms' map that groups entries
under those category keys (terms: <category>: [ {term, meaning, [expands_to]}, ... ]). Every group key must
be a defined category, every entry a valid TerminologyTerm, and no term duplicated across groups.
Constructing an instance validates the registry (throwing on the first malformed shape) and exposes the
parsed categories, their scopes, and the flattened terms (each carrying its group's category) to the
generator (Build-TerminologyDictionary) and gate (Test-Terminology). The 'categories' map is the single
source of the category set. A category with no 'scope' is GLOBAL — its terms are legitimate everywhere; a
category WITH a scope is ZONE-BOUND — its terms belong only under the scope globs, and cspell enforces
that (a fixture token in shipped config, or a live identity in a logic test, becomes a spelling failure).
See [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md)
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)-[ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)).
```

## comment:2

Above `public IReadOnlyDictionary<string, IReadOnlyList<string>> categoryScopes {...`, written with `//`.

```text
Per category, its scope globs (repo-relative, '/'-separated). An empty list means the category is
GLOBAL (no location bound). Keyed by category name.
```

## comment:3

Above `object termsObj = (raw != null && raw.Contains("terms")) ? raw["terms"] : null;`, written with `//`.

```text
---- terms: a non-empty map of category -> list of entries; each valid, unique, under a defined
     category. The group key IS the category, so entries carry no category field. ----
```
