---
catzc:
  edges:
    cites:
      - DDR-TRACK-UNORDEREDTRACK
      - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
      - TDR-NORMALFORM
---

# A file leaves the unordered track only in the normal form

```text
A file leaves the unordered track only in the normal form.

1  code fragment        a file in the unordered track, in whatever shape its origin left it
2  one file per commit  fragment migration: one reviewed change at a time
3  own checks           the repository's formatters, tests and asserts, run over the change
4  contested            a check changes the file or fails, so migration goes on
5  in the form          no check changes it and none fails: the eac normal form
6  module or track      the file leaves the unordered track for its home
7  enabling constraints sensible defaults, catzc bundle, local configs: all a check may use

Supports TDR-NORMALFORM-ANYCODEHASNORMALFORM, TDR-NORMALFORM-ENABLINGCONSTRAINTS, TDR-NORMALFORM-UNCONTESTED,
TDR-NORMALFORM-MIGRATIONREACHESTHEFORM, DDR-TRACK-UNORDEREDTRACK and DDR-TRACK-MIGRATEONEFILEPERCOMMIT (meta lens).
```

Code reaches cats from many places: written in the trunk, imported with its history, copied from a vendor sample, exported from a UI. The
thesis gives all of it one target shape, the **eac normal form**: code the repository can verify within its enabling constraints, and that
its own formatters, tests and asserts leave unchanged and do not fail. An import lands in the unordered track, and fragment migration moves
each file into the form before it leaves the track for its home.

```yml drawio
description:
  "One band holds four groups left to right: a file in the unordered track, a runner and a gate that loops back to it on a failure path, and
  a result that feeds a named set; a group of three named sets stands beneath."
about:
  adrs:
    - TDR-NORMALFORM-ANYCODEHASNORMALFORM
    - TDR-NORMALFORM-ENABLINGCONSTRAINTS
    - TDR-NORMALFORM-UNCONTESTED
    - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
    - DDR-TRACK-UNORDEREDTRACK
    - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
  lens: meta
content:
  title: A file leaves the unordered track only in the normal form
  kind: explanation
  flow: left-to-right
  relation: moves on
  theme: dark
  bands:
    - { id: band-constraints, label: INSIDE THE ENABLING CONSTRAINTS }
  groups:
    - { id: grp-unordered, label: UNORDERED TRACK, in: band-constraints }
    - { id: grp-migration, label: FRAGMENT MIGRATION, in: band-constraints }
    - { id: grp-form, label: EAC NORMAL FORM, in: band-constraints }
    - { id: grp-constraints, label: ENABLING CONSTRAINTS, in: band-constraints }
  glyphs:
    - { id: f-fragment, kind: file, label: code fragment, in: grp-unordered }
    - { id: r-migration, kind: runner, label: one file per commit, in: grp-migration }
    - { id: gt-fixed, kind: gate, label: own checks, in: grp-migration }
    - { id: res-form, kind: result, label: in the form, in: grp-form }
    - { id: st-home, kind: set, label: module or track, in: grp-form }
    - { id: st-defaults, kind: set, label: sensible defaults, in: grp-constraints }
    - { id: st-bundle, kind: set, label: catzc bundle, in: grp-constraints }
    - { id: st-configs, kind: set, label: local configs, in: grp-constraints }
  edges:
    - { from: f-fragment, to: r-migration, kind: flow, label: one change }
    - { from: r-migration, to: gt-fixed, kind: flow, label: "" }
    - { from: gt-fixed, to: r-migration, kind: fail, label: contested }
    - { from: gt-fixed, to: res-form, kind: thick, label: uncontested }
    - { from: res-form, to: st-home, kind: flow, label: leaves }
  legend: auto
  minimaps:
    axis:
      - cell: DSGN/build
        by:
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: DSGN/quality-control
        by:
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: DSGN/release
        by:
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: DSGN/deploy
        by:
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: DSGN/access
        by:
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: DSGN/*
        by: [DDR-TRACK-MIGRATEONEFILEPERCOMMIT, DDR-TRACK-UNORDEREDTRACK]
    lifecycle-position:
      - cell: main-uat
        by:
          - .claude/CLAUDE.md
          - docs/drs/index.md
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
          - DDR-TRACK-UNORDEREDTRACK
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: release-uat
        by:
          - .claude/CLAUDE.md
          - docs/drs/index.md
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
          - DDR-TRACK-UNORDEREDTRACK
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: pre-prod
        by:
          - .claude/CLAUDE.md
          - docs/drs/index.md
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
          - DDR-TRACK-UNORDEREDTRACK
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
      - cell: prod
        by:
          - .claude/CLAUDE.md
          - docs/drs/index.md
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
          - DDR-TRACK-UNORDEREDTRACK
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
    layer-stack:
      - cell: automation
        by:
          - .claude/CLAUDE.md
          - docs/drs/design/dora-explains.md
          - docs/drs/design/tracks.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/drs/thesis/dora-explains.md
          - docs/drs/thesis/eac-normal-form.md
          - docs/how-to/automation/sort-an-import.md
          - docs/how-to/getting-started/automation/add-a-doc-chapter.md
          - docs/how-to/getting-started/automation/add-an-adr.md
          - docs/how-to/pwsh/manual-test-plan/repository-conventions.md
          - docs/references/note-file-kind.md
          - docs/references/pwsh/catzc-base-git/Import-RepositoryWithHistory.ps1.md
          - docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Formatting.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-ContentExemptPath.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md
          - docs/references/pwsh/catzc-base-variants/Get-TrackPlace.ps1.md
          - docs/references/pwsh/catzc-base-variants/configs/variants.yml.md
          - docs/references/pwsh/catzc-base-variants/types/VariantTrack.cs.md
          - docs/references/pwsh/catzc-base-variants/types/VariantsConfig.cs.md
          - pwsh/Catzc.Base.Docs/configs/glossary.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Git/Import-RepositoryWithHistory.ps1
          - pwsh/Catzc.Base.Git/tests/Import-RepositoryWithHistory.Tests.ps1
          - pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
          - pwsh/Catzc.Base.ModuleSystem/configs/glossary.yml
          - pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1
          - pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
          - pwsh/Catzc.Base.QualityGates/private/Get-ContentExemptPath.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
          - pwsh/Catzc.Base.Variants/Get-Track.ps1
          - pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1
          - pwsh/Catzc.Base.Variants/configs/track-types.yml
          - pwsh/Catzc.Base.Variants/configs/variants.yml
          - pwsh/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
          - pwsh/Catzc.Base.Variants/types/VariantTrack.cs
          - pwsh/Catzc.Base.Variants/types/VariantsConfig.cs
          - DDR-TRACK-MIGRATEONEFILEPERCOMMIT
          - DDR-TRACK-UNORDEREDTRACK
          - TDR-NORMALFORM-ANYCODEHASNORMALFORM
          - TDR-NORMALFORM-ENABLINGCONSTRAINTS
          - TDR-NORMALFORM-MIGRATIONREACHESTHEFORM
          - TDR-NORMALFORM-UNCONTESTED
```

