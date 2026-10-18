# pwsh/Catzc.Base.Docs/types/AdrCitationMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The ADR citation registry as one immutable lookup: each citation code (ADR-<CODE>) to its ADR's
repository-relative path and declared rule numbers, plus the reverse path -> code map and a unique-slug
-> path map. Built from the ADR index (Get-AdrCitationMap) and read by the link engine, which derives every
code link's destination from the citation code
([ADR-REPO-LINK-CODELINKS](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-codelinks)): the code is the source of truth, so a
moved ADR re-points every link to it.
```

## comment:2

Above `public AdrCitationMap(IDictionary entries, IEnumerable documents)`, written with `//`.

```text
entries: code -> { path = '<repo-relative, /-separated .md path>'; rules = <int[]> }.
documents: every ADR-folder markdown path (repo-relative), including the code-less ones (index, dora-explains),
so a slug or stale path can be resolved against the files that actually exist.
```

## comment:3

Above `int dash = code.IndexOf('-', 4);`, written with `//`.

```text
Every hyphen-prefix of a code (ADR-AUTO for
[ADR-PWSH-ERROR](/docs/adr/pwsh/error-handling.md)) names its domain; a domain code or a
domain wildcard (ADR-PRIN-*) is a valid mention, not an unknown ADR.
```
