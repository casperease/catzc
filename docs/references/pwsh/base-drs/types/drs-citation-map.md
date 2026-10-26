# pwsh/Base.Drs/types/DrsCitationMap.cs

The ADR citation registry as one immutable lookup: each citation code (`ADR-<CODE>`) to its ADR's repository-relative path and declared rule
numbers, plus the reverse path-to-code map and a unique-slug-to-path map. `Get-DrsCitationMap` builds it from the ADR index.

## Why it exists

The link engine reads it and derives every code link's destination from the citation code
([ADR-REPO-LINK-CODELINKS](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)). The code is the source of truth, so
a moved ADR re-points every link to it.

## Constructor

`entries` maps a code to `{ path = '<repo-relative, /-separated .md path>'; rules = <int[]> }`. `documents` is every ADR-folder markdown
path, repository-relative, including the code-less ones (the index and the DORA files), so a slug or a stale path can be resolved against
the files that actually exist.

## Domain mentions

Every hyphen-prefix of a code names its domain: `ADR-AUTO` for [ADR-PWSH-ERROR](../../../../drs/automation/pwsh/error-handling.md). A domain
code or a domain wildcard (`ADR-AUTO-*`) is a valid mention, not an unknown ADR.
