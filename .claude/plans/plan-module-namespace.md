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
(`PDR-ONELIVE`). Every modules track declares its own namespace (pwsh, js, python, bash, go), and its folders stay short.

## Open steps

1. [ ] **Phase 1, the moves (the user runs it).** `out/ns5/Rename-PwshModuleFolders.ps1` `git mv`s every module folder of the five modules
       tracks off its prefix: pwsh 53, js 7, python 2, bash 3, go 1. It then makes the 25 pwsh case renames, and writes `out/ns5/moves.csv`
       before its first move. It edits no content. Check: `-WhatIf` lists 66 moves and 25 case renames, and after the run `git status` shows
       only renames.
2. [ ] **Each modules track declares its own namespace.** `variants.yml` gives js, python, bash and go `namespace: catzc` beside pwsh's
       `Catzc`. The resolver (`Resolve-ModuleName`, `VariantTrack.FullNameIn`) joins the namespace in each track's language form (`.` for
       pwsh, `-` for js and bash, `_` for python, none for go), declared on the language, not in code. Check: `Resolve-ModuleName.Tests.ps1`
       covers one widget per join form, and `VariantsConfig.Tests.ps1` passes.
3. [ ] **Phase 2, the repair**, in the order and with the checks of `out/ns5/after-move.md`, read from `moves.csv`: hook projects, import
       path, the resolver dropping its bridge with the minimap prefix and the overlay check, module configs naming modules rather than
       paths, the path-rewrite map, generated root configs, pipelines, then the js, python, go and bash tracks (imports, package names,
       go.mod, the extension folders), and finally comments and heads. Docs references the map does not reach are left for a later
       link-fixer pass. Check: each step's own check, and a fresh import listing the same 56 full names after each import-path step.
4. [ ] **The no-namespace-on-disk gate.** No folder or file under a modules track starts with the track's namespace in its join form, apart
       from the global names the track declares exempt (`Catzc.Internal.*.psm1`, `Catzc.Types.*`, the analyzer modules, `contracts/catzc/`).
       Check: an L0 test with widget fixtures and a clean L1 run on the real tree.
5. [ ] **Full import in a fresh session**, the last step (`importer-path-edits-break-every-session`): `. ./importer.ps1` in a new `pwsh`
       before anything else runs, then `Test-ManualTestPlan`, `Test-GeneratedFiles` and `Test-Links`. Check: the import ends without error
       and `Get-Module Catzc.*` lists the same 56 full names.

## Open question

- Simplify proposal from the session that wrote this plan: the plan-edit hook's reminder could name the required `## Open steps` heading, so
  a new plan passes `Test-Plans` the first time. Recommendation: add the heading name to the reminder text; it costs one line.

- The `.internal` modules (`Catzc.Internal.*.psm1`) are files, not module folders: they keep their full names, since the namespace is a fact
  of the track's module folders only. Recommendation: keep, since nothing in the path repeats there.
