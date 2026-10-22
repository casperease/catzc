# Test-GlobSetIndependence groups every set by layer and tests each same-layer pair

```text
The independence gate groups every globset by layer and tests each same-layer pair for a shared file.

1  deployable-unit sets          the five layer: deployable-unit entries in globs.yml
2  declared loose-filesets       the five layer: loose-fileset entries; their group is skipped
3  ReservedNames umbrellas       four derived loose-filesets over the dot-folders; also skipped
4  module-layer sets             88 derived sets: aspects, internal files, module-leftovers
5  Overlaps per pair (units)     every deployable-unit pair tested for a shared own file
6  Overlaps per pair (modules)   the same pairwise test over the module group
7  Write-QualityGateReport       writes the report under out/test-globset-independence/
8  One throw lists every pair    on issues, one throw with one line per overlapping pair

Supports FDR-CD-GLOBS-EVERYSETHASLAYER and FDR-CD-GLOBS-NOOVERLAPWITHINLAYER (implementation lens).
```

The gate `Test-GlobSetIndependence` takes every declared and derived globset, computes each one's own members, groups the sets by `Layer`,
skips the `loose-fileset` group, and tests every pair inside the other groups for a shared file. Where a set's layer comes from therefore
decides whether it is ever compared with anything. All paths below are under `pwsh/Catzc.Base.Globs/`.

```yml drawio
description:
  The independence gate groups every declared and derived globset by layer, skips the loose-fileset group, tests each same-layer pair for a
  shared file, writes a report, and throws once with one line per overlapping pair.
about:
  adrs: [FDR-CD-GLOBS-EVERYSETHASLAYER, FDR-CD-GLOBS-NOOVERLAPWITHINLAYER]
  lens: implementation
content:
  title: Test-GlobSetIndependence groups every set by layer and tests each same-layer pair
  kind: explanation
  flow: left-to-right
  relation: in code order
  theme: dark
  bands:
    - { id: band-deployable-unit, label: DEPLOYABLE-UNIT }
    - { id: band-loose-fileset, label: LOOSE-FILESET }
    - { id: band-module, label: MODULE }
  glyphs:
    - { id: s-deployable-units, kind: set, label: deployable-unit sets, in: band-deployable-unit }
    - { id: g-overlaps-units, kind: gate, label: Overlaps per pair, in: band-deployable-unit }
    - { id: s-declared-loose, kind: set, label: declared loose-filesets, in: band-loose-fileset }
    - { id: s-reserved-names, kind: set, label: ReservedNames umbrellas, in: band-loose-fileset }
    - { id: g-report, kind: code, label: Write-QualityGateReport, in: band-loose-fileset }
    - { id: f-throw, kind: failure, label: One throw lists every pair, in: band-loose-fileset }
    - { id: s-module-layer, kind: set, label: module-layer sets, in: band-module }
    - { id: g-overlaps-modules, kind: gate, label: Overlaps per pair, in: band-module }
  edges:
    - { from: s-deployable-units, to: g-overlaps-units, kind: flow, label: "" }
    - { from: s-module-layer, to: g-overlaps-modules, kind: flow, label: "" }
    - { from: g-overlaps-units, to: g-report, kind: flow, label: "" }
    - { from: g-overlaps-modules, to: g-report, kind: flow, label: "" }
    - { from: g-report, to: f-throw, kind: fail, label: "" }
  markers:
    - { at: s-deployable-units, number: 1 }
    - { at: s-declared-loose, number: 2 }
    - { at: s-reserved-names, number: 3 }
    - { at: s-module-layer, number: 4 }
    - { at: g-overlaps-units, number: 5 }
    - { at: g-overlaps-modules, number: 6 }
    - { at: g-report, number: 7 }
    - { at: f-throw, number: 8 }
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
  band-deployable-unit: { x: 20, y: 84, w: 1260, h: 120 }
  band-loose-fileset: { x: 20, y: 254, w: 1260, h: 120 }
  band-module: { x: 20, y: 424, w: 1260, h: 120 }
  s-deployable-units: { x: 140, y: 120, w: 300, h: 56 }
  g-overlaps-units: { x: 760, y: 104, w: 200, h: 88 }
  s-declared-loose: { x: 140, y: 290, w: 300, h: 56 }
  s-reserved-names: { x: 480, y: 290, w: 230, h: 56 }
  g-report: { x: 760, y: 290, w: 200, h: 56 }
  f-throw: { x: 1010, y: 296, w: 230, h: 44 }
  s-module-layer: { x: 140, y: 460, w: 440, h: 56 }
  g-overlaps-modules: { x: 760, y: 444, w: 200, h: 88 }
```

![Test-GlobSetIndependence groups by layer](.assets/independence-check-groups-by-layer.drawio.png)

## Walkthrough

1. **deployable-unit sets.** The five entries in `configs/globs.yml` with `layer: deployable-unit`, loaded by `GlobsConfig` and returned by
   `Get-GlobSet`. `nova`, `apex`, `flux` and `shared` compose the base `template-azure-subscription-foundation`.
2. **declared loose-filesets.** The five entries with `layer: loose-fileset`: `automation`, `infrastructure`, `templates`, `markdown-scope`
   and `repository`. Their group is skipped, so they reach no gate.
3. **ReservedNames umbrellas.** `Get-ModuleGlobSet` builds one set per name in `GlobsConfig.ReservedNames` (`internal`, `vendor`,
   `compiled`, `scriptanalyzer`) over its dot-folder, with the layer `loose-fileset`. They join the skipped group.
4. **module-layer sets.** `Get-ModuleGlobSet` derives, with the layer `module`, two aspect sets per module folder through `AspectPartition`
   (80 from 40 folders; the tests aspect also takes the module's Go, Python and Bash test folders), one single-file set per
   `.internal/*.psm1` (7), and the catch-all `module-leftovers`: 88 sets in all.
5. **Overlaps per pair, deployable-unit.** `Test-GlobSetIndependence` reads the tracked files with `Get-TrackedFile` and builds each set's
   own members once, as a `HashSet`, through `GlobSet.SelectOwnMembers`: the set's own include and exclude rules, compose ignored. It then
   groups the sets with `Group-Object Layer` and tests every pair in the group with `HashSet.Overlaps`.
6. **Overlaps per pair, module.** The same pairwise test runs over the module group. Only an overlapping pair lists its shared paths, up to
   five of them, in one issue line.
7. **Write-QualityGateReport.** The gate ends by writing its report to `out/test-globset-independence/`, with the number of sets and tracked
   files as facts. With `-PassThru` it returns the result instead.
8. **One throw lists every pair.** When there are issues, the report throws once and lists every overlapping pair, one line each.

## Why it holds

- Every globset carries a layer; `deployable-unit` and `loose-fileset` are declared, and `module` is derived from the folders and the
  internal module files (FDR-CD-GLOBS-EVERYSETHASLAYER).
- Within a layer, no two globsets select a common file on their own contribution, compose ignored; validation is per layer, never across,
  and the `loose-fileset` layer is exempt (FDR-CD-GLOBS-NOOVERLAPWITHINLAYER).

## See also

- [Globset triggers](../../drs/flow/durable-sha-globs.md) — the decision this article explains.
- The other lenses on the same layers: [meta](peers-in-a-layer-never-overlap.md), [architecture](two-declared-layers-one-derived.md),
  [operations](declare-or-add-folder-gate-names-overlaps.md) and [governance](overlap-gated-for-units-and-modules.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
