# Prompt 2 of 2 for plan-module-kinds-tracks: implement the Module kind, ADR first; paste as the first message, after prompt 1

Rewritten 2026-10-16 on the Track-as-root premise (Q98, F2, S2). Run only after `.claude/plans/prompt-module-model-1-prepare.md` produced
its files and the user answered its open choices. Everything below the rule is the prompt.

---

You are implementing the Module kind in `C:\projects\catzc` as coordinator. Track is the root entity and Module is one of its kinds; the ADR
sits under `ADR-DSGN-TRACK`. Do the shared-file steps yourself and delegate scoped file sets to the `catzc-worker` sub-agent, with a brief
that names the files it owns and the gates it runs. Nothing is committed by you.

## 1. Read first

1. `.claude/CLAUDE.md` in full (one file at a time, verify each before the next, never a script sweep; time safeguard; no mutating git).
2. `docs/adr/index.md`, then in full the ADRs named in `.claude/plans/prompt-module-model-1-prepare.md` section 1, plus `ADR-AUTO-TEST`,
   `ADR-PWSH-ONEFUNC`, `ADR-PWSH-PARAM`, `ADR-PWSH-ENUM` and `ADR-REPO-CONTRACT`.
3. `.claude/plans/plan-module-kinds-tracks.md` (its "Decided, and why" and the corrected carried module-model section) and these prompt-1
   outputs: `out/module-model-callers.md`, `module-model-reading.md`, `module-model-slots.md`, `module-model-layering.md`,
   `module-model-protection-identity.md`, `draft-adr-auto-module.md`. If any is missing, stop and tell the user. Copy them and the plan into
   your scratchpad.
4. Run `git status --short` before touching any file. Other sessions edit concurrently; never edit a file another session has dirty without
   messaging first.

## 2. Decisions in force

The user's of 2026-10-16: Track is the root entity and Module a kind of the deployable tracks; `ADR-AUTO-MODULE` (domain `automation`) cites
and specialises `ADR-DSGN-TRACK`, `ADR-DSGN-TRACKTYPE` and `ADR-DSGN-MODTYPE`; registration is placement; one layout (config with sensible
defaults, default shipped on its C# type, under each language in `languages.yml`); two axes (language, engine; engines per track with a
per-module override); handlers per (track, language); the resolver is `Get-CatzcModule`; `LoadedModule` is one rule of the ADR; an unplaced
file is a finding; a track has one primary language by default; Go, Python and Bash stay test artifacts; one living version (rename and
delete in the same change, no shims); the order function is `Get-ModuleOrder`. New code takes the track from the one resolver and never
spells a track root, so the later rename to `pwsh` stays a data edit; every key it adds to a config type declares its default once on the
type. The prompt-1 answers stand.

## 3. Steps (plan section 5; stop at the first red result that is yours)

1. Fix the three `Get-ModuleProtectionIdentity` failures first if prompt 1 found them to be this work's (Q37); otherwise report them.
2. Land `ADR-AUTO-MODULE` from the draft: file, `adrs.yml` entry, glossary entry, `dora-explains.md` entry; rebuild with `Build-AdrIndex`.
   Add the rule to `ADR-DSGN-TRACK` that a track has one primary language by default. Run the ADR gates in the background.
3. Add the `layout:` slots per language to `languages.yml` with the default on the C# type; edit `FileLanguage.cs`/`LanguagesConfig.cs` with
   tests. A fresh `pwsh` process is needed after a C# edit.
4. Add `Module` and `LoadedModule`, the resolver `Get-CatzcModule` reading modules through `Get-Track`, and the `dependencies.yml` edges in
   the same change.
5. Repoint the layout duplicates onto the layout, one file at a time: `aspects` live patterns, `file-kinds.yml` module globs,
   `Get-PathModule`/`New-DynamicManifest`.
6. Rename `Get-ModuleTestOrder` to `Get-ModuleOrder` and move every caller.
7. Add the axes: `variants.yml` `tracks.<t>.engines`, `languages.yml` `build:`/`test:` handler ids, their C# types and tests.
8. Move callers onto `Module` file by file; delete `BaseModule`, `DiskModule`, `SessionModule`, `Get-BaseModule`, `Get-AutomationModules`.
   Resolve the `Test-ShippedTypes` flags on `TrackTypeEntry` and `VendorEntry` (Q88).
9. Add the L1 integrity test (every module resolves, every language has its handlers, the order is topological).
10. Only then extend to `infrastructure`.

For every file: edit, run that file's tests (and the gate that owns it) with the time safeguard, read the result, then the next file. Report
faithfully: never say a gate passed that you did not run; report a red gate that is not yours as not yours. The user runs all tests.

## 4. Done when

The ADR is registered and its gates are green; no old module type or function remains; the order, layout and axes each have one source; the
L1 integrity test passes. Tell `plan-config-defaults` and `plan-layers-vocabulary-rename-contracts` (their `waits_on` clears). Hand the user
a list of changed files and the gates actually run, then point to `.claude/plans/prompt-k8s-kinds-2-implement.md` as the sibling that
consumes the Module kind.
