---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-CatsAdrIndex.ps1.md
    kind: comment-page
    body_sha: "2eca3f866a86"
    adrs:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Docs/private/Get-CatsAdrIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the rule-citation registry tables in [index](/docs/adr/index.md) and returns one entry per ADR: its citation
code, its title slug, and its index-relative path. A pure function of the file on disk, memoized per
resolved index path for the session (re-run the importer to refresh — see
[ADR-AUTO-CACHE](/docs/adr/automation/caching.md)).
Inline code-span mentions of a code (in prose) are not table rows and are ignored.

Private helper for Show-Cats; not exported.
```

## comment:2

Section `.PARAMETER IndexPath` of the comment-based help.

```text
Absolute path to the ADR index. Defaults to
[index](/docs/adr/index.md) under the repository root. A test points this
at a fixture index; the cache keys on the path, so a fixture path and the real path never collide.
```

## comment:3

Above `$script:catsAdrIndexCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:4

Above `$script:catsAdrIndexCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
