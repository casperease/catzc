# .claude/plans/prompt-k8s-kinds-1-prepare.md

`Prompt 1 of 2 for .claude/plans/plan-module-kinds-tracks.md (carried section: plan-k8s-kinds): close the missing work, read-only, and draft the ADR-DSGN-TRACK extension — paste as the first message of a fresh session`

Rewritten 2026-10-16 on the Track-as-root premise (Q98, F2, S2, Q99): kinds belong to tracks, Module is one kind. Copy it and the plan into
your scratchpad first (another session wiped `out/` once). Everything below the rule is the prompt.

---

You are preparing the Kubernetes-style kind naming work in `C:\projects\catzc` (PowerShell 7.4+ module system, "cats"). This session is
**read-only on the code and docs trees**: it writes new files only under `out/`, and edits only the plan file this prompt names. Nothing is
committed; the user commits. Kubernetes is the source of vocabulary only: catzc's own ADRs decide every meaning, and you say so when a name
came from k8s.

## 1. Read first

1. `.claude/CLAUDE.md` in full (one-file-at-a-time editing, time safeguard with `timeout: 3000` per Bash call and `timeout <s>` prefix for
   background work, no mutating git).
2. `docs/adr/index.md`, then in full: `ADR-DSGN-TRACK` (`design/tracks.md`), `ADR-DSGN-TRACKTYPE` (`design/track-types.md`),
   `ADR-DSGN-MODTYPE` (`design/module-types.md`), `ADR-REPO-FILEMETA` (`repository/file-meta.md`), `ADR-REPO-CODEMETA`
   (`repository/code-file-meta.md`), `ADR-REPO-CONTRACT` (`repository/api-contracts.md`), `ADR-REPO-VOCAB`
   (`repository/controlled-vocabulary.md`), `ADR-AUTO-TYPES`, `ADR-AUTO-DEFAULT`, `ADR-PRIN-ONELIVE`. Never sweep the corpus.
3. `.claude/plans/plan-module-kinds-tracks.md`: read "Decided, and why" first (it overrides the carried drafts), then the carried sections
   "plan-k8s-kinds" (this plan) and "plan-module-model" (defines the Module kind; this plan consumes it and must not redefine it). Also the
   "Done, and why" section on tracks, track types and vendors: those are landed.

## 2. Decisions in force (the user's, 2026-10-16; do not reopen)

- **Track is the root entity** (Q98, F2). A kind is an object kind owned by one track, unique within it (Q99); Module is one of the kinds of
  the deployable tracks and is defined by `ADR-AUTO-MODULE` under `ADR-DSGN-TRACK`, not here.
- Tracks, track types and vendors are landed (`ADR-DSGN-TRACKTYPE`, `VariantTrack` with places, type and vendor). The head carries
  `tracktype` and `vendor` already. Build on them.
- The head key `kind` is renamed `role`; `kind` takes the k8s meaning (object kind), partitioned by track. No alias key, no fallback.
- A config's kind is its C# type name (`kind: FileKindsConfig`); `ConfigMap` is reserved for untyped key/value files.
- `Pipeline` and `Module` are catzc's own kinds (k8s has neither). `Deployment` = template x target. `Service` waits for a `services` track.
  There is no `modules` track. The `.claude` kits stay inside the holder track (Q35). The namespace is a follow-up (Q36).
- The head contract schema and sample stay hand-written, guarded by the key-set test (Q39); generated heads stay minimal (Q43).
- One living version: every head, reader, writer and test changes in the same change.

## 3. Do (each result goes to a file in `out/`, not to chat)

1. **Consumer inventory of the head `kind` key** (`out/k8s-kinds-consumers.md`): every reader and writer in `Format-FileMeta`,
   `FileMetaConfig`/`FileMetaKind`/`FileSelector`, `file-meta.yml` (its kinds and class selectors), `Get-FileKind`, `Get-PathFileKind`, the
   generated-head writers, `file-carriers.yml`, glob lists that name kinds, and tests; note that the key now sits under the head's
   `immutable` part. File, line, one-word role. State the size of the `kind` to `role` rename in files.
2. **Per-track vocabulary** (`out/k8s-kinds-vocabulary.md`): walk `file-kinds.yml` row by row and the `variants.yml` tracks, and assign each
   row to a track and a kind or a role; fill the table in the plan's k8s section 1 for `docs`, `.claude`, `contracts`, `go`/`python`/`bash`,
   `pipelines`, `github`, and the vendor tracks; list rows that fit no kind.
3. **Config kind derivability** (`out/k8s-kinds-config.md`): how `Get-Config` maps a config name to its C# type, and whether
   `kind: <TypeName>` can be derived with no new data. Name the function and line.
4. **Head schema** (`out/k8s-kinds-head-schema.md`): the head keys as they will be after the change (`role`, `kind`, `track`, `tracktype`,
   `vendor`, `module`, `generator`, the `edges`, …), their types, and which are place facts versus edges versus authored; the shape that
   would be published under `contracts/catzc/0.0.0/` (`ADR-REPO-CONTRACT#3/#5`), including the stale `head.schema.json` (it lacks
   `tracktype` and `vendor`).
5. **Draft the ADR extension** (`out/draft-adr-dsgn-track-kinds.md`): the new rules for `ADR-DSGN-TRACK` (a kind is an object kind of a
   track; unique per track; the role/kind split) plus the glossary entries (Module, Deployment, Pipeline, ConfigMap, role, reserved Service)
   and the `adrs.yml` change, following the index authoring conventions (present tense, no history, plain language). Not placed in `docs/`
   yet.
6. **Update the plan** `.claude/plans/plan-module-kinds-tracks.md`: replace the draft table in the carried k8s section with what you
   derived, mark each missing-work item of its section 4a closed or still open, and list corrections at the top of that section.

## 4. Done when

All files exist; section 4a of the carried k8s plan has no open item that reading could settle; the draft does not define Module; a
three-line summary names the choices only the user can make. Do not implement. Tell the user the next prompt is
`.claude/plans/prompt-k8s-kinds-2-implement.md`, which runs **after** the Module kind is implemented
(`.claude/plans/prompt-module-model-2-implement.md`).
