---
catzc:
  edges:
    cites:
      - FDR-CD-GLOBS-EVERYSETHASLAYER
      - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
---

# Peers in a layer never share a file, except in the loose-fileset layer

```text
Peers in a layer never share a file on their own contribution; only loose-filesets may overlap.

1  What ships               the deployable-unit layer: one boundary per unit that ships
2  Cross-cutting surfaces   the loose-fileset layer: overlaps the other layers by design
3  Module space             the module layer: derived from the folders, never declared
4  Peers disjoint           the one rule, checked by a gate for the two boundary layers

Supports FDR-CD-GLOBS-EVERYSETHASLAYER and FDR-CD-GLOBS-NOOVERLAPWITHINLAYER (meta lens).
```

Every globset in cats belongs to one layer, and a layer is a set of peers that partition one concern into boundaries. Within a layer, no two
peers share a file on their own contribution, because overlap would mean one boundary consumes another's files. The `loose-fileset` layer,
which cuts across the others, is the only exemption, and across layers one file may sit in all three.

```yml drawio
description:
  "The three globset layers as bands: deployable-unit, loose-fileset and module sets, with one rule across them, peers in a layer are
  disjoint, which a gate checks for the two boundary layers and the loose-fileset layer is exempt from."
about:
  adrs: [FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
  lens: meta
content:
  title: Peers in a layer never share a file, except in the loose-fileset layer
  kind: explanation
  flow: top-to-bottom
  relation: checks its peers
  theme: dark
  bands:
    - { id: band-unit, label: DEPLOYABLE-UNIT }
    - { id: band-loose, label: LOOSE-FILESET }
    - { id: band-module, label: MODULE }
  glyphs:
    - { id: s-ships, kind: set, label: What ships, in: band-unit }
    - { id: g-peers-disjoint, kind: gate, label: Peers disjoint, in: band-unit }
    - { id: s-cross-cutting, kind: set, label: Cross-cutting surfaces, in: band-loose }
    - { id: s-module-space, kind: set, label: Module space, in: band-module }
  edges:
    - { from: g-peers-disjoint, to: s-ships, kind: flow, label: "" }
    - { from: g-peers-disjoint, to: s-module-space, kind: flow, label: "" }
  markers:
    - { at: s-ships, number: 1 }
    - { at: s-cross-cutting, number: 2 }
    - { at: s-module-space, number: 3 }
    - { at: g-peers-disjoint, number: 4 }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: ado-pipelines/pipelines/.
        by:
          - .ado/pipelines/cd-apex.yaml
          - .ado/pipelines/cd-flux.yaml
          - .ado/pipelines/cd-nova.yaml
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/ci-infrastructure.yaml
          - .ado/pipelines/ci-pwsh.yaml
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: docs/-/.
        by:
          - docs/drs/flow/dora-explains.md
          - docs/drs/flow/durable-sha-globs.md
          - docs/drs/index.md
          - docs/how-to/automation/apply-environment-approvals.md
          - docs/how-to/pwsh/manual-test-plan/pipelines-and-globs.md
          - docs/references/ado/pipelines/cd-apex.yaml.md
          - docs/references/ado/pipelines/cd-flux.yaml.md
          - docs/references/ado/pipelines/cd-nova.yaml.md
          - docs/references/ado/pipelines/cd-shared.yaml.md
          - docs/references/ado/pipelines/ci-infrastructure.yaml.md
          - docs/references/ado/pipelines/ci-pwsh.yaml.md
          - docs/references/github/workflows/ci-pwsh.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Get-AdoBuildValidations.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Register-AdoBuildValidation.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/Unregister-AdoBuildValidation.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/configs/build-validation.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/private/Get-BuildValidationPathFilter.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops/Sync-AdoEnvironmentApprovals.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsConfig.cs.md
          - docs/references/pwsh/catzc-base-globs.md
          - docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
          - docs/references/pwsh/catzc-base-globs/configs/globs.yml.md
          - docs/references/pwsh/catzc-base-globs/private/Get-PipelineTrigger.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/GlobSet-Independence.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/types/DurableHash.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobPattern.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-LifecyclePositionMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-WorldMapHighlight.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Automation.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Resolve-TestSuite.ps1.md
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: github-workflows/workflows/.
        by: [.github/workflows/ci-pwsh.yml, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Azure.DevOps/.
        by: [pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/.
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/configs
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/private
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Base.Drs/configs
        by: [pwsh/Catzc.Base.Drs/configs/drs.yml, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsConfig.cs, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Base.Globs/.
        by:
          - pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Base.Globs/configs
        by: [pwsh/Catzc.Base.Globs/configs/globs.yml, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Base.Globs/private
        by: [pwsh/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Base.Globs/tests
        by:
          - pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Base.Globs/tests/types
        by: [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.Globs/types
        by:
          - pwsh/Catzc.Base.Globs/types/DurableHash.cs
          - pwsh/Catzc.Base.Globs/types/GlobPattern.cs
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: pwsh/Catzc.Base.Maps/tests
        by: [pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Base.QualityGates/.
        by: [pwsh/Catzc.Base.QualityGates/Test-Automation.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER]
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by: [pwsh/Catzc.Base.QualityGates/configs/terminology.yml, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: pwsh/Catzc.Base.QualityGates/private
        by: [pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER]
    module-neighbourhood:
      - cell: subject/.claude
        by: [.claude/CLAUDE.md, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: subject/Catzc.Azure.DevOps
        by: [pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by:
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Register-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/Unregister-AdoBuildValidation.ps1
          - pwsh/Catzc.Azure.DevOps.BuildValidation/configs/build-validation.yml
          - pwsh/Catzc.Azure.DevOps.BuildValidation/private/Get-BuildValidationPathFilter.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/types/DrsConfig.cs
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: subject/Catzc.Base.Globs
        by:
          - pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
          - pwsh/Catzc.Base.Globs/configs/globs.yml
          - pwsh/Catzc.Base.Globs/private/Get-PipelineTrigger.ps1
          - pwsh/Catzc.Base.Globs/tests/GlobSet-Independence.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
          - pwsh/Catzc.Base.Globs/types/DurableHash.cs
          - pwsh/Catzc.Base.Globs/types/GlobPattern.cs
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: subject/Catzc.Base.Maps
        by:
          - pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-WorldMapHighlight.Tests.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/Test-Automation.ps1
          - pwsh/Catzc.Base.QualityGates/configs/terminology.yml
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: subject/pipelines
        by:
          - .ado/pipelines/cd-apex.yaml
          - .ado/pipelines/cd-flux.yaml
          - .ado/pipelines/cd-nova.yaml
          - .ado/pipelines/cd-shared.yaml
          - .ado/pipelines/ci-infrastructure.yaml
          - .ado/pipelines/ci-pwsh.yaml
          - FDR-CD-GLOBS-EVERYSETHASLAYER
          - FDR-CD-GLOBS-NOOVERLAPWITHINLAYER
      - cell: subject/workflows
        by: [.github/workflows/ci-pwsh.yml, FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
    axis:
      - cell: DSGN/*
        by: [FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
layout:
  band-unit: { x: 20, y: 84, w: 1260, h: 140 }
  band-loose: { x: 20, y: 244, w: 1260, h: 120 }
  band-module: { x: 20, y: 384, w: 1260, h: 140 }
  s-ships: { x: 140, y: 140, w: 300, h: 56 }
  g-peers-disjoint: { x: 470, y: 124, w: 180, h: 84 }
  s-cross-cutting: { x: 140, y: 290, w: 300, h: 56 }
  s-module-space: { x: 140, y: 440, w: 840, h: 56 }
```