![A file leaves the unordered track only in the normal form](.assets/eac-normal-form.drawio.png)

## Walkthrough

1. **Code fragment.** A file in the unordered track holds code the repository keeps but does not decide by. Its shape is whatever its origin
   left it, and nothing reads it as truth while it stays there.
2. **One file per commit.** Fragment migration changes the fragment through the one change process, one file per reviewed commit, so each
   step is small enough to review and to revert.
3. **Own checks.** Every change runs the repository's own formatters, tests and asserts over the file. They decide whether the form is
   reached, never a person's judgement.
4. **Contested.** A formatter that still rewrites the file, or a test or assert that fails on it, sends the file back to migration. A file
   whose tests pass but that a formatter still rewrites is not yet in the form.
5. **In the form.** When no check changes the file and none fails, running them again changes nothing: the file is at the fixed point of the
   checks, uncontested.
6. **Module or track.** Only then does the file leave the unordered track for the module or track that owns it.
7. **Enabling constraints.** The whole flow sits inside the sensible defaults, the catzc bundle and the local configs. A check that needs
   anything outside them, a tool installed by hand or a value one person knows, cannot be repeated, so passing it proves nothing.

## Why it holds

- Everything inside a responsibility domain is code managed through one change process, so any code, an unordered fragment included, has an
  eac normal form (TDR-NORMALFORM-ANYCODEHASNORMALFORM).
- Code is in the form when it can be verified within the sensible defaults, the catzc bundle and the local configs, and nothing else
  (TDR-NORMALFORM-ENABLINGCONSTRAINTS).
- The form is the fixed point of the repository's own checks: none changes the code and none fails, decided by running them
  (TDR-NORMALFORM-UNCONTESTED).
- Fragment migration brings an unordered fragment into the form through the one change process, and until then it decides nothing about the
  delivered system (TDR-NORMALFORM-MIGRATIONREACHESTHEFORM).
- An import lands in the unordered track, and nothing reads or defaults to the track (DDR-TRACK-UNORDEREDTRACK); sorting moves one file per
  commit (DDR-TRACK-MIGRATEONEFILEPERCOMMIT).

## See also

- [Eac normal form](../../drs/thesis/eac-normal-form.md) — the thesis this article explains.
- [Tracks](../../drs/design/tracks.md#rule-ddr-track-unorderedtrack) — the unordered track and how files leave it.
- [The thesis explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
