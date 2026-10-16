# out/prompt-k8s-kinds-1-prepare.md

`Prompt 1 of 2 for out/plan-k8s-kinds.md: close the missing work, read-only, and draft the ADR extension — paste as the first message of a fresh session`

Written 2026-10-16. Copy it and both plans into your scratchpad first (another session wiped `out/` once). Everything below the rule is
the prompt.

---

You are preparing the Kubernetes-style kind naming work in `C:\projects\catzc` (PowerShell 7.4+ module system, "cats"). This session is
**read-only on the code and docs trees**; it writes only under `out/`. Nothing is committed; the user commits. Kubernetes is the source of
vocabulary only: catzc's own ADRs decide every meaning, and you say so when a name came from k8s.

## 1. Read first

1. `.claude/CLAUDE.md` in full (one-file-at-a-time editing, time safeguard with `timeout: 3000` per Bash call and `timeout <s>` prefix for
   background work, no mutating git, plans in `out/plan-*.md`).
2. `docs/adr/index.md`, then in full: `ADR-DSGN-TRACK` (`design/tracks.md`), `ADR-REPO-FILEMETA` (`repository/file-meta.md`),
   `ADR-REPO-CODEMETA` (`repository/code-file-meta.md`), `ADR-REPO-CONTRACT` (`repository/api-contracts.md`), `ADR-REPO-VOCAB`
   (`repository/controlled-vocabulary.md`), `ADR-AUTO-TYPES`, `ADR-AUTO-DEFAULT`, `ADR-PRIN-ONELIVE`. Never sweep the corpus.
3. `out/plan-k8s-kinds.md` (this plan) and `out/plan-module-model.md` (defines `Module`; this plan consumes it and must not redefine it).

## 2. Decisions in force (the user's, 2026-10-16; do not reopen)

- Kinds are tracks: a kind belongs to the vocabulary of one track; kind ids are unique per track.
- The current head key `kind` is renamed `role`; `kind` takes the k8s meaning (object kind).
- A config's kind is its C# type name (`kind: FileKindsConfig`); `ConfigMap` is reserved for untyped key/value files.
- `Pipeline` and `Module` are catzc's own kinds (k8s has neither). `Deployment` = template x target. `Service` waits for a `services` track.
- `Module` is a kind inside tracks (no `modules` track), generic across tracks. Namespace is a follow-up.

## 3. Do (each result goes to a file in `out/`, not to chat)

1. **Consumer inventory of the head `kind` key** (`out/k8s-kinds-consumers.md`): every reader and writer in `Format-FileMeta`,
   `FileMetaConfig`/`FileMetaKind`/`FileSelector`, `file-meta.yml`, `Get-FileKind`, `Get-PathFileKind`, the generated-head writers (the
   `generated-from-source`/`tracked-generated-from-source` values), `file-carriers.yml`, glob lists that name kinds, and tests. File, line,
   one-word role. State the size of the `kind` to `role` rename in files.
2. **Per-track vocabulary** (`out/k8s-kinds-vocabulary.md`): walk `file-kinds.yml` row by row and `variants.yml` tracks, and assign each
   row to a track and a kind or a role; fill the table in plan section 1 for `docs`, `.claude`, `contracts`, `go`/`python`/`bash`,
   `pipelines`, `.github`; list rows that fit no kind.
3. **Config kind derivability** (`out/k8s-kinds-config.md`): how `Get-Config` maps a config name to its C# type, and whether `kind:
   <TypeName>` can be derived with no new data. Name the function and line.
4. **Head schema** (`out/k8s-kinds-head-schema.md`): the head keys as they will be after the change (`role`, `kind`, `track`, `module`,
   `generator`, `relatives`, `adrs`, …), their types, and which are derived versus carried; the shape that would be published under
   `contracts/catzc/0.0.0/` (`ADR-REPO-CONTRACT#3/#5`).
5. **Draft the ADR extension** (`out/draft-adr-dsgn-track-kinds.md`): the new rules for `ADR-DSGN-TRACK` (a kind is an object kind of a
   track; unique per track; the role/kind split) plus the glossary entries (Module, Deployment, Pipeline, ConfigMap, role, reserved
   Service) and the `adrs.yml` change, following the index authoring conventions (present tense, no history, plain language). Not placed in
   `docs/` yet.
6. **Update the plan** `out/plan-k8s-kinds.md`: replace the draft table with what you derived, mark each missing-work item (section 4a)
   closed or still open, and list corrections at the top.

## 4. Done when

All files exist; section 4a of the plan has no open item that reading could settle; a three-line summary names the choices only the user can
make. Do not implement. Tell the user the next prompt is `out/prompt-k8s-kinds-2-implement.md`, which runs **after** the Module model is
implemented (`out/prompt-module-model-2-implement.md`).
