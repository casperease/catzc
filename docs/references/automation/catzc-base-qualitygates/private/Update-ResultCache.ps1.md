# automation/Catzc.Base.QualityGates/private/Update-ResultCache.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Records a quality check's verdicts in its result cache: the checked files it found clean, and no others.

### description

The write half of a result cache ([ADR-AUTO-CACHE#10](../../../../adr/automation/caching.md#rule-adr-auto-cache10)): each
checked file that Split-CachedFile keyed is recorded under its key when it is clean, and its entry is removed when
the check flagged it, so a flagged file is checked again every run until it is fixed. Unkeyed files (outside the
repository) are skipped. Without -RekeyFromDisk the key is the one computed before the check; with it, the key is
recomputed from the file's bytes now — for a check that rewrote the file (a formatter writing in place).

### parameter Cache

The result cache, updated in place.

### parameter Key

The Key map Split-CachedFile returned.

### parameter Checked

The files the check ran on.

### parameter Flagged

The checked files the check would change or reported a finding for.

### parameter Stamp

The check's input stamp; needed with -RekeyFromDisk.

### parameter RekeyFromDisk

Recompute each clean file's key from its current bytes.
