---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
    kind: reference
    body_sha: "3370198b6af6"
    adrs:
      - ADR-AUTO-CACHE#6
      - ADR-DSGN-TRACK#1
      - ADR-DSGN-TRACK#3
      - ADR-DSGN-TRACK#6
      - ADR-PWSH-CACHE#4
      - ADR-THES-ONETRUTH#3
---

# automation/Catzc.Base.Maps/Get-WorldMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Gathers the repository's own registries and builds the map with Catzc.Base.Maps.WorldMapBuilder:
the tracks (Get-Track, [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)), the file languages
(Get-FileLanguage, [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)), the tracked files from the
git index (Get-GitTrackedPath, [ADR-AUTO-TRACKED](/docs/adr/automation/tracked-files-from-the-index.md)), each
configured track's aspects (Get-Aspect), the adrs index (Get-AdrRuleSet: ADR code to domain), each ADR code's own
file (Get-AdrCitationMap, the map the link engine uses; an ADR lights its own file, never its domain's), the
owners of the repository-root files (files.yml, read through Get-Config), the globsets (Get-GlobSet), and the globs of the files
whose citations light nothing (maps.yml highlight.citation_exclude; by default the generated slide descriptions
under docs/.assets/, the explanation articles under docs/explanation/ and the drawing tooling under .claude/drawio/,
so a slide's minimap lights the repository's citations of its ADRs, never the slide's own words).

The root folder gives a file's track and its extension gives its file language; a file under no track or in no file
language lands in a bucket row or column, so every file has exactly one cell. A live file whose file language its
track does not declare is a stack violation
([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)); test, vendored and verification-track files
are never one.

The text of a file is read only when its kind cites ADRs (.ps1, .cs, .yml, .yaml, .md), once per session: the
texts stay in a module cache until the importer runs again
([ADR-AUTO-CACHE#6](/docs/adr/automation/caching.md#rule-adr-auto-cache6)).
```

## comment:2

Section `.PARAMETER AsJson` of the comment-based help.

```text
Return the map as JSON (axes, cells and per-file placements) instead of the object, so a tool reads it without
PowerShell ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```

## comment:3

Above `$script:worldMapTextCache = @{}`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
