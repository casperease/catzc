# out/prompt-k8s-kinds-2-implement.md

`Prompt 2 of 2 for out/plan-k8s-kinds.md: implement the kind/role split and the per-track kinds — paste as the first message of a fresh session`

Written 2026-10-16. Run only after `out/prompt-k8s-kinds-1-prepare.md` produced its files **and** the Module model
(`out/prompt-module-model-2-implement.md`) has landed, because kinds are defined against `Module`. Everything below the rule is the prompt.

---

You are implementing the kind/role change in `C:\projects\catzc` as coordinator. Do the shared-file steps yourself and delegate scoped
file sets to the `catzc-worker` sub-agent with a brief naming the files it owns and the gates it runs. Nothing is committed by you.

## 1. Read first

1. `.claude/CLAUDE.md` in full (one file at a time, verify each, no script sweeps, time safeguard, no mutating git).
2. `docs/adr/index.md`; in full the ADRs of `out/prompt-k8s-kinds-1-prepare.md` section 1, plus `ADR-AUTO-TEST`, `ADR-PWSH-ONEFUNC`,
   `ADR-AUTO-DEPM`.
3. `out/plan-k8s-kinds.md` (corrected by prompt 1) and its outputs: `out/k8s-kinds-consumers.md`, `k8s-kinds-vocabulary.md`,
   `k8s-kinds-config.md`, `k8s-kinds-head-schema.md`, `draft-adr-dsgn-track-kinds.md`; also the landed `ADR-AUTO-MODULE`. If any is
   missing, stop and tell the user. Copy them to your scratchpad.
4. `git status --short` before every file. `FileMetaConfig.cs` and `FileSelector.cs` (`Catzc.Base.QualityGates`) had another session's
   uncommitted edits on 2026-10-16: message before touching them, and re-check they are clean.

## 2. Decisions in force (the user's, 2026-10-16)

Kinds are tracks, unique per track; today's `kind` becomes `role`, `kind` becomes the object kind; a config's kind is its C# type name;
`Pipeline` and `Module` are catzc kinds; `Deployment` = template x target; `Service` only with a `services` track; no `modules` track;
Namespace later. One living version: every head, reader, writer and test changes in the same change; no alias key, no fallback.

## 3. Steps (plan section 4; stop at the first red result that is yours)

1. Land the `ADR-DSGN-TRACK` extension, glossary entries and `adrs.yml` change from the draft; rebuild with `Build-AdrIndex`; run the ADR
   gates in the background.
2. Registry: extend `Catzc.Base.Globs/configs/file-kinds.yml` and `FileKindsConfig` (and its tests) with the `role` rename and the
   per-track object-kind map. C# edits need a fresh `pwsh`.
3. Resolver: `Get-FileKind` returns role and object kind; add any module edge to `dependencies.yml` in the same change.
4. Writers: change `Format-FileMeta` and the generated-head writers to write `role` and `kind`, passing the kind from `Get-FileKind` (this
   also closes the `generated-from-source` open item in memory `file-head-vocabulary`). Never hand-edit heads.
5. Regenerate the heads with the repo's own tools (`out/regen-generators.ps1`), then review a sample of diffs rather than all.
6. Contract: publish the registry and head schema under `contracts/catzc/0.0.0/` before any release (`ADR-REPO-CONTRACT#3/#5`).
7. Verify with the per-file tests and the gates (`out/run-gates.ps1`, `out/run-generator-tests.ps1`) in the background; report only what
   you ran and saw. A red gate that is not yours is reported as not yours.

## 4. Done when

No head carries the old `kind` meaning; `Get-FileKind` is the one resolver; the ADR, glossary and contract agree with the code. Hand the user
the changed-file list and the gates actually run.
