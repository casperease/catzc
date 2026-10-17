---
plan:
  status: active
  value: medium
  reviewed: 2026-10-17
  next: the pilot slide, sync-from-the-last-certified-commit, moved end to end
  targets: [docs/.assets/explanation, docs/explanation, docs/references, .claude/drawio]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-assets-beside-articles.md"
    folder: plans
    name: plan-assets-beside-articles
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
      - ADR-REPO-FOLDERS#5
---

# Diagram sidecars beside their articles; each docs tree owns its .assets

Today every diagram of an article lives apart from it: `docs/.assets/explanation/<domain>--<article>--<lens>.drawio.md` (the description),
its `.drawio.png`, and the chain, grid and tree minimap pages and PNGs in three sub-folders. The article reaches them by `../../.assets/...`
links. The target puts the description beside the article it describes and gives each docs tree its own `.assets`.

## Decided

- The description of a diagram goes beside its article: `docs/explanation/<domain>/<article>.drawio.md` next to `<article>.md`; a reference
  diagram's description goes beside `docs/references/automation/<module>.md` (the user's answers, 2026-10-17).
- The diagram PNGs and the chain, grid and tree minimaps move under the tree's own `.assets`: `docs/explanation/.assets/` and
  `docs/references/.assets/`; `docs/.assets/` keeps `azure` and `commits-quality`.
- The drawio kit is taught the new locations, so rebuilds keep working.
- Run as a plan first, then waves; a catzc-worker handles a bounded batch, one file at a time, Test-Links after each batch.

## Done

- Survey (2026-10-17): 149 descriptions in `docs/.assets/explanation`, 148 map to exactly one article by the middle name segment, no article
  has two; `glyphs` has no article. 12 descriptions sit under `docs/.assets/references/automation/<module>/`. 641 links in 159 docs files,
  plus 9 files outside docs (kit scripts, STYLE.md, two ADR or how-to pages, two test files), name the old paths.
- The explanation family is moved (2026-10-17): 147 slides plus the glyph library; each description sits beside its article, the PNGs and
  the chain, grid and tree minimaps under `docs/explanation/.assets`. Links, heads and checks are clean (Test-FileMeta, Test-Links apart
  from untracked targets, Test-GeneratedFiles).
- The reference family is moved (2026-10-17): 11 diagrams; each description sits in `docs/references/automation/<module>/`, the PNG and
  verification record under `docs/references/.assets/automation/<module>/`; a `reference-diagram` carrier class finds the description;
  ADR-REPO-FOLDERS#5 and the conventional-folders text name the new layout. Invoke-FileMetaEngine checks that a file exists before it looks
  for its sidecar, so an unstaged move raises no false finding.
- The kit works from the new locations (defaults, STYLE.md, migrate_dark.py): drawio_forward.py --minimaps on a moved slide ends ok; its
  pages differ from the committed ones only by link depth in a scratch folder and by a file another session added since. The engine carries
  a test for a file the working tree lost (2026-10-17).
- A sidecar carrier takes a `{stem}` token and one wildcard folder (`docs/explanation/*/{stem}.drawio.md`); the diagram and
  asset-description kinds come before the explanation and reference kinds; the generated-minimap marks in `.gitattributes` match any
  `.assets` under docs; the glyph library is listed in the carrier exclusions because it has no article.

## Open steps

- [ ] gallery_pdf.py `--assets` pairs a PNG with a description beside it, and the descriptions now sit beside the articles; teach it the
      lookup or retire the mode (check: the mode runs on docs/explanation/.assets and includes the descriptions, or is gone from STYLE.md).
- [x] The `FileCarrierResolver` shipped-registry test fails on its test-file exclusion line (the shipped powershell carrier lists no `tests`
      exclude); fix the test or the carrier, whichever the head rules for test files say (check: that test file passes). Corrected
      2026-10-17 (task023): the file passes as it stands, `[Invoke-TestFile] Passed` (`out/test-file/20261017-195921-41fa57`); the
      shipped-registry line asserts a test file carries a head, which the carrier with no exclude agrees with.
- [x] Remove `docs/.assets/explanation`, which holds only two gitignored PDFs now (check: the folder is gone). `docs/.assets/references` is
      already gone. Done 2026-10-17 (task023): the PDFs moved to `out/diagrams/`, the folder is gone, `git status` shows nothing under
      `docs/.assets`.
- [ ] Delete this plan when the steps are done (check: no file in .claude/plans names it).

## Refs

- `.claude/drawio/STYLE.md` (rebuilding a folder of slides), `.claude/drawio/drawio_forward.py`
- `docs/adr/repository/conventional-folders.md`
