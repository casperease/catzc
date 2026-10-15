# Plan: diagram wave 7 — land the slides as a `docs/explanation/` article set

Written 2026-10-14. Wave 6 (88 symbol slides, each with an article, a visual description and a verify file under `out/diagrams/wave-6/`) is
the source. This wave lands every slide in the repository as a checked explanation article plus two assets, and opens `docs/explanation/` as
a new documentation root.

## Goal

For each of the 88 wave-6 slides:

| Output                                             | Holds                                                                                                      |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `docs/explanation/<domain>/<explanation>.md`       | the **article**: location header, a `text` overview block, then the narrated article; links to both assets |
| `docs/.assets/explanation/<stem>.drawio.png`       | the **slide**, recoloured to the new structural palette (D1)                                               |
| `docs/.assets/explanation/<stem>.drawio.md`        | the **asset description**: the slide's visual description, carried over; location header + `text` block    |
| `out/diagrams/wave-7/<subfolder>/<stem>.verify.md` | the audit trail (claims → `file:line` → status, corrections, drift); stays out of the repository           |

Plus the indexes that make the set reachable: `docs/explanation/index.md`, one `docs/explanation/<domain>/index.md` per domain, and an
Explanation section in the global `docs/index.md`.

## Decisions

| #   | Decision                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| D1  | **Colours from eac's solution.** eac's hand-drawn structural diagrams draw structure in draw.io's dark, muted swatches with white text (slate `#647687`/`#314354` for almost everything, mauve `#76608a`/`#432d57` for the supporting kind, olive `#6d8764`/`#3a5431`), and keep light and bright colours for state. That separates structure from state, so nothing collides with the locked commit palette (ADR-DSGN-VISUAL#4). The glyph library adopts it: **code unit, store and runner** are slate (shape tells them apart), **named set** is mauve, **file** is olive, all with white text; gate, environment and external tool stay neutral grey; result, failure and ADR-only are unchanged. The idea comes from eac; catzc's STYLE.md decides. |
| D2  | **Article location:** `docs/explanation/<domain>/<explanation>.md`. `<domain>` is the ADR domain (adrs.yml) of the slide's main ADR code: automation (15), azure (5), configuration (5), design (38), flow (20), pipelines (5). `<explanation>` is the middle of the slide stem (`adr-auto-depm--three-layers-edges-point-down--architecture` → `three-layers-edges-point-down.md`); all 88 are unique.                                                                                                                                                                                                                                                                                                                                                  |
| D3  | **Asset location:** `docs/.assets/explanation/<stem>.drawio.png` and `<stem>.drawio.md`, flat, with the full stem as `<longname>`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| D4  | **Article shape:** `# <repo path>` (ADR-REPO-FORMAT#6), the title in backticks, then the first section, a fenced `text` block holding the **overview**: the finding in one line, then one line per numbered marker (`1  <name>  <what it is>`), then the ADR rules it supports. Then the lede, the image (linked to its asset location), `## Walkthrough` narrating every marker in order, `## Why it holds`, `## Where the code and the ADR differ` (only when drift exists), `## See also` (the ADR, the asset description, the sibling lenses of the same diagram).                                                                                                                                                                                   |
| D5  | **Asset description shape:** `# <repo path>`, the title in backticks, a `text` block with the at-a-glance summary, then Reading path, Glyphs, Edges, Legend, Sidebar (the wave-6 visual description), and a link back to the article. It uses only the glyph library's vocabulary.                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| D6  | **Indexes:** `docs/explanation/index.md` says what an explanation article is (the "why it works this way" quadrant, next to how-to, references and ADRs), shows **how to read the diagrams** with the glyph sheet landed as `docs/.assets/explanation/glyphs.drawio.png` + `.drawio.md`, and lists the domains. Each domain `index.md` lists its diagrams, each with its lenses in order (meta, architecture, implementation, operations, governance). `docs/index.md` gains an Explanation section linking the index and the six domains. `add-a-doc-chapter.md` gains the Explanation kind.                                                                                                                                                            |
| D7  | **ADR amendment (same change):** ADR-REPO-FOLDERS#5 and its Level-1 `docs/` paragraph name `explanation/` as a fifth folder and let `.assets/` hold each diagram's `<name>.drawio.md` description beside its `<name>.drawio.png`. No gate enforces "markdown-only", so no code changes.                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| D8  | **One-way references stay:** articles cite ADRs; ADRs never link to articles (ADR authoring conventions, add-a-doc-chapter). "Linkable" means reachable from the global index, the explanation index and the domain indexes, and cross-linked between sibling articles, with every link passing `Test-Links`.                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| D9  | **Correct:** each maker re-verifies every claim it narrates against the ADR, the code and the configs as they are now, and writes the verify file. Code wins on facts, the ADR on intent; drift is reported, never fixed.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| D10 | **Per-file checks only** (the user runs the full suite): each maker runs `out/diagrams/wave-7/_check_docs.ps1` on its own files — Format-Code, Test-MarkdownTitle, Test-Markdownlint, Test-Spelling, Test-Links. Unknown words are reported, not added: the lead adds them to `terminology.yml` once at fan-in (after messaging the session that edits it). The lead runs Test-Glossary once at fan-in.                                                                                                                                                                                                                                                                                                                                                  |
| D11 | **Wave-6 leftovers fixed in passing:** "The slide shows…" ledes rewritten to open on the subject; the auth implementation title/article mismatch; importer-load-sequence governance over the box limit; one arrow with two meanings in the run-modes and pipeline-runner legends; the thin-platform failure glyph named after a parameter.                                                                                                                                                                                                                                                                                                                                                                                                               |

## Phases

| Phase | Who                                        | Owns                                                                                                                                                                                                                                                                                                                                             | Done when                                                       |
| ----- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------- |
| P0    | lead                                       | D1 in `glyphs.xml` + STYLE.md; the ADR amendment (D7); `docs/explanation/index.md`, the six domain indexes, the `docs/index.md` section, the how-to row; the glyph sheet assets; `_check_docs.ps1`; the pilot (module-dependency-groups architecture) end to end                                                                                 | the pilot and the indexes pass `_check_docs.ps1`                |
| P1    | `drawio-diagram-waves`, 18 makers (12 + 6) | per diagram: recolour and rebuild its slides into `out/diagrams/wave-7/`, re-verify, write the articles and asset descriptions, copy the PNGs into `docs/.assets/explanation/`, run `_check_docs.ps1` on its files                                                                                                                               | every maker reports clean checks or lists what it could not fix |
| P2    | lead                                       | re-render all minimaps on the `#E6ECF2` page (user decision, after P1 launched) and rebuild + re-copy all 88 PNGs and the glyph sheet; fill the domain indexes, add reported words to `terminology.yml`, run Test-Glossary and `_check_docs.ps1` over all of `docs/explanation/**` and `docs/.assets/explanation/**`, rebuild the wave-7 gallery | all checks clean; a per-domain report to the user               |

## Renames at fan-in

The controlled-vocabulary check (Test-Glossary G6) flags a defined term with an unlisted qualifier even inside a file name, so two stems
were renamed in `docs/` only: `which-run-mode-rules-have-gates` → `which-run-mode-rules-have-a-gate` and
`ci-budget-is-the-only-machine-gate` → `ci-budget-is-the-only-quality-gate`. Their sources in `out/diagrams/wave-7/` and
`fan-out/_slugs.json` keep the old stems; nothing reads them for the docs.

## Minimaps (2026-10-15): catzc-f1's tooling

The slide sidebars carry three generated minimaps (world-map grid, tree, value-chain map), each with a reasoned sister `.md`, built by
`.claude/drawio/minimaps/` (highlights.ps1, render.py, describe.py, join.py). `out/diagrams/wave-7/_rebuild_all.py` and `_fanin_check.py`
expect the old `minimap-stack` cell and `_flowB/render.py`: don't run them.

Done by catzc-f1 (K4 + K5, user-approved): no density shading, every cell an idle outlined box (zeros included), one lit encoding across the
three minimaps (ink `#37474F`; mentions-only at 40 %; a lit ADR file on the tree has a white rim), short horizontal labels, axis titles in
the map key and the sister `.md` "Key" section, idle cells explained once, and `docs/.assets/**` excluded from lighting through its own
citations (`maps.yml` `highlight.citation_exclude`). Facts: `out/diagrams/k4-sidebar-facts.json`.

## Open items: all DONE 2026-10-15

Items 1–5 below are complete:

- K7 fixed the adr-file bug.
- `make-slides.py` reads each docs slide's ADR set from its drawn Supports cell; five slides were regenerated.
- 88 Sidebar sections are written from the facts (each placement reasoned).
- The index describes the three maps.
- All 451 files pass the six per-file checks; markdownlint, spelling and Test-Glossary pass over the tree.
- The gallery is built: 537 pages, 379 MB.

Kept below as the record.

## Open items (what is missing), in order

1. **DECIDED (2026-10-15, user, via catzc-f1): option B.** `highlight.citation_exclude` defaults to `docs/.assets/**`, `docs/explanation/**`
   and `.claude/drawio/**`; catzc-f1 is regenerating both waves, and that also fixes the protected-globs grouping. Wait for its refreshed
   facts file before item 2. The analysis that led here: **What a minimap lights.** The user requires every placement to be correctly
   reasoned in the checked-in sister `.md` (memory: minimap-placements-reasoned). After K5 the world-map grid still lights every repository
   file that cites the slide's ADR: 6,892 placements across 88 slides, up to ~490 files on one slide. 903 of them (13 %) come from
   `docs/explanation/**`, the articles that describe the same slides (a circular reason), and 31 from `.claude/drawio/**` style examples.
   Options:
   - **(A, recommended)** Light the slide's own sources only: the files its `.verify.md` pins to a `file:line`, plus its ADR files. About
     5–15 files per slide; every reason is concrete ("`Get-X.ps1:70`, verified claim 12").
   - **(B)** Keep repo-wide citations, but extend `highlight.citation_exclude` with `docs/explanation/**` and `.claude/drawio/**`. That ends
     the loop, but slides keep lighting hundreds of incidental citers. Send the choice to catzc-f1 (owner of `.claude/drawio/minimaps/` and
     `maps.yml`); it regenerates the minimaps, sister `.md` files and facts. That same regeneration also re-renders the 64 sister `.md`
     files whose text still places ADR-REPO-PROTGLOB in the automation group (catzc-27 moved the ADR to
     `docs/adr/repository/protected-globs.md` on 2026-10-15 and re-pointed only their links). **Blocker found after the option-B
     regeneration (reported to catzc-f1):** the `adr-file` basis lights every ADR file in the requested ADR's domain (2,004 of 6,149
     placements, 33 %), each falsely reasoned as "the ADR file of" the slide's ADR. Wait for the corrected facts.
