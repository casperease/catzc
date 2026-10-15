# Plan: make docs/.assets/explanation reproducible from committed source, and fix the AUTO / automation axis

Written 2026-10-15. Two problems, one plan: (A) the explanation slides, descriptions and minimaps are committed as outputs, but the source
and tooling that made them live only in gitignored `out/`; (B) the value-chain map shows "automation" on both axes.

## What is true today (verified on disk)

- `docs/.assets/explanation/` holds all 88 slides: each has a `.drawio.png`, a `.drawio.md` and three minimaps (`.grid/.tree/.chain.png`),
  each minimap with its sister `.md`, plus the glyph sheet. That's 706 tracked files, already committed (latest commit touching them:
  b8d94eac). `docs/explanation/` holds the 88 articles and 7 indexes. All 451 markdown files pass the six per-file checks; markdownlint,
  spelling and Test-Glossary pass over the tree.
- **Not committed, so the assets cannot be rebuilt from the repository:**
  - the 88 slide XML sources: `out/diagrams/wave-7/<subfolder>/<stem>.xml`, two of them still under the old stems;
  - the 88 verify files (`<stem>.verify.md`, claim → `file:line` → status);
  - the wave scripts: `_build_slide.sh`, `_check_docs.ps1`, `_check_all.sh`, `_lint_spell_globs.ps1`, `_sidebar_gen.py`, `_gallery.py`,
    `_rebuild_pwsh.sh`, and the makers' helpers;
  - the minimap slide list and its generator (`out/diagrams/k4/make-slides.py`, `slides.docs.json`);
  - the highlight data (`out/minimaps*`) and the facts file (`out/diagrams/k4-sidebar-facts.json`). Only `.claude/drawio/` (drawio_png.py,
    glyphs.xml, STYLE.md, gallery_pdf.py, minimaps/{highlights.ps1,render.py,describe.py,join.py}) is checked in.
- Several out/ scripts are stale: `_rebuild_all.py` and `_fanin_check.py` expect the retired `minimap-stack` cell; `_build_slide.sh` embeds
  the retired minimaps.

## B. The AUTO / automation axis (do this first: it changes every value-chain minimap)

**The user's rule:** AUTO is an ADR row of the value-chain stack (the automation ADR domain). Automation itself, like git, is a
cross-cutting layer underneath every other concern. It is not a step along delivery, so it must never appear as a concern column ("not in
the top at all").

**Today:** ADR-DSGN-TRACK#15 makes `automation` the first of six value-chain concerns (LOCAL on the minimap):

- five ADR domains (design, automation, pwsh, configuration, repository) default to `[automation]` only;
- about a dozen ADRs carry it in their own `concern:` (configure-not-program, thin-platforms, run-modes, module-aspects,
  pipeline-runner-pattern, pipeline-detection, durable-sha-globs, internal-asset-dependencies, native-csharp-types, hosting-csharp-types,
  platform-engineering, version-control, code-maintainability, teams-empowered-to-choose-tools);
- the thesis, principles, process and research domains list all six.

**Change:**

1. **ADR-DSGN-TRACK#15:** five value-chain concerns: `build`, `quality-control`, `release`, `deploy`, `access`. Add one rule, the
   **cross-cutting layer**: automation (loading modules, reading configuration, selecting files) and git (the repository and its history)
   underlie every concern, so an ADR that acts there is marked cross-cutting, not given a column. ADR-DSGN-TRACK#16 (the map) and #12 (lit
   cell) follow. Present tense, one living version (ADR-PRIN-ONELIVE): no alias for the old concern.
2. **`adrs.yml`:** remove `automation` from every `concern:` list. A domain or ADR whose only concern was automation becomes cross-cutting
   (a `cross_cutting: true` key, or `concern: []` with a declared meaning; decision B2). Keep its other concerns. `AdrsConfig.cs` validation
   changes with it: an ADR resolves to one or more concerns **or** is cross-cutting, never neither.
3. **How the map draws cross-cutting (decision B1):** recommended, a thin full-width band under the five columns of each stack row: an ADR
   that is cross-cutting lights its row's band, so AUTO, DSGN, PRIN… can each show "underneath everything" without a column header.
   Alternative: one shared band under the whole grid, lit with the row label.
4. **Code and words:** Catzc.Base.Maps value-chain model and `maps.yml` labels; `.claude/drawio/minimaps/{render,describe}.py`;
   `terminology.yml` (drop LOCAL, add the cross-cutting term), the glossary source and its defining rule, the tests (L0 config shapes, the
   L1 integrity of `adrs.yml`, Test-ValueChainMap).
5. **Words in docs:** the explanation index ("How to read the diagrams"), the minimap sister files, the slide descriptions' Sidebar
   sections, and any article that says "automation concern". The world-map grid's `automation` row is the automation _track_
   (ADR-DSGN-TRACK#1); it is not affected.

Owner: the session that owns ADR-DSGN-TRACK#9–#16 and Catzc.Base.Maps (catzc-f1 is no longer running; confirm who owns them before editing
`tracks.md`, `adrs.yml` or the Maps module).

## A. Make the explanation assets reproducible from committed source

