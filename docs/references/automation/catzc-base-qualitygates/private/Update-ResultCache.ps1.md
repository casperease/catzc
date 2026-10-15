# docs/references/automation/catzc-base-qualitygates/private/Update-ResultCache.ps1.md

`automation/Catzc.Base.QualityGates/private/Update-ResultCache.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The write half of a result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): each
checked file that Split-CachedFile keyed is recorded under its key when it is clean, and its entry is removed when
the check flagged it, so a flagged file is checked again every run until it is fixed. Unkeyed files (outside the
repository) are skipped. Without -RekeyFromDisk the key is the one computed before the check; with it, the key is
recomputed from the file's bytes now — for a check that rewrote the file (a formatter writing in place).
```
