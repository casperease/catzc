---
plan:
  status: active
  value: medium
  reviewed: 2026-10-17
  next: the pilot slide, sync-from-the-last-certified-commit, moved end to end
  targets:
    [
      docs/.assets/explanation,
      docs/.assets/references,
      docs/explanation,
      docs/references,
      .claude/drawio,
    ]
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

- Survey (2026-10-17): 149 descriptions in `docs/.assets/explanation`, 148 map to exactly one article by the middle name segment, no
  article has two; `glyphs` has no article. 12 descriptions sit under `docs/.assets/references/automation/<module>/`. 641 links in 159 docs
  files, plus 9 files outside docs (kit scripts, STYLE.md, two ADR or how-to pages, two test files), name the old paths.
- The kit reads the description from beside the PNG (drawio_forward.py derives the ADR codes from it; render.py and join.py default
  `--target docs/.assets/explanation`).

## Open steps

- [ ] Settle how the head of a diagram is found: `file-carriers.yml` gives the diagram class the carrier `sidecar: "{base}.md"`, the page
      beside the PNG, and `file-kinds.yml` matches diagrams and descriptions by `docs/.assets/**`. The description now sits in the article
      folder, so neither a `{base}` template nor those globs reach it, and `docs/explanation/**` would claim the descriptions and
      minimaps as explanations. The pilot shows it: Format-FileMeta did not rewrite the moved description's head (it still names the old
      path) and Test-FileMeta did not flag it. Needed: a sidecar resolver that finds `<article>.drawio.md` from the PNG name (middle name
      segment, domain folder), kinds for `docs/explanation/**/*.drawio.md` and the two `.assets` folders that beat the explanation kind,
      and a check that fails on a stale head (check: Test-FileMeta fails on the pilot description before the fix and passes after; the
      Get-FileKind and FileCarrierResolver tests carry the new cases).
- [ ] Pilot: the sync-from-the-last-certified-commit slide is moved (description beside the article, PNG and minimaps under
      `docs/explanation/.assets`) and its links are re-pointed; finish it once the step above lands: refresh the description's head
      (check: its head names `docs/explanation/design/sync-from-the-last-certified-commit.drawio.md`; Test-Links, Test-FileMeta and
      Test-GeneratedFiles clean apart from untracked-target findings).
- [ ] Teach the kit the new locations: the defaults of `minimaps/render.py` and `minimaps/join.py`, the drawio_forward.py text and the
      explanation lines of STYLE.md are changed (the ADR codes come from the model's labels and file name, so a moved description does not
      break the rebuild); left: the reference lines of STYLE.md, migrate_dark.py's path text, and gallery_pdf.py `--assets`, which pairs
      a PNG with a description beside it (check: drawio_forward.py on the pilot slide with --minimaps writes the moved files with no diff).
- [ ] Wave per domain folder, in this order: design, automation, flow, azure, repository, configuration, pipelines; each slide one move at
      a time (check: after each domain, Test-Links and Test-FileMeta clean and no file in that domain names `.assets/explanation`).
- [ ] The reference family: the 12 descriptions, PNGs and minimaps under `docs/.assets/references/automation/<module>/` to
      `docs/references/` (check: Test-Links clean on the module pages; `docs/.assets/references` is gone).
- [ ] Decide the `glyphs` slide, which has no article (check: a decided line here, then it moves or stays).
- [ ] Re-point the paths outside docs: `docs/adr/repository/conventional-folders.md`, `docs/how-to/getting-started/automation/add-a-doc-chapter.md`,
      `Get-FileKind.Tests.ps1`, `FileCarrierResolver.Tests.ps1`, and the file-kind and ignore patterns that match `docs/.assets/**`
      (check: grep for `docs/.assets/(explanation|references)` finds nothing outside the two kept folders, and the two test files pass).
- [ ] Remove the emptied `docs/.assets/explanation` and `docs/.assets/references` (check: both gone; Test-FileMeta clean).
- [ ] Delete this plan when the steps are done (check: no file in .claude/plans names it).

## Refs

- `.claude/drawio/STYLE.md` (rebuilding a folder of slides), `.claude/drawio/drawio_forward.py`
- `docs/adr/repository/conventional-folders.md`
