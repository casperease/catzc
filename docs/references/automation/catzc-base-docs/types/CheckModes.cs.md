---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/CheckModes.cs.md
    kind: comment-page
    body_sha: "623355b2026a"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-ONELIVE#1
    links: []
---

# automation/Catzc.Base.Docs/types/CheckModes.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The one parser of a check's mode setting (CheckMode), shared by every check config: adr-checks.yml in Catzc.Base.Docs, and
links.yml and source-conventions.yml in Catzc.Base.QualityGates. One parser keeps one accepted spelling and one error text
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). An omitted mode is
default(CheckMode), Gate, the default CheckMode declares once
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
```

## comment:2

Above `public static CheckMode Parse(IDictionary raw, out string error)`.

```text
The mode under the 'mode' key of a check's settings map, matched by name, case-insensitively; raw may be null. An
omitted or null mode is default(CheckMode). A value that names no mode returns default(CheckMode) and sets error to
the one message for it; otherwise error is null.
```
