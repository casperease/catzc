---
catzc:
  edges:
    cites:
      - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
      - ADR-REPO-FOLDERS-CLOSEDROOTSET
      - DDR-TRACK-TRACKISPLACEDCLUSTER
      - DDR-TRACK-ONETRACKTYPE
      - DDR-TRACK-ONETECHSTACK
      - DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED
      - DDR-TRACK-DEPLOYABLEUNIT
      - DDR-TRACK-FILELANGUAGE
      - FDR-CD-GLOBS-EVERYSETHASLAYER
      - FDR-CD-GLOBS-COMPOSESETS
---

# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone

```text
Tracks and deployable-units are checked in code; one unit to one pipeline is held by review alone.

1  track                   one root folder, one class, one tech-stack, subscribed to only
2  VariantsConfig          validates the tracks variant on load
3  Get-FileLanguage.Tests  integrity tests over the real repository's tracks and languages
4  deployable-unit         every globset declares its layer; composition is acyclic
5  GlobsConfig             checks layers, keys and compose references on load
6  pipeline                one unit binds one CD pipeline; a CI pipeline binds its track's set
7  scope globset           a cross-cutting slice is a scope over tracks, never a new root
8  code review             the only check of the pipeline rule and the scope rule

Supports DDR-TRACK-TRACKISPLACEDCLUSTER, DDR-TRACK-ONETRACKTYPE, DDR-TRACK-DEPLOYABLEUNIT, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-COMPOSESETS, ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL and ADR-REPO-FOLDERS-CLOSEDROOTSET (governance lens).
```

The tracks DDR sets rules at three levels: what a track is, how a deployable-unit is composed, and how a pipeline binds a unit. Cats checks
the first two in code, when the configuration loads and in integrity tests. The rule that binds one unit to one pipeline, and the rule that
a cross-cutting slice is a scope rather than a new track, have no check in code: code review holds them.

