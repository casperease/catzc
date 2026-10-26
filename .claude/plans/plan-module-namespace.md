---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Variants/configs/variants.yml,
      pwsh/Catzc.Base.Variants/types/VariantTrack.cs,
      pwsh/.internal/assets/bootstrap/Import-AllModules.ps1,
      pwsh/.internal/assets/builder/Write-ModuleBuildOutput.ps1,
      pwsh/.internal/Catzc.Internal.Bootstrap.psm1,
      pwsh/Catzc.Base.Globs/configs/file-kinds.yml,
      pwsh/Catzc.Base.Maps/types/MapsMinimapPlaces.cs,
      pwsh/Catzc.Base.Overlay/private/Get-LocalModuleViolation.ps1,
      docs/drs/design/tracks.md,
      docs/drs/principles/cats-and-catzc.md,
    ]
---

# Module namespace: the track declares it, the disk drops it

A pwsh module folder loses its `Catzc.` prefix on disk only: `pwsh/Catzc.Base.Git/` becomes `pwsh/Base.Git/`. The module keeps its full name
`Catzc.Base.Git` everywhere else: the generated manifest, `Get-Module`, `-Module` arguments, C# namespaces, the type accelerators and the
docs. The prefix moves from every folder name into one declaration on the `pwsh` track, the **namespace** of the track, so the full name is
folder name joined to the track's namespace. It depends on `plan-track-model.md` (the track's data model); its steps land after that plan's
member facts.

## Why full namespaces

A module's identity is `catzc://pwsh/Base.Git`: scheme = the product (catzc), authority = the track (pwsh), path = the module. Read that
way, `Catzc.` in the folder name repeats what the scheme already says, and the folder path already says the rest. The full name is still
what leaves the repository (a bundle, a gallery package, `Get-Module` in a consumer's session), where no track or folder is around to supply
the context, so it must be self-contained there. Inside the tree the context is always present, so the path carries only what it adds.

The rule this turns into: **a name is short where its container states the rest, and full wherever it travels** — one resolution of the long
form from the short one, declared once on the track (`ADR-AUTO-DEFAULT-ONERESOLUTIONORDER`), never a second spelling kept in step by hand
(`PDR-ONELIVE`). The same shape answers a future track: a `zsh` or `python` track declares its own namespace and its folders stay short.

## Open steps

1. [ ] **The move.** Each `pwsh/Catzc.X/` folder moves to `pwsh/X/` on disk (no git scripts; the user commits). Then the path references
       inside docs, plans, `relatives:` heads and tests are re-pointed by `link-fixer` and `Update-AdrCitation`, one file at a time.
       Module-name references (`Catzc.Base.Git` as a name, not a path) do not change. In the same pass the resolver (`Resolve-ModuleName`,
       `VariantTrack.FullNameOf`) drops its case for a folder that already spells its full name, which only bridges the unmoved tree
       (PDR-ONELIVE), with its tests. The two readers of the `Catzc.` prefix on a folder name change in the same pass:
       `MapsMinimapPlaces.DefaultDropPrefix` stops dropping it, and `Get-LocalModuleViolation.ps1` checks a local folder's resolved full
       name against the bundle. Check: `Test-Links` on the re-pointed files, `Resolve-ModuleName.Tests.ps1`, `MapsConfig.Tests.ps1` and
       `Assert-CatzcOverlay.Tests.ps1` green.
2. [ ] **Full import in a fresh session**, the last step (`importer-path-edits-break-every-session`): step 1 lands in one pass, then
       `. ./importer.ps1` in a new `pwsh` before anything else runs. Check: the import ends without error and `Get-Module Catzc.*` lists
       every module.

## Open question

- Simplify proposal from the session that wrote this plan: the plan-edit hook's reminder could name the required `## Open steps` heading, so
  a new plan passes `Test-Plans` the first time. Recommendation: add the heading name to the reminder text; it costs one line.

- The `.internal` modules (`Catzc.Internal.*.psm1`) are files, not module folders: they keep their full names, since the namespace is a fact
  of the track's module folders only. Recommendation: keep, since nothing in the path repeats there.
