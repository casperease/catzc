---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Get-GitTrackedPath.ps1.md
    kind: comment-page
    body_sha: d56dc8c30910
    adrs:
      - ADR-AUTO-CACHE#9
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Files/Get-GitTrackedPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$script:gitIndexCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:6

Above `$content = [System.IO.File]::ReadAllBytes($indexPath)`.

```text
The key is the index's content, not the session: the index changes mid-session (a commit, a `git add`),
so a cached listing is reused only while the bytes on disk are identical
([ADR-AUTO-CACHE#9](/docs/adr/automation/caching.md#rule-adr-auto-cache9)).
```
