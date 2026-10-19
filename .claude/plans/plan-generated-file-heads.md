---
plan:
  status: active
  value: high
  reviewed: 2026-10-19
  targets:
    [
      pwsh/Catzc.Base.RootConfig/configs/rootconfig.yml,
      pwsh/Catzc.Base.RootConfig/assets/root,
      pwsh/Catzc.Base.Docs/private/Get-ReadmeContent.ps1,
      .editorconfig,
      .markdownlint.yml,
      .prettierrc.yml,
      catzc.sln,
      dotnet-tools.json,
    ]
---

# Generated files carry their provenance in the head, not the body

Generators put the information they need, and no more, in the file's head. The README generator today writes a "Generated from" blockquote
into the body, with a source link and an "edit the source" warning; that source link and signal belong in the head
(`catzc: immutable: role: readme` and the generated-from-source keys). The same holds for every generated, git-tracked file.

## Why its value is high

A body that carries generator noise is a second source of truth, and a tracked file that nothing marks as generated gets hand-edited.

## Decided (2026-10-19, from the user)

- The README generator, and every other generator, writes its provenance into the head only.
- `.editorconfig`, `.markdownlint.yml`, `.prettierrc.yml`, `catzc.sln` and `dotnet-tools.json` are `copyAsLink` entries in `rootconfig.yml`
  today: the root file and its source in `pwsh/Catzc.Base.RootConfig/assets/root` are one hard link, so a head cannot be added without
  landing in the template too. They become copy entries with a carrier head: `assets/root` stays the pure authored template, the root file
  is a generated copy whose head names the template it was created from.
- The template home is `pwsh/Catzc.Base.RootConfig/assets/root` (it already is); no new home.
- One short string, "Do Not Edit, this file is generated", goes in the head of every tracked, non-editable file, in the file's own comment
  syntax.
- `dotnet-tools.json` uses the existing `jsonc` carrier if the dotnet tool manifest reader tolerates comments.

## Done

- `Test-Markdownlint` lints the generated READMEs, `glossary.md` and `index.md` (their exclusions are gone) and excludes `.venv` and
  `.pytest_cache`; `Get-ReadmeContent` re-wraps the blocks that pass 140 columns after link rebasing (`Format-LongMarkdownLines`).

## Open steps

- [ ] Remove the "Generated from" blockquote from the README generator's output and carry source and warning in the head (check: regenerate
      one README, its body starts at the H1; `Format-LongMarkdownLines` no longer wraps the banner).
- [ ] Fix the one warning string in one place (the head vocabulary) and have every generator read it (check: a test finds the same string in
      every generated head).
- [ ] Verify that `dotnet` reads a `dotnet-tools.json` that has comments (check: `dotnet tool restore` succeeds on a copy with a `//` head);
      if it does not, reopen the carrier question with the user.
- [ ] Switch `.editorconfig` from `copyAsLink` to a copy entry with its comment carrier, as the pilot (check: the root file equals the
      template plus the head; the importer rewrites it idempotently; the editor still reads it).
- [ ] Switch `.markdownlint.yml`, `.prettierrc.yml`, `catzc.sln` and `dotnet-tools.json` the same way, one file at a time; `catzc.sln` first
      loses its `# MANAGED ROOT FILE` line from inside the format header (check: each file's own tool reads the copy; Test-RootConfigFiles
      clean).

## Refs

- The file head vocabulary and head policy (memory: file-head-vocabulary, head-policy-and-sync-file-meta); `Sync-FileMeta`,
  `Format-FileMeta`; docs/adr/repository/generated-root-configs.md.
