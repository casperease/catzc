# pwsh/.scriptanalyzer/CatzcSpelling.psm1

The entry rule of the spelling check: `Measure-CatzcSpelling` runs `Measure-SpellOutIdentifiers` on a file's root block.

## Its own entry rule

The spelling check reads the dictionaries, so it is an entry rule of its own: a dictionary edit re-runs this rule alone
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)).
