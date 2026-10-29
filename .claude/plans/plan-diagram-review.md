---
plan:
  status: active
  value: medium
  reviewed: 2026-10-29
  class: feature
  targets: [.claude/skills/diagram-review/SKILL.md, python/diagrams/declaration.py, python/diagrams/configs/drawio.yml]
---

# Diagram review: findings fixed by cause, the user vetoes after

## Why its value is medium

The diagrams are read by people and by LLMs; each fix to the engine, the language or a declaration improves every render it touches, and a
redraw costs no LLM tokens since the tooling draws.

## Decided

- The cycle is autonomous (the user, 2026-10-28): review rounds find, the agent groups findings by cause, decides and lands each fix
  engine-first (`python/diagrams/`, then the language in `python/diagrams/configs/drawio.yml`, then one declaration), and records it in the
  veto list `out/diagram-review-findings.md` (what, why, which pngs, how to revert). A veto is the source of the next step.
- A language change keeps every existing declaration valid (an additive key with its default declared once) or corrects every declaration in
  the same change (PDR-ONELIVE); no old spelling stays behind.
- Reviewers never propose full paths: the dotted "Where does it live?" row form is fixed. The glyph legend is skipped.
- A file to open is named as a plain path from the repository root, never a link.

## Open steps

- [ ] `python/diagrams/`: the bare-word finding (a bare word standing on a box after the `word-step-out` pill fix, 7 diagrams left) lands
      as one engine fix, re-staged after its rolled-back burst, and is added to the veto list (check: the kit suite green, `Test-Diagrams`
      clean over the redrawn diagrams, two or three of them looked at).
- [ ] `out/diagram-findings.md`: the next haiku round covers only what it lists as unchecked (the rows and titles of its lines 181-570),
      batches of 10 in repository order, one haiku per png; each finding goes to the cycle above by cause (check: a per-diagram list per
      batch, each next brief sharpened from the last).
- [ ] The closing sample: a haiku review of 30 pngs reports no diagonal between aligned boxes, no mark over a label or tag, rows that sum to
      their counter, and drawn titles that match their file topic (check: `Test-Diagrams` clean over the tree and that sample's list).
