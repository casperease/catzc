# pwsh/Base.Maps/types/CitationScanner.cs

Finds the decision-record citations in a file's text and maps each to its domain through the adrs index (the external codes of the docs
module's `drs.yml`, each with the domain it belongs to). Code cites records in its help and comments
([ADR-REPO-LINK-CODELINKS](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)), so the citations drive the
world-map highlight.

## What counts as a citation

A citation is a code of the shape `DrsCodeForm` defines, and it counts only when the index lists its code. A look-alike is not one: a code
the index does not list, a code glued to a letter, digit, underscore or hyphen on either side (a link anchor such as
`rule-adr-bcl-types-snakecasemirrorsyaml`, a letter before the ADR, a wildcard `ADR-...-*`), and lowercase text. Only the file kinds that
cite are read (`CitingExtensions`: `.cs`, `.md`, `.ps1`, `.yaml`, `.yml`).

## The index

`Index` turns any dictionary, such as a PowerShell hashtable, into an ordinal code-to-domain map. A key that is not a code, or an empty
domain, throws.

## Sites

`Sites` returns every citation the index lists, one site per occurrence, in line order. Each site holds its line and the kind of text it
sits in (see `CitationSite`). Markdown is prose throughout (`text`). In a PowerShell, C# or YAML file the header is help: the comment lines
the file opens with, a PowerShell `<# ... #>` help block and a C# `///` doc comment. A comment after the header is a passing mention
(`comment`), and the rest is `text`.

## Matching

`Canonical` trims a reference and returns it when it is a code, else null. `Covers` is true when one code selects the other: they are equal,
or one is a whole-segment prefix of the other. A request for a whole ADR therefore covers every citation of it, and a request for one rule
covers that rule and a citation of the whole ADR, never another rule.
