---
catzc:
  immutable:
    with_body_sha: "10a3bd2e098c"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/Get-CatsAdrRuleIds.ps1.md
    folder: docs/references/automation/catzc-base-docs
    name: get-cats-adr-rule-ids-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The flat set of every declared ADR rule id across all ADRs (registry form, e.g. 'ADR-PWSH-ERROR#3').

### description

Unions the rule ids of every ADR the index ([index](../../../adr/index.md)) lists: for each index row (Get-CatsAdrIndex) it reads that ADR
file (Get-CatsAdrRules) and collects the `### Rule <CODE>:<n>` ids, returning them distinct and ordinally sorted in registry form (colon,
e.g. 'ADR-AUTO-NOPWD#1'). This is the authoritative set a rule citation is validated against — a test tag or an analyzer mapping that names
a rule absent from this set is a dead reference.

Ids are returned in registry (`:`) form; a caller comparing a citation, which is spelled in `#` form (e.g. 'ADR-AUTO-NOPWD#1', the
[index](../../../adr/index.md) citation grammar), canonicalizes the separator before lookup.

A pure function of the files on disk, memoized per resolved index path for the session (re-run the importer to refresh — see
[ADR-AUTO-CACHE](../../../adr/automation/caching.md)). Built on the two existing ADR parsers rather than re-scanning the tree
([ADR-PRIN-REDUCEVAR](../../../adr/principles/reduce-variability.md)).

### parameter IndexPath

Absolute path to the ADR index. Defaults to [index](../../../adr/index.md) under the repository root. ADR file paths in the index are
resolved relative to the index's own folder, so a test can point this at a fixture index beside fixture ADR files; the cache keys on the
path, so a fixture path and the real path never collide.

### outputs

`[string[]]` the distinct rule ids in registry form (e.g. 'ADR-PWSH-ERROR#3'), ordinally sorted.

## comment:1

Above `$script:catsAdrRuleIdsCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:2

Above `$adrRoot = Split-Path $IndexPath -Parent`, written with `#`.

```text
Index rows carry ADR paths relative to the index's own folder (docs/adr/), so resolve against it rather
than a hardcoded docs/adr — that keeps a fixture index beside fixture ADR files working the same way.
```
