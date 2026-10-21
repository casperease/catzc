---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: fix
  targets: [pwsh/Catzc.Base.QualityGates/configs/file-meta.yml, pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1]
---

# Docs edge as a file-relative link

A navigation head's `docs` edge links its comment page by the repository-relative path, `"[X.cs.md](docs/references/...)"`. That target
resolves from the repository root, so it is broken in GitHub's code view and in an editor, both of which resolve a link from the file's own
folder. The head is written by a tool that knows both paths, so it can write a proper `../`-relative target.

## Why its value is medium

The `docs` edge exists so a reader can step from a code file to its page in one click
([ADR-REPO-FILEMETA-FEWLINKS](../../docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-fewlinks)). Today that click fails in every code
file that has a head.

## Decided (the user, 2026-10-21)

- The `docs` link target is relative to the file that carries the head, e.g. from
  `pwsh/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs`:
  `"[AnalyzerAdrMapConfig.cs.md](../../../docs/references/pwsh/catzc-base-quality-gates/types/AnalyzerAdrMapConfig.cs.md)"`. This replaces
  the repository-relative form; one living version, no fallback for the old form.

## Open questions

- Should `test` and `code`, which are plain paths and not links, stay repository-relative or move to the same file-relative form?
  Recommendation: keep them repository-relative. They are not clickable as plain YAML values, and a repository path is what a dev greps for.

## Open steps

- [ ] Run `Test-Links -Path pwsh/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs` on today's repository-relative edge, which is broken
      from the file's folder. If it reports nothing, `Test-Links` does not read code heads: make it resolve a head's `docs` target from the
      file's folder, with a Pester case for a broken edge. Check: the run reports today's edge as broken, and reports nothing after the
      re-imprint.
- [ ] `file-meta.yml` `relative-edges`: add a `{relpath}` token (the found path made relative to the head's file, `/` separators) and set
      `docs` to `link: "[{leaf}]({relpath})"`; reword the kind's comment line. `{path}` stays for a link that wants the repository path.
      Check: `Test-FileMetaProcessors` passes.
- [ ] `Get-RelativeEdgesFileMetaFact.ps1`: resolve `{relpath}` from `$Path` and the found path (`[System.IO.Path]::GetRelativePath` on the
      two parents, `\` to `/`). Check: its test file gets a `{relpath}` case for a file two levels below a module and one at the module
      root, and passes.
- [ ] ADR text: `ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY` in `docs/adr/repository/code-file-meta.md` says "by its repository-relative path"
      and its example head shows `docs/references/...`; change both to the file-relative form (the example's file is
      `pwsh/Catzc.Base.Languages/types/FileLanguage.cs`, so `../../../docs/...`). Check the same wording in `file-meta.md` FEWLINKS. Check:
      `Test-Links` on both pages.
- [ ] Re-imprint the heads with `Sync-FileMeta` (one-shot). Peer-dirty code files are skipped and picked up on the next sync. Check:
      `Test-FileMeta -Path` on `AnalyzerAdrMapConfig.cs` and `FileLanguage.cs` shows the `../`-relative `docs` edge, and the edge opens the
      page from the file's folder.
