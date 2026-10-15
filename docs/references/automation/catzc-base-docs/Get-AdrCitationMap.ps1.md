---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
    kind: comment-page
    body_sha: "6f2206eb0300"
    adrs:
      - ADR-PWSH-CACHE#4
      - ADR-REPO-LINK#3
---

# automation/Catzc.Base.Docs/Get-AdrCitationMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the rule-citation registry in `<root>/docs/adr/index.md` (Get-CatsAdrIndex) and each listed ADR's
`### Rule <CODE>:<n>` headings (Get-CatsAdrRules), and returns one immutable
[Catzc.Base.Docs.AdrCitationMap]: code -> repository-relative ADR path and rule numbers, the reverse
path -> code map, and a unique-slug -> path map over every markdown file under docs/adr/ (so a stale path
to a moved ADR resolves by its file name). The link engine derives every code link's destination from it
([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)).

A pure function of the files on disk, memoized per resolved repository root for the session (re-run the
importer to refresh — see
[ADR-AUTO-CACHE](/docs/adr/automation/caching.md)); a test passes a fixture root, so the fixture
map and the real one never collide.
```

## comment:2

Above `$script:adrCitationMapCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
