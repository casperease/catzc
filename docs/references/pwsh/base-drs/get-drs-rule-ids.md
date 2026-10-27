# pwsh/Base.Drs/Get-DrsRuleIds.ps1

Returns the set of every rule id the ADRs declare, the authoritative list a rule citation is validated against.

## help

### synopsis

The flat set of every declared ADR rule id across all ADRs (registry form, e.g. 'ADR-PWSH-ERROR-THROWNOTWRITEERROR').

### description

Unions the rule ids of every ADR the index ([index](../../../drs/index.md)) lists: for each index row (Get-DrsIndex) it reads that ADR file
(Get-DrsRules) and collects the `### Rule <CODE>:<n>` ids, returning them distinct and ordinally sorted in registry form (colon, e.g.
'ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS'). This is the authoritative set a rule citation is validated against — a test tag or an analyzer
mapping that names a rule absent from this set is a dead reference.

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

## Cache

The result is memoized per index path in a script-scope table. The lazy entry is read with a strict-clean probe
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Path resolution

Index rows carry ADR paths relative to the index's own folder (`docs/drs/`), so the command resolves against that folder rather than a
hardcoded `docs/drs`. That keeps a fixture index beside fixture ADR files working the same way.
