# pwsh/.scriptanalyzer/NoBareCacheEntryRead.psm1

The custom analyzer check `Measure-NoBareCacheEntryRead`: a function file reads a lazy `$script:` cache entry only after probing or
assigning it.

## Why

Nothing declares a cache entry at import, so the first read of an unset entry throws under strict mode.

## Which files

- A `.psm1` is skipped, since it can declare its cache entries at load. A Pester file is skipped too, by name or, when an editor buffer has
  no file name, by its `Describe` calls. Any other in-memory definition is analysed.
- Cache entries the script itself declares at load (a top-level `$script:<entry> = …` outside any function) count as declared. This
  covers a `.psm1` that the editor analyses as an in-memory buffer, where the file name, and so the skip above, is lost.

## Predicates

The predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
