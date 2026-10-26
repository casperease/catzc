# pwsh/Base.QualityGates/private/Update-ResultCache.ps1

Records a quality check's verdicts in its result cache: the checked files it found clean, and no others. It is the write half of a result
cache; Split-CachedFile is the read half.

## help

### synopsis

Records a quality check's verdicts in its result cache: the checked files it found clean, and no others.

### description

The write half of a result cache
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)): each
checked file that Split-CachedFile keyed is recorded under its key when it is clean, and its entry is removed when the check flagged it, so
a flagged file is checked again every run until it is fixed. Unkeyed files (outside the repository) are skipped. Without -RekeyFromDisk the
key is the one computed before the check; with it, the key is recomputed from the file's bytes now — for a check that rewrote the file (a
formatter writing in place).

### parameter `Cache`

The result cache, updated in place.

### parameter `Key`

The Key map Split-CachedFile returned.

### parameter `Checked`

The files the check ran on.

### parameter `Flagged`

The checked files the check would change or reported a finding for.

### parameter `Stamp`

The check's input stamp; needed with -RekeyFromDisk.

### parameter `RekeyFromDisk`

Recompute each clean file's key from its current bytes.