![Peers in a layer never overlap, except loose-filesets](.assets/peers-in-a-layer-never-overlap.drawio.png)

## Walkthrough

1. **What ships.** The `deployable-unit` layer is declared: one boundary per unit that ships. A unit never consumes another unit's files.
2. **Cross-cutting surfaces.** The `loose-fileset` layer holds track roots, scan scopes and the reserved umbrellas. Its sets overlap the
   boundaries of the other two layers by design, so nothing checks its peers against each other, and it stands alone.
3. **Module space.** The `module` layer is derived from the folders and never declared: aspect sets per module folder, one set per internal
   shared module file, and a catch-all for module-space files no module owns. A module never consumes another module's files.
4. **Peers disjoint.** The one rule: peers in a layer are disjoint on their own files, with composition ignored, and a gate checks it for
   the `deployable-unit` and `module` layers. A file under `pwsh/Catzc.Base.Globs/` still belongs to the `pwsh` track, to a module set and,
   if it ships, to a deployable-unit, because overlap across layers is expected.

## Why it holds

- Every globset carries a layer: two are declared, and `module` is derived-only (FDR-CD-GLOBS-EVERYSETHASLAYER).
- Within a layer, no two globsets select a common file on their own contribution; the rule is per layer, never across, and the
  `loose-fileset` layer is exempt (FDR-CD-GLOBS-NOOVERLAPWITHINLAYER).

## Where the code and the decision record differ

The FDR describes one module set per folder. The code derives two aspect sets per folder, `-live` and `-tests`, and no whole-module set.

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same layers: [architecture](two-declared-layers-one-derived.md),
  [implementation](independence-check-groups-by-layer.md), [operations](declare-or-add-folder-gate-names-overlaps.md) and
  [governance](overlap-gated-for-units-and-modules.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
