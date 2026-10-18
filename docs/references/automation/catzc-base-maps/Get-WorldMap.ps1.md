---
catzc:
  immutable:
    with_body_sha: "8e15113ab7f9"
    repo_status: locked
    path: docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
    folder: docs/references/automation/catzc-base-maps
    name: get-world-map-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-CACHE#4
---

# automation/Catzc.Base.Maps/Get-WorldMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the world map: every tracked file placed in one cell of tracks by file languages.

### description

Gathers the repository's own registries and builds the map with Catzc.Base.Maps.WorldMapBuilder:
the tracks (Get-Track, [ADR-DSGN-TRACK#1](../../../adr/design/tracks.md#rule-adr-dsgn-track1)), the file languages
(Get-FileLanguage, [ADR-DSGN-TRACK#6](../../../adr/design/tracks.md#rule-adr-dsgn-track6)), the tracked files from the
git index (Get-GitTrackedPath, [ADR-AUTO-TRACKED](../../../adr/automation/tracked-files-from-the-index.md)), each
configured track's aspects (Get-Aspect), the adrs index (Get-AdrRuleSet: ADR code to domain), each ADR code's own
file (Get-AdrCitationMap, the map the link engine uses; an ADR lights its own file, never its domain's), the
owners of the repository-root files (files.yml, read through Get-Config), the globsets (Get-GlobSet), and the globs of the files
whose citations light nothing (maps.yml highlight.citation_exclude; by default the generated slide descriptions
under docs/.assets/, the explanation articles under docs/explanation/ and the drawing tooling under .claude/drawio/,
so a slide's minimap lights the repository's citations of its ADRs, never the slide's own words).

The root folder gives a file's track and its extension gives its file language; a file under no track or in no file
language lands in a bucket row or column, so every file has exactly one cell. A live file whose file language its
track does not declare is a stack violation
([ADR-DSGN-TRACK#3](../../../adr/design/tracks.md#rule-adr-dsgn-track3)); test, vendored and verification-track files
are never one.

The text of a file is read only when its kind cites ADRs (.ps1, .cs, .yml, .yaml, .md), once per session: the
texts stay in a module cache until the importer runs again
([ADR-AUTO-CACHE#6](../../../adr/automation/caching.md#rule-adr-auto-cache6)).

### parameter AsJson

Return the map as JSON (axes, cells and per-file placements) instead of the object, so a tool reads it without
PowerShell ([ADR-THES-ONETRUTH#3](../../../adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).

### outputs

`[Catzc.Base.Maps.WorldMap]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-WorldMap).Cells | Where-Object FileCount -gt 0
```

### example 2

```powershell
(Get-WorldMap).StackViolations
```

### example 3

```powershell
Get-WorldMap -AsJson
```

## comment:1

Above `$script:worldMapTextCache = @{}`, written with `#`.

```text
strict-clean probe of the lazy cache entry
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```
