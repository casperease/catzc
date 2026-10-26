# pwsh/Base.Drs/Get-CatsDrsIndex.ps1

Parses the ADR index into one entry per ADR, the code, title slug and path that `Show-Cats` presents.

## help

### synopsis

Parses the ADR index ([index](../../../drs/index.md)) into the code -> ADR entries that Show-Cats presents.

### description

Reads the rule-citation registry tables in [index](../../../drs/index.md) and returns one entry per ADR: its citation code, its title slug,
and its index-relative path. A pure function of the file on disk, memoized per resolved index path for the session (re-run the importer to
refresh — see [ADR-AUTO-CACHE](../../../drs/automation/caching.md)). Inline code-span mentions of a code (in prose) are not table rows and
are ignored.

### parameter `IndexPath`

Absolute path to the ADR index. Defaults to [index](../../../drs/index.md) under the repository root. A test points this at a fixture index;
the cache keys on the path, so a fixture path and the real path never collide.

### outputs

`[object[]]` One { Code; Title; Path } per ADR row in the index.

## Cache

The result is memoized per index path in a script-scope table. The lazy entry is read with a strict-clean probe, so an unset script variable
reads as null instead of throwing
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).
