# .claude/plans/prompt-module-model-2-implement.md

`Prompt 2 of 2 for .claude/plans/plan-module-kinds-tracks.md (carried section: plan-module-model): implement the Module model, ADR first — paste as the first message of a fresh session, after prompt 1 has run`

Written 2026-10-16. Run only after `.claude/plans/prompt-module-model-1-prepare.md` produced its six files and the user answered its open choices.
Everything below the rule is the prompt.

---

You are implementing the Module model in `C:\projects\catzc` as coordinator. Do the shared-file steps yourself and delegate scoped file sets
to the `catzc-worker` sub-agent, with a brief that names the files it owns and the gates it runs. Nothing is committed by you.

## 1. Read first

1. `.claude/CLAUDE.md` in full (one file at a time, verify each before the next, never a script sweep; time safeguard; no mutating git).
2. `docs/adr/index.md`, then in full the ADRs named in `.claude/plans/prompt-module-model-1-prepare.md` section 1, plus `ADR-AUTO-TEST`,
   `ADR-PWSH-ONEFUNC`, `ADR-PWSH-PARAM`, `ADR-PWSH-ENUM` and `ADR-REPO-CONTRACT`.
3. `.claude/plans/plan-module-kinds-tracks.md (carried section: plan-module-model)` (corrected by prompt 1) and these prompt-1 outputs: `out/module-model-callers.md`,
   `module-model-reading.md`, `module-model-slots.md`, `module-model-layering.md`, `draft-adr-auto-module.md`. If any is missing, stop and
   tell the user. Copy them and the plan into your scratchpad.
4. Run `git status --short` before touching any file. Other sessions edit concurrently; never edit a file another session has dirty
   without messaging first (as of 2026-10-16, `FileMetaConfig.cs` and `FileSelector.cs` in `Catzc.Base.QualityGates` are dirty).

## 2. Decisions in force

The user's of 2026-10-16: registration is placement; one layout (config with sensible defaults, default shipped on its C# type); two axes
(language, engine); handlers per (track, language); Module is a kind inside tracks; Go/Python/Bash stay test artifacts; one living version
(rename and delete in the same change, no shims); order function `Get-ModuleOrder`. The prompt-1 answers to Q-A to Q-G stand.

## 3. Steps (plan section 5; stop at the first red result that is yours)

1. Land `ADR-AUTO-MODULE` from the draft: file, `adrs.yml` entry, glossary entry, `dora-explains.md` entry; rebuild with `Build-AdrIndex`.
   Run the ADR gates in the background.
2. Add the `layout:` slots per language to `languages.yml` with the default on the C# type; edit `FileLanguage.cs`/`LanguagesConfig.cs`
   with tests. A fresh `pwsh` process is needed after a C# edit.
3. Add `Module` and `LoadedModule`, the resolver (name from prompt 1), and the `dependencies.yml` edges in the same change.
4. Repoint the three layout duplicates onto the layout, one file at a time: `aspects` live patterns, `file-kinds.yml` module globs,
   `Get-PathModule`/`New-DynamicManifest`.
5. Rename `Get-ModuleTestOrder` to `Get-ModuleOrder` and move every caller.
6. Add the axes: `variants.yml` `tracks.<t>.engines`, `languages.yml` `build:`/`test:` handler ids, their C# types and tests.
7. Move callers onto `Module` file by file; delete `BaseModule`, `DiskModule`, `SessionModule`, `Get-BaseModule`.
8. Add the L1 integrity test (every module resolves, every language has its handlers, the order is topological).
9. Only then extend to `infrastructure`.

For every file: edit, run that file's tests (and the gate that owns it) with the time safeguard, read the result, then the next file.
Report faithfully: never say a gate passed that you did not run; report a red gate that is not yours as not yours.

## 4. Done when

The ADR is registered and its gates are green; no old module type or function remains; the order, layout and axes each have one source;
the L1 integrity test passes. Hand the user a list of changed files and the gates actually run, then point to
`.claude/plans/prompt-k8s-kinds-2-implement.md` as the sibling that consumes `Module`.
