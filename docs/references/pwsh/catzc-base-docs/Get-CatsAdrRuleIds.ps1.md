# pwsh/Catzc.Base.Docs/Get-CatsAdrRuleIds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The flat set of every declared ADR rule id across all ADRs (registry form, e.g. 'ADR-PWSH-ERROR-THROWNOTWRITEERROR').

### description

Unions the rule ids of every ADR the index ([index](../../../drs/index.md)) lists: for each index row (Get-CatsAdrIndex) it reads that ADR
file (Get-CatsAdrRules) and collects the `### Rule <CODE>:<n>` ids, returning them distinct and ordinally sorted in registry form (colon,
e.g. 'ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS'). This is the authoritative set a rule citation is validated against — a test tag or an
analyzer mapping that names a rule absent from this set is a dead reference.

Ids are returned in registry (`:`) form; a caller comparing a citation, which is spelled in `#` form (e.g.
'ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS', the [index](../../../drs/index.md) citation grammar), canonicalizes the separator before lookup.

A pure function of the files on disk, memoized per resolved index path for the session (re-run the importer to refresh — see
[ADR-AUTO-CACHE](../../../drs/automation/caching.md)). Built on the two existing ADR parsers rather than re-scanning the tree
([PDR-REDUCEVAR](../../../drs/principles/reduce-variability.md)).

### parameter `IndexPath`

Absolute path to the ADR index. Defaults to [index](../../../drs/index.md) under the repository root. ADR file paths in the index are
resolved relative to the index's own folder, so a test can point this at a fixture index beside fixture ADR files; the cache keys on the
path, so a fixture path and the real path never collide.

### outputs

`[string[]]` the distinct rule ids in registry form (e.g. 'ADR-PWSH-ERROR-THROWNOTWRITEERROR'), ordinally sorted.

## comment:1

Above `$script:catsAdrRuleIdsCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE-STRICTSAFEPROBE](/docs/drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe))
```

## comment:2

Above `$adrRoot = Split-Path $IndexPath -Parent`, written with `#`.

```text
Index rows carry ADR paths relative to the index's own folder (docs/drs/), so resolve against it rather
than a hardcoded docs/drs — that keeps a fixture index beside fixture ADR files working the same way.
```
