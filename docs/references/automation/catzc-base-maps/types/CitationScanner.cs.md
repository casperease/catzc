---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/CitationScanner.cs.md
    kind: comment-page
    body_sha: "2d2a717d0041"
    adrs:
      - ADR-REPO-LINK#3
    links: []
---

# automation/Catzc.Base.Maps/types/CitationScanner.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Finds the ADR citations in a file's text and maps each to its domain through the adrs index (the external codes of
Catzc.Base.Docs' adrs.yml, each with the domain it belongs to). Code cites ADRs in its help and comments
([ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)), so the citations drive the world-map
highlight. Three forms are a citation: ADR-<CODE>#n and ADR-<CODE>:n (one rule; both become the canonical
ADR-<CODE>#n) and the bare ADR-<CODE> (the whole ADR). A look-alike is not: a code the index does not list, a code
glued to a letter, digit, underscore or hyphen on either side (rule-adr-auto-types8 in a link anchor, a letter
before the ADR, ADR-...-* as a wildcard), and lowercase text. Only the file kinds that cite are read (CitingExtensions).
```

## comment:2

Above `public static IReadOnlyDictionary<string, string> Index(IDictionary raw)`.

```text
The adrs index as an ordinal code -> domain map, from any dictionary (a PowerShell hashtable). A key that is not
an ADR code, or an empty domain, throws.
```

## comment:3

Above `public static CitationSite[] Sites(string path, string text,...`.

```text
Every citation in a file's text whose code the index lists, one site per occurrence, in line order: its line and
the kind of text it sits in (CitationSite). Markdown is prose throughout (KindText). In a PowerShell, C# or YAML
file, the header is help (KindHelp): the comment lines the file opens with, a PowerShell <# ... #> help block, and
a C# /// doc comment; a comment after the header is a passing mention (KindComment); the rest is KindText.
```

## comment:4

Above `public static string Canonical(string reference)`.

```text
A reference in any of the three forms as its canonical citation (ADR-<CODE> or ADR-<CODE>#n); null when the text
is not one.
```

## comment:5

Above `public static bool Covers(string requested, string cited)`.

```text
True when a requested citation covers a cited one: a bare request covers every citation of its ADR; a one-rule
request covers that rule and a bare citation of the whole ADR, never another rule.
```
