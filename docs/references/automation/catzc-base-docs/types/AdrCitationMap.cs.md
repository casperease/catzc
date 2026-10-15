---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrCitationMap.cs.md
    kind: reference
    body_sha: "63e4879b81d1"
    adrs:
      - ADR-REPO-LINK#3
---

# automation/Catzc.Base.Docs/types/AdrCitationMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The ADR citation registry as one immutable lookup: each citation code (ADR-<CODE>) to its ADR's
repository-relative path and declared rule numbers, plus the reverse path -> code map and a unique-slug
-> path map. Built from the ADR index (Get-AdrCitationMap) and read by the link engine, which derives every
code link's destination from the citation code
([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)): the code is the source of truth, so a
moved ADR re-points every link to it.
```

## comment:2

Above `public AdrCitationMap(IDictionary entries, IEnumerable documents)`.

```text
entries: code -> { path = '<repo-relative, /-separated .md path>'; rules = <int[]> }.
documents: every ADR-folder markdown path (repo-relative), including the code-less ones (index, dora-explains),
so a slug or stale path can be resolved against the files that actually exist.
```

## comment:3

Above `int dash = code.IndexOf('-', 4);`.

```text
Every hyphen-prefix of a code (ADR-AUTO for
[ADR-PWSH-ERROR](/docs/adr/pwsh/error-handling.md)) names its domain; a domain code or a
domain wildcard (ADR-PRIN-*) is a valid mention, not an unknown ADR.
```