1. **One source per slide: the `.drawio.png` itself.** A `.drawio.png` embeds its draw.io model; draw.io opens and edits it, and
   `drawio_png.py` already decodes it. So the out/ XML is a duplicate, and committing it would be a second living version. The tooling
   reads, edits and re-embeds the model in the PNG; out/ XML becomes scratch only. (Decision A1: confirm. The alternative is committing
   `<stem>.drawio.xml` beside each PNG.)
2. **The slide list comes from `docs/`, not from out/ manifests.** The slides are `docs/.assets/explanation/*.drawio.png` (minus `glyphs`).
   A slide's ADR codes are the ones its embedded Supports cell draws, and its lens is the stem's last part. This retires
   `fan-out/_manifest.json`, `_slugs.json` and `k4/make-slides.py` as inputs. `highlights.ps1`, `render.py` and `join.py` take
   `--from docs/.assets/explanation` and derive the list themselves.
3. **The Sidebar section is generated, not pasted.** `describe.py` writes each `.drawio.md`'s `## Sidebar` section and its `Sidebar:`
   overview line from the same data the minimaps are drawn from, between marker comments (`<!-- generated: sidebar -->` …
   `<!-- end generated -->`), so a hand edit elsewhere in the file survives and the section can never drift from the minimaps. The rest of
   `.drawio.md` stays hand-written. `_sidebar_gen.py`'s logic (per-cell file counts, reasons, white-rim list capped at 5) moves into it.
4. **The verify files (decision A2):** recommended, commit them as `docs/.assets/explanation/<stem>.drawio.verify.md` (claim → `file:line` →
   status, corrections, drift), so every claim stays checkable; this needs ADR-REPO-FOLDERS#5 to allow a third companion beside
   `.drawio.md`. Alternative: drop them; each article's "Where the code and the ADR differ" keeps the drift.
5. **Checked-in tooling** under `.claude/drawio/explanation/`, replacing the out/ scripts:
   - `build.py`: per slide, decode → (optional edit) → re-embed the minimaps → rebuild the preview raster;
   - `check.ps1`: the per-file gates in batches of 60 paths, then the glob gates (the logic of `_check_all.sh`, `_check_docs.ps1` and
     `_lint_spell_globs.ps1`);
   - the gallery mode of `gallery_pdf.py` for `docs/explanation` (the logic of `_gallery.py`, with an option to skip the minimap pages; the
     full PDF is 379 MB). Delete the stale out/ scripts once these exist.
6. **A gate that keeps it true:** `Test-ExplanationAssets` (in Catzc.Base.Docs, one function per file, L0 + L1 tests per ADR-AUTO-TEST). It
   reports:
   - a slide without its `.drawio.md`, three minimaps or three sister `.md` files;
   - an article without its slide, or a slide without its article;
   - a Supports cell whose codes are not in the ADR index;
   - a generated Sidebar section that no longer matches a fresh render (regenerate into a temp folder and compare, the way
     Test-GeneratedFiles does). Register it with the manual test plan.
7. **The new kind of article:** the agent definition `.claude/agents/drawio-diagram-waves.md` and STYLE.md document the committed flow, so
   the next wave lands in `docs/` directly.

## Order and owners

| Step | What                                                                                    | Owner                                                         |
| ---- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| 1    | Decisions B1, B2, A1, A2                                                                | user                                                          |
| 2    | B.1–B.4: the ADR, adrs.yml, AdrsConfig, Maps model, tests                               | the tracks / Maps owner (to confirm), as `catzc-worker` tasks |
| 3    | A.2 + A.3: the docs-derived slide list and the generated Sidebar in the minimap tooling | `catzc-worker`, coordinated with that owner                   |
| 4    | A.5: checked-in build, check and gallery tooling                                        | `catzc-worker`                                                |
| 5    | Regenerate all 88 slides' minimaps, sister files and Sidebar sections; B.5 doc words    | the tooling, then one review pass                             |
| 6    | A.4 verify files (if kept) and the ADR-REPO-FOLDERS amendment                           | `catzc-worker`                                                |
| 7    | A.6 `Test-ExplanationAssets` with its tests; delete the stale out/ scripts              | `catzc-worker`                                                |
| 8    | Run every gate; rebuild the gallery                                                     | lead                                                          |

Per-file checks only; the user runs the full suite and commits. Edit one file at a time; no scripted sweeps across files.

## Decisions taken (2026-10-15, user)

- **B1:** a thin band under each stack row.
- **B2:** decide through the ADRs. catzc-8d reads ADR-DSGN-TRACK and the related principles, and writes the amendment, including the term
  (the user suggested a name like "concern-cross-cutting").
- **A1:** yes, the `.drawio.png` is the only slide source.
- **A2:** commit the verify files; catzc-8d owns them.

## Decisions for the user (as asked)

- **B1:** how cross-cutting is drawn. Recommended: a thin band under each stack row. Alternative: one band under the grid.
- **B2:** how adrs.yml marks it: `cross_cutting: true`, or an empty `concern` with a declared meaning. Is git part of the cross-cutting
  layer with automation (the user's "automation git"), so `version-control` and the git-facing ADRs move there too?
- **A1:** the `.drawio.png` is the only slide source (recommended), or also commit `.drawio.xml`.
- **A2:** commit the verify files as `.drawio.verify.md` (recommended), or drop them.