```yml drawio
description:
  Tracks and deployable-units are checked in code, by the variants config, an integrity test over the real repository and the globs config
  on load; the rules that one unit binds one pipeline and that a scope is no new track are held by code review alone.
about:
  adrs:
    - DDR-TRACK-TRACKISPLACEDCLUSTER
    - DDR-TRACK-ONETRACKTYPE
    - DDR-TRACK-DEPLOYABLEUNIT
    - FDR-CD-GLOBS-EVERYSETHASLAYER
    - FDR-CD-GLOBS-COMPOSESETS
    - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
    - ADR-REPO-FOLDERS-CLOSEDROOTSET
  lens: governance
content:
  title: Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone
  kind: explanation
  flow: left-to-right
  relation: is checked by
  theme: dark
  bands:
    - { id: band-tracks, label: TRACKS }
    - { id: band-units, label: DEPLOYABLE-UNITS }
    - { id: band-pipelines, label: PIPELINES · SCOPES }
  glyphs:
    - { id: g-track, kind: set, label: track, in: band-tracks }
    - { id: g-variants-config, kind: gate, label: VariantsConfig, in: band-tracks }
    - { id: g-language-tests, kind: gate, label: Get-FileLanguage.Tests, in: band-tracks }
    - { id: g-unit, kind: set, label: deployable-unit, in: band-units }
    - { id: g-globs-config, kind: gate, label: GlobsConfig, in: band-units }
    - { id: g-pipeline, kind: runner, label: pipeline, in: band-pipelines }
    - { id: g-scope, kind: set, label: scope globset, in: band-pipelines }
    - { id: g-review, kind: drsonly, label: code review, in: band-pipelines }
  edges:
    - { from: g-track, to: g-variants-config, kind: flow, label: "" }
    - { from: g-track, to: g-language-tests, kind: flow, label: "" }
    - { from: g-unit, to: g-globs-config, kind: flow, label: "" }
    - { from: g-pipeline, to: g-review, kind: adr, label: "" }
    - { from: g-scope, to: g-review, kind: adr, label: "" }
  markers:
    - { at: g-track, number: 1 }
    - { at: g-variants-config, number: 2 }
    - { at: g-language-tests, number: 3 }
    - { at: g-unit, number: 4 }
    - { at: g-globs-config, number: 5 }
    - { at: g-pipeline, number: 6 }
    - { at: g-scope, number: 7 }
    - { at: g-review, number: 8 }
  chips:
    - { at: g-track, kind: rule, rule: DDR-TRACK-TRACKISPLACEDCLUSTER }
    - { at: g-track, kind: rule, rule: ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL }
    - { at: g-track, kind: rule, rule: ADR-REPO-FOLDERS-CLOSEDROOTSET }
    - { at: g-unit, kind: rule, rule: FDR-CD-GLOBS-EVERYSETHASLAYER }
    - { at: g-unit, kind: rule, rule: FDR-CD-GLOBS-COMPOSESETS }
    - { at: g-pipeline, kind: rule, rule: DDR-TRACK-DEPLOYABLEUNIT, gated: false }
    - { at: g-scope, kind: rule, rule: DDR-TRACK-ONETRACKTYPE, gated: false }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: ado-pipelines/pipelines/.
        by:
          - .ado/pipelines/cd-apex.yaml
          - .ado/pipelines/cd-flux.yaml
          - .ado/pipelines/cd-nova.yaml
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/ci-infrastructure.yaml
          - .ado/pipelines/ci-pwsh.yaml
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: docs/-/.
        by:
          - docs/drs/design/dora-explains.md
          - docs/drs/design/tracks.md
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/durable-sha-globs.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/drs/repository/conventional-folders.md
          - docs/drs/repository/dora-explains.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/how-to/pwsh/manual-test-plan/repository-conventions.md
          - docs/references/ado/pipelines/cd-apex.yaml.md
          - docs/references/ado/pipelines/cd-flux.yaml.md
          - docs/references/ado/pipelines/cd-nova.yaml.md
          - docs/references/ado/pipelines/cd-shared.yaml.md
          - docs/references/ado/pipelines/ci-infrastructure.yaml.md
          - docs/references/ado/pipelines/ci-pwsh.yaml.md
          - docs/references/github/workflows/ci-pwsh.yml.md
          - docs/references/note-file-kind.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Get-AdoBuildValidations.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Register-AdoBuildValidation.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Unregister-AdoBuildValidation.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/configs/build-validation.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/private/Get-BuildValidationPathFilter.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
          - docs/references/pwsh/catzc-base-globs/configs/globs.yml.md
          - docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
          - docs/references/pwsh/catzc-base-languages.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMap.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapBuilder.cs.md
          - docs/references/pwsh/catzc-base-maps/types/WorldMapHighlight.cs.md
          - docs/references/pwsh/catzc-base-module-system/Test-FolderConventions.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Automation.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestFolders.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Resolve-TestSuite.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-TrackPlace.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - ADR-REPO-FOLDERS-CLOSEDROOTSET
          - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: github-workflows/workflows/.
        by: [.github/workflows/ci-pwsh.yml, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Azure.DevOps/.
        by: [pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/.
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/configs
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/private
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Drs/configs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - ADR-REPO-FOLDERS-CLOSEDROOTSET
          - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsConfig.cs, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.Globs/.
        by: [pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1, pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.Globs/configs
        by: [pwsh/Catzc.Base.Globs/configs/globs.yml, DDR-TRACK-DEPLOYABLEUNIT, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.Globs/private
        by: [pwsh/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.Globs/tests/types
        by:
          - pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
          - DDR-TRACK-DEPLOYABLEUNIT
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Globs/types
        by:
          - pwsh/Catzc.Base.Globs/types/DurableHash.cs
          - pwsh/Catzc.Base.Globs/types/GlobPattern.cs
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Languages/tests
        by: [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Maps/tests
        by:
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Maps/types
        by:
          - pwsh/Catzc.Base.Maps/types/MapCell.cs
          - pwsh/Catzc.Base.Maps/types/WorldMap.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapHighlight.cs
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.ModuleSystem/.
        by:
          - pwsh/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
          - ADR-REPO-FOLDERS-CLOSEDROOTSET
          - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
      - cell: pwsh/Catzc.Base.ModuleSystem/configs
        by: [pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml, DDR-TRACK-DEPLOYABLEUNIT, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: pwsh/Catzc.Base.QualityGates/.
        by: [pwsh/Catzc.Base.QualityGates/Test-Automation.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/terminology.yml, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by:
          - pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
          - DDR-TRACK-ONETRACKTYPE
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: pwsh/Catzc.Base.Variants/.
        by:
          - pwsh/Catzc.Base.Variants/Get-Track.ps1
          - pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Variants/configs
        by:
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: pwsh/Catzc.Base.Variants/types
        by:
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
    module-neighbourhood:
      - cell: subject/.claude
        by: [.claude/CLAUDE.md, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: subject/Catzc.Azure.DevOps
        by: [pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
          - pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - ADR-REPO-FOLDERS-CLOSEDROOTSET
          - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: subject/Catzc.Base.Globs
        by:
          - pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
          - pwsh/Catzc.Base.Globs/configs/globs.yml
          - pwsh/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
          - pwsh/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
          - pwsh/Catzc.Base.Globs/types/DurableHash.cs
          - pwsh/Catzc.Base.Globs/types/GlobPattern.cs
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - DDR-TRACK-DEPLOYABLEUNIT
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: subject/Catzc.Base.Languages
        by: [pwsh/Catzc.Base.Languages/tests/Get-FileLanguage.Tests.ps1, DDR-TRACK-TRACKISPLACEDCLUSTER]
      - cell: subject/Catzc.Base.Maps
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
          - pwsh/Catzc.Base.Maps/types/MapCell.cs
          - pwsh/Catzc.Base.Maps/types/WorldMap.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapBuilder.cs
          - pwsh/Catzc.Base.Maps/types/WorldMapHighlight.cs
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: subject/Catzc.Base.ModuleSystem
        by:
          - pwsh/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
          - pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
          - ADR-REPO-FOLDERS-CLOSEDROOTSET
          - ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/Test-Automation.ps1
          - pwsh/Catzc.Base.QualityGates/configs/terminology.yml
          - pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
          - DDR-TRACK-ONETRACKTYPE
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: subject/Catzc.Base.Variants
        by:
          - pwsh/Catzc.Base.Variants/Get-Track.ps1
          - pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
      - cell: subject/pipelines
        by:
          - .ado/pipelines/cd-apex.yaml
          - .ado/pipelines/cd-flux.yaml
          - .ado/pipelines/cd-nova.yaml
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/ci-infrastructure.yaml
          - .ado/pipelines/ci-pwsh.yaml
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: subject/workflows
        by: [.github/workflows/ci-pwsh.yml, FDR-CD-GLOBS-COMPOSESETS, FDR-CD-GLOBS-EVERYSETHASLAYER]
    axis:
      - cell: DSGN/*
        by:
          - DDR-TRACK-DEPLOYABLEUNIT
          - DDR-TRACK-ONETRACKTYPE
          - DDR-TRACK-TRACKISPLACEDCLUSTER
          - FDR-CD-GLOBS-COMPOSESETS
          - FDR-CD-GLOBS-EVERYSETHASLAYER
      - cell: AUTO/*
        by: [ADR-REPO-FOLDERS-CLOSEDROOTSET, ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL]
layout:
  band-tracks: { x: 20, y: 104, w: 460, h: 380 }
  band-units: { x: 500, y: 104, w: 260, h: 380 }
  band-pipelines: { x: 780, y: 104, w: 500, h: 380 }
  g-track: { x: 140, y: 160, w: 220, h: 52 }
  g-variants-config: { x: 30, y: 350, w: 210, h: 90 }
  g-language-tests: { x: 250, y: 350, w: 220, h: 90 }
  g-unit: { x: 540, y: 160, w: 180, h: 52 }
  g-globs-config: { x: 540, y: 350, w: 180, h: 90 }
  g-pipeline: { x: 820, y: 160, w: 180, h: 52 }
  g-scope: { x: 1060, y: 160, w: 180, h: 52 }
  g-review: { x: 930, y: 360, w: 220, h: 60 }
```

