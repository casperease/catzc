# automation/Catzc.Base.QualityGates/private/Save-ResultCache.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes a quality check's result cache, sorted by path, merged with what other processes saved meanwhile. See Get-ResultCache.

### description

Several processes keep the same cache file: a test run's workers, a person's own checks, a snapshot run handing its entries home. Each loads
the cache, checks its files, and saves, so a plain overwrite would drop every entry another process saved in between. The save therefore
re-reads the file and keeps each of its entries for a path this cache has no entry for; this cache's own entries win. Keeping another
process's entry is always safe: its key is the file's content and the check's inputs
([ADR-AUTO-CACHE#10](../../../../adr/automation/caching.md#rule-adr-auto-cache10)), so it can only match the bytes and inputs it was
recorded for.

The file is replaced in one step (written beside it, then moved over it), so a reader never sees half a file. A save that still fails —
another process holding the file at that moment — is reported and skipped: the cache only saves time, and losing one save costs one more
check of those files.

### parameter Path

The cache file.

### parameter Cache

Path -> '`<file SHA-256>:<stamp>`'.
