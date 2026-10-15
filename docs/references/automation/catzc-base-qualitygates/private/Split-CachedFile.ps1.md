---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Split-CachedFile.ps1.md
    kind: reference
    body_sha: "203e324837a7"
    adrs:
      - ADR-AUTO-CACHE#10
---

# automation/Catzc.Base.QualityGates/private/Split-CachedFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The read half of a result cache ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)): each
file inside the repository gets the key '<SHA-256 of its bytes>:<stamp>'; a file whose cache entry equals its key is
cached, every other file is pending. A file outside the repository, or one that does not exist, is always pending
and never keyed (it is never recorded). Update-ResultCache is the write half.
```
