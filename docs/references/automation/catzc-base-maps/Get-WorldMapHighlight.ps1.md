---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/Get-WorldMapHighlight.ps1.md
    kind: comment-page
    body_sha: "33d38267c97c"
    adrs:
      - ADR-DSGN-TRACK#1
      - ADR-THES-ONETRUTH#3
    links: []
---

# automation/Catzc.Base.Maps/Get-WorldMapHighlight.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the world map (Get-WorldMap) and lights its cells with Catzc.Base.Maps.WorldMapHighlight.

-Adr lights, for each code (ADR-<CODE>, or one rule as ADR-<CODE>#n or ADR-<CODE>:n): the ADR files of the code's
domain, and every file whose citations name it, in the fixed order per artifact kind the map derives (module code by
its own citations, a repository-root file by its files.yml owner, a pipeline by its citations or else its globset).
The reviewed exceptions and pins of configs/maps.yml then apply: an exception keeps its cell dark and a pin lights
its cell. -Path lights the cells the given tracked files sit in
([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)).

With neither, it answers "where does my change sit on the map": the files the working tree changes against HEAD
and the index (modified, added, deleted or untracked; Get-GitChangedPath) light the cells they sit in, as
with -Path. The map holds the files git tracks, so a changed file it does not hold (an untracked file, or one
whose removal is staged) lights nothing and is named in the verbose stream. With no change, no cell is lit.
```

## comment:2

Section `.PARAMETER AsJson` of the comment-based help.

```text
Return the highlight as JSON (the request, and the lit cells with their files and each file's reason: the basis,
the covering request and the citation sites with their lines and kinds) instead of the object
([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```
