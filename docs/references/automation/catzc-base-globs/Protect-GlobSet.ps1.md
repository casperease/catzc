---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Protect-GlobSet.ps1.md
    kind: comment-page
    body_sha: "28d1b769b249"
    adrs:
      - ADR-PWSH-CACHE#4
      - ADR-REPO-PROTGLOB#4
---

# automation/Catzc.Base.Globs/Protect-GlobSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The record half of the protected-glob skip
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)) — call it only AFTER the scan passes, so a
red scan is never cached away. It promotes the pending hash Test-GlobSetProtection captured before the
scan (falling back to computing one when the query was never asked). Session memory only; in a pipeline
this is a no-op, so CI never records protection.
```

## comment:2

Section `.PARAMETER Test` of the comment-based help.

```text
The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a
Test-Automation run key).
```

## comment:3

Section `.PARAMETER Name` of the comment-based help.

```text
The scope's name in the protection key: a declared globset, or (with a prior -Hash query or -Hash here)
any identifier the caller keys by.
```

## comment:4

Section `.PARAMETER Hash` of the comment-based help.

```text
A precomputed durable identity to record when no pending value exists for the key — for callers that
protect directly without a prior Test-GlobSetProtection query. A pending pre-scan value always wins over
this (hash-before-scan, [ADR-REPO-PROTGLOB#4](/docs/adr/repository/protected-globs.md#rule-adr-repo-protglob4)).
```

## comment:5

Above `$script:protectedGlobSets = @{}`.

```text
strict-clean probe of the lazy cache entries
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:6

Above `$identity = $script:pendingGlobProtections[$key]`.

```text
NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
overwrite the $Hash parameter.
```

## comment:7

Above `$script:protectedGlobSets = @{}`.

```text
strict-clean probe of the lazy cache entries
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:8

Above `$identity = $script:pendingGlobProtections[$key]`.

```text
NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
overwrite the $Hash parameter.
```
