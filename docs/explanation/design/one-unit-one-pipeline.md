---
catzc:
  edges:
    cites:
      - DDR-TRACK-TRACKISPLACEDCLUSTER
      - DDR-TRACK-ONETRACKTYPE
      - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
      - DDR-TRACK-DEPLOYABLEUNIT
---

# A track ships through a deployable-unit, and each unit has one pipeline

```text
A track ships through a deployable-unit, and each unit binds one pipeline.

1  Track             one root concern, mapped onto one root folder and named by it
2  Composes into     a unit is a whole track or a reduced composition of one
3  Deployable-unit   what ships
4  Binds one         one unit, one pipeline; two only when DEPLOY splits out of CD
5  Pipeline          the unit's delivery machine

Supports DDR-TRACK-TRACKISPLACEDCLUSTER, DDR-TRACK-ONETRACKTYPE, DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED and DDR-TRACK-DEPLOYABLEUNIT (meta lens).
```

Three words carry the delivery side of cats: a track is a concern, a deployable-unit is what ships, and a pipeline is a unit's delivery
machine. The invariant ties them in a line: units are composed from tracks, each unit binds one pipeline, and a pipeline never reaches a
track except through the unit that is that track.

```yml drawio
description: "A track composes into a deployable-unit, and a deployable-unit binds one pipeline: the delivery side of cats in a line."
about:
  adrs: [DDR-TRACK-TRACKISPLACEDCLUSTER, DDR-TRACK-ONETRACKTYPE, DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED, DDR-TRACK-DEPLOYABLEUNIT]
  lens: meta
content:
  title: A track ships through a deployable-unit, and each unit has one pipeline
  kind: explanation
  flow: left-to-right
  relation: binds one pipeline (1-1)
  theme: dark
  bands:
    - { id: band-tracks, label: TRACKS }
    - { id: band-units, label: DEPLOYABLE-UNITS }
    - { id: band-pipelines, label: PIPELINES }
  glyphs:
    - { id: s-track, kind: set, label: Track, in: band-tracks }
    - { id: s-unit, kind: set, label: Deployable-unit, in: band-units }
    - { id: r-pipeline, kind: runner, label: Pipeline, in: band-pipelines }
  edges:
    - { from: s-track, to: s-unit, kind: thick, label: "" }
    - { from: s-unit, to: r-pipeline, kind: flow, label: "" }
  markers:
    - { at: s-track, number: 1 }
    - { at: s-track->s-unit, number: 2 }
    - { at: s-unit, number: 3 }
    - { at: s-unit->r-pipeline, number: 4 }
    - { at: r-pipeline, number: 5 }
  legend: auto
  minimaps:
    code-locations:
      - cell: ado-pipelines/pipelines/.
        by: [.ado/pipelines/ci-pwsh.yaml, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: docs/-/.
        by:
          - docs/drs/design/dora-explains.md
          - docs/drs/design/tracks.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/how-to/pwsh/manual-test-plan/repository-conventions.md
          - docs/references/ado/pipelines/ci-pwsh.yaml.md
          - docs/references/note-file-kind.md
          - docs/references/pwsh/catzc-base-globs/configs/globs.yml.md
          - docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestFolders.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-TrackPlace.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Globs/configs
        by: [pwsh/Catzc.Base.Globs/configs/globs.yml, DDR-TRACK-DEPLOYABLEUNIT]
      - cell: pwsh/Catzc.Base.Globs/tests/types
        by: [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1, DDR-TRACK-DEPLOYABLEUNIT]
      - cell: pwsh/Catzc.Base.Languages/tests
        by: [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Maps/tests
        by: [pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: pwsh/Catzc.Base.Maps/types
        by:
          - pwsh/Catzc.Base.Maps/types/MapCell.cs
          - pwsh/Catzc.Base.Maps/types/WorldMap.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapHighlight.cs
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.ModuleSystem/configs
        by: [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml, DDR-TRACK-DEPLOYABLEUNIT, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1, DDR-TRACK-ONETRACKTYPE]
      - cell: pwsh/Catzc.Base.Variants/.
        by:
          - pwsh/Catzc.Base.Variants/Get-Track.ps1
          - pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Variants/configs
        by:
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Variants/types
        by:
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
    grid:
      - cell: ado-pipelines/pipeline-yaml
        by: [.ado/pipelines/ci-pwsh.yaml, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: docs/markdown
        by:
          - docs/drs/design/dora-explains.md
          - docs/drs/design/tracks.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/how-to/pwsh/manual-test-plan/repository-conventions.md
          - docs/references/ado/pipelines/ci-pwsh.yaml.md
          - docs/references/note-file-kind.md
          - docs/references/pwsh/catzc-base-globs/configs/globs.yml.md
          - docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestFolders.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-TrackPlace.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/bcl
        by:
          - pwsh/Catzc.Base.Maps/types/MapCell.cs
          - pwsh/Catzc.Base.Maps/types/WorldMap.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapHighlight.cs
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/powershell
        by:
          - pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1
          - pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
          - pwsh/Catzc.Base.Variants/Get-Track.ps1
          - pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/yaml
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Globs/configs/globs.yml
          - pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
          - DDR-TRACK-TRACKISPLACEDCLUSTER
    axis:
      - cell: DSGN/*
        by: [DDR-TRACK-DEPLOYABLEUNIT, DDR-TRACK-ONETRACKTYPE, DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED, DDR-TRACK-TRACKISPLACEDCLUSTER]
layout:
  band-tracks: { x: 20, y: 84, w: 300, h: 180 }
  band-units: { x: 340, y: 84, w: 520, h: 180 }
  band-pipelines: { x: 880, y: 84, w: 400, h: 180 }
  s-track: { x: 60, y: 146, w: 220, h: 56 }
  s-unit: { x: 480, y: 146, w: 220, h: 56 }
  r-pipeline: { x: 960, y: 146, w: 240, h: 56 }
```

![One unit, one pipeline; tracks ship through units](.assets/one-unit-one-pipeline.drawio.png)

## Walkthrough

1. **Track.** One root concern of the repository, mapped onto one root folder and named by it.
2. **Composes into.** A deployable-unit is a reduced composition of tracks; a CI pipeline that verifies a whole track binds the track's own
   set instead. Consumers reach a track only through module dependencies or its globset projection, never by matching its paths.
3. **Deployable-unit.** What ships.
4. **Binds one pipeline.** One unit, one pipeline, widening to two only when a DEPLOY stage splits out of CD. No gate checks it; code review
   holds it.
5. **Pipeline.** The unit's delivery machine.

## Why it holds

- A track is one root concern with one root folder (DDR-TRACK-TRACKISPLACEDCLUSTER).
- Tracks are subscribed to, never path-coupled (DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED).
- Deployable-units determine CD pipelines one to one, and a CI pipeline that verifies a whole track binds the track's own set
  (DDR-TRACK-DEPLOYABLEUNIT).

A cross-cutting slice, such as every markdown file, is a scope over tracks rather than a track: it selects through the roots and owns none
(DDR-TRACK-ONETRACKTYPE).

## See also

- [Tracks — the repository's root concerns](../../drs/design/tracks.md) — the decision this article explains.
- The other lenses on the same model: [architecture](units-not-tracks-own-the-pipelines.md),
  [implementation](globs-yml-pipeline-field-is-the-binding.md), [operations](a-push-fires-only-touched-pipelines.md) and
  [governance](unit-to-pipeline-rule-is-review-only.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