2. **Sidebar sections** (generator ready: `out/diagrams/wave-7/_sidebar_gen.py` writes `_sidebar/<stem>.md`; a `catzc-worker` pastes each
   one with the Edit tool, one file at a time; cap the long tree white-rim lists) of the 89 `docs/.assets/explanation/*.drawio.md`
   (catzc-8d): rewrite "## Sidebar" and the sidebar line of the `text` block from the regenerated facts: the three minimaps by file name;
   per minimap the lit cells or groups with their reasons, quoted from the facts (mentions-only marked); the map key's four swatches. Use a
   `catzc-worker` with per-stem snippets generated into `out/diagrams/wave-7/`, pasted with the Edit tool one file at a time (no sweeps),
   each file checked.
3. **DONE 2026-10-15:** `docs/explanation/index.md` "How to read the diagrams" (catzc-8d), six per-file checks pass; was: three maps, in the
   defined terms. The **world map** is tracks × file languages, where the files are (ADR-DSGN-TRACK#9). The tree is the repository's files.
   The **value-chain map** is value-chain stack × value-chain concern, where the decision sits in delivery (ADR-DSGN-TRACK#14–#16). Plus
   **lit cell** (#12) and the map key.
4. **Checks:** `_check_all.sh` (titles, links), then `_lint_spell_globs.ps1` (markdownlint, spelling and glossary by path glob), over
   `docs/explanation/**` and `docs/.assets/explanation/**`, the 264 minimap sister `.md` files included.
5. **Gallery:** `out/diagrams/wave-7/_gallery.py`. Add each slide's three minimap sister `.md` pages after its asset description, then
   rebuild and send the user the link.

Outside this plan, open for the user: the commit (nothing is committed); code that accepts the `auto` engine value (ADR-AUTO-ENGINE#7 is
prose-only); `Build-Glossary` writes `<environment>` and `<subject>` unescaped into `docs/adr/glossary.md` (markdownlint MD033, already in
HEAD); two Test-Glossary G6 issues in other sessions' files ("wide gate" in `Catzc.Base.QualityGates/Test-Change.ps1:5`, "wide gates" in
`docs/how-to/getting-started/automation/run-tests-and-checks.md:20`); and the drift plan, `out/plan-adr-code-drift.md`.

## Done (2026-10-15): the ADR-PWSH citation sweep

catzc-27's P4 migrated `docs/explanation/**`; five slides drawing moved codes were redrawn and rebuilt (bundle governance ×2, thin-platform
×2, aspect governance), and the gallery was rebuilt. The steps below are kept for any later code move.

catzc-27's P4 sweep (`out/plan-adr-pwsh-split.md`) rewrites moved ADR-AUTO codes and `automation/powershell/` links across
`docs/explanation/**`, fences included, once catzc-43 finishes. Until it reports done, add no ADR-AUTO-\* citations there. When it runs, it
sends the list of slide PNGs in `docs/.assets/explanation/` that draw moved codes (old → new). For each one: update the embedded XML (the
subtitle and rule chips) in `out/diagrams/wave-7/<subfolder>/<stem>.xml`, rebuild with `_build_slide.sh`, re-copy the PNG (watch the two
renamed stems), then re-run `_check_all.sh` and `_lint_spell_globs.ps1`.

## Guardrails

- Never overwrite an existing `docs/.assets` file; a `.$<name>.drawio.png.bkp` sibling means the file is open in draw.io.
- No git. The user commits.
- Makers write only their own articles and assets; the indexes, `docs/index.md`, the ADR and `terminology.yml` are lead-owned.
- Present tense, plain English, the ADRs' own terms, "cats" in prose, "domain rules" / "ADR rules", never "house rules".
