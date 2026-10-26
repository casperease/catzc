---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: feature
  targets:
    [
      pwsh/Base.Variants/configs/variants.yml,
      pwsh/Base.Variants/types/VariantTrack.cs,
      pwsh/.internal/assets/bootstrap/Import-AllModules.ps1,
      pwsh/.internal/assets/builder/Write-ModuleBuildOutput.ps1,
      pwsh/.internal/Catzc.Internal.Bootstrap.psm1,
      pwsh/Base.Globs/configs/file-kinds.yml,
      pwsh/Base.Maps/types/MapsMinimapPlaces.cs,
      pwsh/Base.Overlay/private/Get-LocalModuleViolation.ps1,
      docs/drs/design/tracks.md,
      docs/drs/principles/cats-and-catzc.md,
    ]
---

# Module namespace: the track declares it, the disk drops it

Every modules track declares its namespace once (`Catzc` on pwsh; `catzc` with the track's join on js, python, bash and go), its module
folders carry no prefix on disk (`pwsh/Base.Git/`), and the full name (`Catzc.Base.Git`) is what code, manifests, `Get-Module` and the docs
name; the resolver maps one to the other (DDR-TRACK-MODULENAMESPACE). What is left is the final proof.

## Why full namespaces

A module's identity is `catzc://pwsh/Base.Git`: scheme = the product (catzc), authority = the track (pwsh), path = the module. Read that
way, `Catzc.` in the folder name repeats what the scheme already says, and the folder path already says the rest. The full name is still
what leaves the repository (a bundle, a gallery package, `Get-Module` in a consumer's session), where no track or folder is around to supply
the context, so it must be self-contained there. Inside the tree the context is always present, so the path carries only what it adds.

The rule this turns into: **a name is short where its container states the rest, and full wherever it travels** — one resolution of the long
form from the short one, declared once on the track (`ADR-AUTO-DEFAULT-ONERESOLUTIONORDER`), never a second spelling kept in step by hand
(`PDR-ONELIVE`).

## Open steps

1. [ ] **The manual test plan covers the new integrity blocks** (catzc-ed's red sweep): six integrity blocks added in phase 2 have no
       manual-test-plan section yet (Build-WidthConfigs, Build-TrackGlobSets, Build-EnglishDictionary, ConvertTo-PesterRunTarget,
       Test-GeneratedFiles, plus the count of 212 checks for 217 blocks). Check: `Test-ManualTestPlan` reports no issues.
2. [ ] **Full import in a fresh session**, the last step (`importer-path-edits-break-every-session`), after the user's contract-group run
       and the staging item in `task-user-runs-and-commits.md`: `. ./importer.ps1` in a new `pwsh` before anything else runs, then
       `Test-ManualTestPlan`, `Test-GeneratedFiles`, `Test-Links`, `Test-Comments`, `Test-FileMeta` and `Test-TrackNamespace`. Check: the
       import ends without error, `Get-Module Catzc.*` lists the same 56 full names as `out/ns3/before.txt`, and every gate reports none.

## Open question

- Simplify proposal from the session that wrote this plan: the plan-edit hook's reminder could name the required `## Open steps` heading, so
  a new plan passes `Test-Plans` the first time. Recommendation: add the heading name to the reminder text; it costs one line.
