---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets: [.editorconfig, .markdownlint.yml, .prettierrc.yml, catzc.sln, .gitattributes, pwsh/Catzc.Base.Docs]
---

# Generated files carry their provenance in the head, not the body

Generators put the information they need, and no more, in the file's head. The README generator today writes a "Generated from" blockquote
into the body, with a source link and an "edit the source" warning; that source link and signal belong in the head
(`catzc: immutable: role: readme` and the generated-from-source keys). The same holds for every generated, git-tracked file.

## Why its value is high

A body that carries generator noise is a second source of truth, and a tracked file that nothing marks as generated gets hand-edited.

## Decided (2026-10-19, from the user)

- The README generator, and every other generator, writes its provenance into the head only.
- `.editorconfig`, `.markdownlint.yml`, `.prettierrc.yml` and `catzc.sln` become generated files, like the attributes file and the generated
  READMEs, each with a head naming the template it was created from.
- Where a format has little or no room for a head (e.g. `dotnet-tools.json`), the same short string is used everywhere: "Do Not Edit, this
  file is generated". Every tracked, non-editable file carries it.

## Open steps

- [ ] Remove the `> Generated from ...` blockquote from the README generator's output and carry source and warning in the head (check:
      regenerate one README, its body starts at the H1).
- [ ] Fix the one warning string in one place (the head vocabulary) and have every generator read it (check: a test finds the same string in
      every generated head).
- [ ] Decide the template home and the head carrier per format: `.editorconfig` and `.markdownlint.yml`/`.prettierrc.yml` as comment lines,
      `catzc.sln` as `#` lines if the format tolerates them ahead of its header, strict JSON via a sidecar (check: the answers are recorded
      here).
- [ ] Generate `.editorconfig` first, as the pilot, then the other three one file at a time (check: the generated file equals today's
      content apart from the head).

## Refs

- The file head vocabulary and head policy (memory: file-head-vocabulary, head-policy-and-sync-file-meta); `Sync-FileMeta`,
  `Format-FileMeta`.
