---
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/prompt-k8s-kinds-2-implement.md"
    folder: plans
    name: prompt-k8s-kinds-2-implement
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-REPO-CONTRACT#3
---

# .claude/plans/prompt-k8s-kinds-2-implement.md

`Prompt 2 of 2 for plan-module-kinds-tracks (k8s kinds): implement the kind/role split and the per-track kinds; paste as the first message`

Rewritten 2026-10-16 on the Track-as-root premise (Q98, F2, S2, Q99). Run only after `.claude/plans/prompt-k8s-kinds-1-prepare.md` produced
its files **and** the Module kind (`.claude/plans/prompt-module-model-2-implement.md`) has landed, because the per-track kinds include
Module. Everything below the rule is the prompt.

---

You are implementing the kind/role change in `C:\projects\catzc` as coordinator. Track is the root entity; a kind is an object kind owned by
one track. Do the shared-file steps yourself and delegate scoped file sets to the `catzc-worker` sub-agent with a brief naming the files it
owns and the gates it runs. Nothing is committed by you.

## 1. Read first

1. `.claude/CLAUDE.md` in full (one file at a time, verify each, no script sweeps, time safeguard, no mutating git).
2. `docs/adr/index.md`; in full the ADRs of `.claude/plans/prompt-k8s-kinds-1-prepare.md` section 1, plus `ADR-AUTO-MODULE` (landed by the
   module-model prompt), `ADR-AUTO-TEST`, `ADR-PWSH-ONEFUNC`, `ADR-AUTO-DEPM`.
3. `.claude/plans/plan-module-kinds-tracks.md` (the corrected carried k8s section) and prompt 1's outputs: `out/k8s-kinds-consumers.md`,
   `k8s-kinds-vocabulary.md`, `k8s-kinds-config.md`, `k8s-kinds-head-schema.md`, `draft-adr-dsgn-track-kinds.md`. If any is missing, stop
   and tell the user. Copy them to your scratchpad.
4. `git status --short` before every file. `FileMetaConfig.cs` and `FileSelector.cs` (`Catzc.Base.QualityGates`) are shared with the
   file-head plan (class selectors): message before touching them, and re-check they are clean.

## 2. Decisions in force (the user's, 2026-10-16)

Track is the root; kinds belong to tracks and are unique per track; today's `kind` becomes `role`, `kind` becomes the object kind; a
config's kind is its C# type name; `Pipeline` and `Module` are catzc kinds (Module is defined by `ADR-AUTO-MODULE`); `Deployment` = template
x target; `Service` only with a `services` track; no `modules` track; the `.claude` kits stay in the holder track; the namespace is a later
follow-up. The head contract schema and sample stay hand-written (Q39). One living version: every head, reader, writer and test changes in
the same change; no alias key, no fallback.

## 3. Steps (the plan's k8s section 4; stop at the first red result that is yours)

1. Land the `ADR-DSGN-TRACK` extension, glossary entries and `adrs.yml` change from the draft; rebuild with `Build-AdrIndex`; run the ADR
   gates in the background.
2. Registry: extend `Catzc.Base.Globs/configs/file-kinds.yml` and `FileKindsConfig` (and its tests) with the `role` rename and the per-track
   object-kind map. C# edits need a fresh `pwsh`.
3. Resolver: `Get-FileKind` returns role and object kind; add any module edge to `dependencies.yml` in the same change.
4. Writers: change `Format-FileMeta` and the generated-head writers to write `role` and `kind` under the head's `immutable` part, passing
   the kind from `Get-FileKind`. Never hand-edit heads.
5. Regenerate the heads with the repo's own tools, then review a sample of diffs rather than all.
6. Contract: update `head.schema.json` and `head.sample.yml` under `contracts/catzc/0.0.0/` by hand with the new keys (it is also stale for
   `tracktype` and `vendor`); the key-set test guards them (`ADR-REPO-CONTRACT#3/#5`).
7. Verify with the per-file tests and the gates in the background; report only what you ran and saw. A red gate that is not yours is
   reported as not yours.

## 4. Done when

No head carries the old `kind` meaning; `Get-FileKind` is the one resolver; the ADR, glossary and contract agree with the code. Hand the
user the changed-file list and the gates actually run.
