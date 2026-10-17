---
plan:
  status: open
  value: low
  reviewed: 2026-10-17
  targets: [.claude/drawio/gallery_pdf.py, .claude/skills/drawio-waves/SKILL.md, .claude/drawio/STYLE.md]
catzc:
  immutable:
    with_body_sha: "590c75ce2ca8"
    repo_status: clean
    path: ".claude/plans/plan-assets-gallery-pdf.md"
    folder: plans
    name: plan-assets-gallery-pdf
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
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

## Open steps

- [ ] Name the mode in `.claude/skills/drawio-waves/SKILL.md` (it lists `gallery_pdf.py` as an on-ask tool) (check: the line says
      `--assets`).
- [ ] Decide whether a `--parts <n>` split belongs in the builder, so a file over a size cap needs no side script (check: a decision
      recorded here; if yes, a flag and a run that yields parts under 30 MiB).
- [ ] Add a small test fixture run (two PNGs, one with a companion) if the kit gains a test home (check: page count is 3).

## Refs

- .claude/drawio/gallery_pdf.py
- automation/Catzc.Base.Reports/configs/output-formats.yml (`review-pdf`)