![Tracks and units are checked in code, 1-1 is review only](.assets/unit-to-pipeline-rule-is-review-only.drawio.png)

## Walkthrough

1. **track.** A track is one root folder, named by it, with `out/` excepted; it carries one class (core, external port, adapter or
   verification), owns one tech-stack made of file languages, and is subscribed to only through module dependencies or its globset
   projection. Every root folder git tracks a file under names a track, and the root set is closed.
2. **VariantsConfig.** Validates the `tracks` variant in `variants.yml` on load: each root is one folder segment, never `out`, and owned by
   one track, and each class is one of the four.
3. **Get-FileLanguage.Tests.** Integrity tests over the real repository: every root folder with tracked files is a declared track, every
   language a track declares is registered, and every live file of a track is written in one of the track's declared languages, so a second
   tech-stack fails the build.
4. **deployable-unit.** Every globset declares its layer, `deployable-unit` or `loose-fileset`, and `compose:` references declared sets
   without a cycle.
5. **GlobsConfig.** Checks the units on load: the layer each declares (`module` is rejected as derived-only), no unknown keys, and every
   `compose:` reference resolved, acyclically. `Test-GlobSetIndependence` adds that no two units select a common file on their own
   contribution.
6. **pipeline.** One unit binds one CD pipeline, widening to two only when a DEPLOY stage splits out of CD; a CI pipeline that verifies a
   whole track binds that track's own set.
