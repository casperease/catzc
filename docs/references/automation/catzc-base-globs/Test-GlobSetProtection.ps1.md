---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md
    kind: comment-page
    body_sha: "4f16477cd24b"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Globs/Test-GlobSetProtection.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:7

Above `$script:protectedGlobSets = @{}`.

```text
strict-clean probe of the lazy cache entries
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:8

Above `$identity = if ($Hash) {`.

```text
NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
overwrite the $Hash parameter.
```
