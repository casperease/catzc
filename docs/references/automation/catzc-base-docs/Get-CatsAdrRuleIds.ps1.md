---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md
    kind: reference
    body_sha: "4b3bfa9cdb1c"
    adrs:
      - ADR-AUTO-NOPWD#1
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Unions the rule ids of every ADR the index ([index](/docs/adr/index.md)) lists: for each index row
(Get-CatsAdrIndex) it reads that ADR file (Get-CatsAdrRules) and collects the `### Rule <CODE>:<n>` ids,
returning them distinct and ordinally sorted in registry form (colon, e.g. 'ADR-AUTO-NOPWD:1'). This is the
authoritative set a rule citation is validated against — a test tag or an analyzer mapping that names a
rule absent from this set is a dead reference.

Ids are returned in registry (`:`) form; a caller comparing a citation, which is spelled in `#` form
(e.g. 'ADR-AUTO-NOPWD#1', the
[index](/docs/adr/index.md) citation grammar), canonicalizes the separator before lookup.

A pure function of the files on disk, memoized per resolved index path for the session (re-run the
importer to refresh — see
[ADR-AUTO-CACHE](/docs/adr/automation/caching.md)). Built on the two existing ADR parsers rather
than re-scanning the tree ([ADR-PRIN-REDUCEVAR](/docs/adr/principles/reduce-variability.md)).
```

## comment:2

Section `.PARAMETER IndexPath` of the comment-based help.

```text
Absolute path to the ADR index. Defaults to [index](/docs/adr/index.md) under the repository root. ADR file paths in
the index are resolved relative to the index's own folder, so a test can point this at a fixture index
beside fixture ADR files; the cache keys on the path, so a fixture path and the real path never collide.
```

## comment:3

Above `$script:catsAdrRuleIdsCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:4

Above `$adrRoot = Split-Path $IndexPath -Parent`.

```text
Index rows carry ADR paths relative to the index's own folder (docs/adr/), so resolve against it rather
than a hardcoded docs/adr — that keeps a fixture index beside fixture ADR files working the same way.
```