7. **scope globset.** A cross-cutting slice is a scope over tracks, never a new root. `GlobsConfig` accepts a scope as a `loose-fileset`,
   and that layer is exempt from the independence check.
8. **code review.** The only check of the pipeline rule and the scope rule. `globs.yml` lets any layer carry `pipeline:`, and the gates on
   the trigger check a bound pipeline's paths, not the shape of the binding. Today six globsets bind six distinct pipelines, so one to one
   holds by fact.

## Why it holds

- A track is one root folder, named by it, and every tracked root folder except `out/` is a track (DDR-TRACK-TRACKISPLACEDCLUSTER,
  ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL); the root set is closed (ADR-REPO-FOLDERS-CLOSEDROOTSET).
- Each track carries one class, and a cross-cutting slice is a scope, not a track (DDR-TRACK-ONETRACKTYPE).
- A track owns one tech-stack, and a tech-stack is a set of file languages (DDR-TRACK-ONETECHSTACK, DDR-TRACK-FILELANGUAGE).
- Tracks are subscribed to, never path-coupled (DDR-TRACK-SUBSCRIBABLENOTPATHCOUPLED).
- Every globset declares its layer, and composition is acyclic (FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-COMPOSESETS).
- Units bind pipelines one to one (DDR-TRACK-DEPLOYABLEUNIT).

## Where the code and the decision record differ

- The tracks DDR's enforcement list names the folders ADR, the globset registry, the gates on dependencies and code review, but not the
  `tracks` variant, its load-time validation, or the integrity tests that now check rules 1, 2, 3 and 6.
- The folders ADR names `go/` and `python/` as amendments to the closed root set, but not `bash/`, which the tracks DDR and `variants.yml`
  declare as a track.

## See also

- [Tracks — the repository's root concerns](../../drs/design/tracks.md) — the decision this article explains.
- The other lenses on the same model: [meta](one-unit-one-pipeline.md), [architecture](units-not-tracks-own-the-pipelines.md),
  [implementation](globs-yml-pipeline-field-is-the-binding.md) and [operations](a-push-fires-only-touched-pipelines.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
