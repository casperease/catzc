---
plan:
  status: active
  value: low
  reviewed: 2026-10-17
  targets: [.claude/drawio/gallery_pdf.py, .claude/skills/drawio-waves/SKILL.md, .claude/drawio/STYLE.md]
---

# Assets gallery PDF: every PNG under docs/.assets in one review file

`gallery_pdf.py --assets [<assets-dir>] [--no-text]` writes `out/diagrams/assets-gallery.pdf`: every PNG under the assets dir (default
`docs/.assets`) in path order, captioned with its folder, each followed by its same-stem markdown companion (`X.drawio.png` ->
`X.drawio.md`, `X.chain.png` -> `X.chain.md`) as a text page. It extends the existing gallery builder; the fan-out and wave modes are
unchanged. The PDF is for a person in a PDF viewer (`review-pdf` in `output-formats.yml` already matches `diagrams/*.pdf`).

## Landed

- The mode itself, tested on `docs/.assets/commits-quality` (4 pages) and run in full with `--no-text`: 609 pages, 41.3 MiB.

## Measured

- Full run without text pages: 609 pages, 41.3 MiB, under 360 s. With text pages the earlier build was 90 MiB.
- A chat upload is capped at 30 MiB, so the file was split into two halves (305 + 304 pages) outside the tree to send it.
- 2026-10-17, after the descriptions moved beside the articles and the builder streams pages: `docs/explanation/.assets` without text is 593
  pages; with the description pages (the minimap pages run to thousands of rows, cut into pages under the encoder roof) 1059 pages and 684
  MiB, so D07's split question is about a factor of 20, not 2.

## Open steps

- [x] Name the mode in `.claude/skills/drawio-waves/SKILL.md` (it lists `gallery_pdf.py` as an on-ask tool) (check: the line says
      `--assets`). Done 2026-10-17 (assets leftovers): the bundles line names `--assets <tree>/.assets`; `AGENTS issues=0`
      (Test-AgentDefinitions), `SPELL issues=0` on the file.
- [x] Decide whether a `--parts <n>` split belongs in the builder, so a file over a size cap needs no side script (check: a decision
      recorded here; if yes, a flag and a run that yields parts under 30 MiB). Decided 2026-10-18 (D07): no flag; the PDF is a review
      artifact and the cap is the chat's, so a side script splits when a review needs it.
- [ ] Add a small test fixture run (two PNGs, one with a companion) if the kit gains a test home (check: page count is 3). 2026-10-17: the
      kit has no test home (`.claude/drawio` holds scripts, minimaps and the style guide, no tests folder), so the run waits for one.

## Refs

- .claude/drawio/gallery_pdf.py
- automation/Catzc.Base.Reports/configs/output-formats.yml (`review-pdf`)
