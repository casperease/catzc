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
      PSScriptAnalyzerSettings.psd1,
      .vscode/markdown-preview-dark.css,
      docs/adr/repository/generated-root-configs.md,
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
- `dotnet-tools.json` keeps the `json` carrier of `file-carriers.yml`, the ignored `"//"` property: the dotnet manifest parser rejects `//`
  line comments, as the file's own marker at `dotnet-tools.json:2` records, so the `jsonc` carrier is out (settled 2026-10-19 from the
  tree).
- The carriers exist for every file in scope (`pwsh/Catzc.Base.Languages/configs/file-carriers.yml`): `.editorconfig` is a `dotfile` with a
  `#` comment head, the two `.yml` files are `yaml` with `#`, `catzc.sln` is `solution` with `#` after a two-line preamble, and
  `dotnet-tools.json` is `json` with the property. No carrier is added.

## Done

- `Test-Markdownlint` lints the generated READMEs, `glossary.md` and `index.md` (their exclusions are gone) and excludes `.venv` and
  `.pytest_cache`; `Get-ReadmeContent` re-wraps the blocks that pass 140 columns after link rebasing (`Format-LongMarkdownLines`).

## Open steps

- [ ] Declare the one warning string once, as a default on the config type that `Format-GeneratedFileHead` (`pwsh/Catzc.Base.Languages`)
      reads, since no shared constant exists today and every generator writes its own banner (check: a test finds the same string in every
      head `Format-GeneratedFileHead` writes; the `GENERATED FILE ... do not edit.` fixture strings in the CodeMeta, Languages and
      QualityGates tests read the declared string).
- [ ] `pwsh/Catzc.Base.Docs/private/Get-ReadmeContent.ps1`: drop the banner at lines 17 to 30 (the `> Generated from ... edit the source;`
      blockquote after the H1) and carry the source path and the warning in the head beside the `catzc: immutable: role:` keys it already
      writes (check: regenerate one README, its body starts at the H1; `Build-Readme.Tests.ps1` lines 49, 76 and 92 assert the head, not the
      banner; `Format-LongMarkdownLines` no longer wraps a banner).
- [ ] The other tracked generated files read the same string in their own carrier, one generator at a time: `importer-commands.sh` through
      `New-CatsCommandLookup.ps1:13`, and the configuration files `Set-BicepTemplateConfiguration.ps1:80` writes (check: each generator's
      test finds the string; the build outputs of `Catzc.Internal.Builder.psm1` and `Install-Catzc.ps1` are untracked and out of scope).
- [ ] `pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1`: a copy entry with a carrier head passes when the root file equals the template
      plus the head and fails on any other difference; today a hard link passes only on byte-equal text (lines 72 to 76) and a non-link
      entry must be no link at all (lines 81 to 83), so neither branch accepts a headed copy (check: `Test-RootConfigFiles.Tests.ps1` gains
      the headed-copy fixture beside the `widget.json` hard-link fixtures; `Invoke-TestFile` on it passes).
- [ ] Switch `.editorconfig` from `copyAsLink` to a copy entry with its `dotfile` carrier, as the pilot (`rootconfig.yml` lines 87 to 90;
      the root file and the template are one inode today, link count 2) (check: the root file equals the template plus the head; the
      importer rewrites it idempotently; the editor still reads it; Test-RootConfigFiles clean).
- [ ] Switch `.markdownlint.yml`, `.prettierrc.yml`, `catzc.sln` and `dotnet-tools.json` the same way, one file at a time; `catzc.sln` first
      loses its `# MANAGED ROOT FILE` line at line 3, inside the format header, and `dotnet-tools.json` moves its marker text out of the
      `"//"` property into the one string (check: each file's own tool reads the copy; Test-RootConfigFiles clean).
- [ ] State the decisions as rules in the same change as the pilot: `docs/adr/repository/generated-root-configs.md` says a managed root file
      is a copy whose head names its template and carries the one string, never a hard link to the template; the head policy
      (`docs/adr/repository/file-meta.md`) says generator provenance lives in the head and the body is the content alone
      (ADR-REPO-PLANS-DECISIONSBECOMERULES) (check: Test-Adr clean; the index lists the new codes; `copyAsLink` is no longer a word the ADR
      uses).
- [ ] Switch `PSScriptAnalyzerSettings.psd1` (source `pwsh/.internal/assets/`, `rootconfig.yml` lines 2 to 5) and
      `.vscode/markdown-preview-dark.css` (lines 83 to 86) the same way, one file at a time, so no `copyAsLink` entry remains (the user,
      2026-10-19: in scope after the pilot) (check: PSScriptAnalyzer and the markdown preview read the copies; Test-RootConfigFiles clean;
      `grep copyAsLink rootconfig.yml` finds nothing).

## Refs

- The file head vocabulary and head policy (memory: file-head-vocabulary, head-policy-and-sync-file-meta); `Sync-FileMeta`,
  `Format-FileMeta`; docs/adr/repository/generated-root-configs.md; `pwsh/Catzc.Base.QualityGates/configs/file-meta.yml` declares the head
  keys, and `immutable` is not among them yet (the README generator writes it).
- `PSScriptAnalyzerSettings.psd1` and `.vscode/markdown-preview-dark.css` are the two other `copyAsLink` entries, the last step above.
