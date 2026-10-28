---
plan:
  status: active
  value: medium
  reviewed: 2026-10-23
  class: feature
  targets: [.claude/skills/diagram-review/SKILL.md, python/diagrams/declaration.py, python/diagrams/configs/drawio.yml]
---

# Diagram review: one named slide at a time

## Source (the user's constrained prompt, 2026-10-23, typos corrected)

Visual notes for the diagrams in the solution, and a change of the review skills to: one named slide that the agent reads itself visually,
through its internal read and tokenizing, and then asks the user a question in context, ending with "I spotted: xyz" if the agent's visual
read spotted anything logical or visual that should be different. The agent then asks for the user's input as a text the user has to write.
Then the agent is ready to greet the user with: "What slide should we review and process in our yml and python diagram code to better suit
the reality?"

The process exists as quality control, to correct and edit the underlying markdown-based drawio yml, or the Python drawing engine, so that
the diagrams become more suited for human and LLM consumption as the cycle runs. A change can force a redraw of all `.drawio.png` in the
repository. The yml language interpretation must stay backwards compatible with existing declarations, or every declaration is globally
corrected and everything redrawn. Redrawing is free of LLM tokens, since the agent always redraws through the tooling.

(The first version of this prompt, 2026-10-23, asked for chunks of five slides, five questions and one plan step per answer; the single
named slide replaced it the same day.)

## The agent

`diagram-review` (the user skill `.claude/skills/diagram-review/SKILL.md`, which reuses `drawio-look`). It greets with the sentence above,
reads the named slide's PNG itself, asks one question in context ending with "I spotted: ..." for each logical or visual "this should be
different", takes the user's written text as the source of one open step, lands it, redraws and greets again. The user's text is the source
of every step; the agent's own taste is never one.

## What is reviewed

182 tracked `.drawio.png` renders. Most are declared in a `yml drawio` block directly above the image in a markdown article (168 blocks in
166 articles, the default carrier); 12 are `<name>.drawio.yml` files named under `carriers:` in `python/diagrams/configs/drawio.yml`; one is
the glyph legend. A comment's target is therefore usually an article's block, then `drawio.yml` (the language), then `python/diagrams/` (the
engine).

## Decided (the orchestrator as delegated, 2026-10-23)

- The user names the slide; when asked for a suggestion the agent proposes the next in this order: `docs/explanation` by folder (design,
  flow, automation, azure, repository, configuration, ado, thesis, then the glyph legend), then `docs/drs`, `docs/references`,
  `docs/how-to`; paths sorted ordinally within a folder.
- Slides already reviewed: `docs/explanation/design/.assets/10-commits-story.drawio.png` (title boxes above edges, candidate `slot`, span
  `row`, the last row of five spans).
- One running plan: each answer adds one step below the cycle step, and a landed step is struck.
- A language change keeps every existing declaration valid (an additive key with its default declared once) or corrects every declaration in
  the same change (PDR-ONELIVE); no old spelling stays behind.
- A file to open is named as a plain path from the repository root, never a link.

## Open steps

- [ ] The cycle, autonomous (the user, 2026-10-28): review rounds find, the agent groups the findings by cause (engine or router in
      `python/diagrams/`, language in `python/diagrams/configs/drawio.yml`, one declaration), decides and lands each fix engine-first,
      redraws the affected pngs with `Build-Diagrams`, looks at two or three of them itself, and adds each fix to the veto list
      `out/diagram-review-findings.md` (what, why, which pngs, how to revert); the user vetoes afterwards, and a veto is the next step's
      source. Check: each landed fix leaves its pngs re-rendered and looked at, the kit suite green, and `Test-Diagrams` clean over every
      diagram redrawn.
- [ ] Haiku review rounds of every rendered png, batches of 10 in repository order, skipping the glyph legend: one haiku per png reports (a)
      straight vs diagonal arrows and which box to move, (b) the "Where does it live?" rows verbatim, drawn boxes with no row, rows that
      match nothing drawn, and order; the dotted row form is fixed, so reviewers never propose full paths. Batch 1 (10) ran before the six
      minimap/router fixes; restart from batch 1 on the fresh renders. Round 1 over all 570 pngs is complete: about 224 diagonal pngs, 119
      title-mismatch pngs, 9 place-count mismatches, 13 missing "Where" panels, about 45 chip, clip, typo or count findings, 38 tilted
      renders; by root cause in out/diagram-findings.md, and the next round covers only what it lists as unchecked (rows and titles on lines
      181-570). Re-checked 2026-10-28 (out/diagram-review-findings.md): diagonals, deck titles, chips and place counts are cleared or by
      construction; the pill step-out (`word-step-out`) cut bare words from 35 diagrams to 7, and the next cause is the bare-word finding
      with the two declarations whose bare word stands on a box (four-domains-promote-one-artifact,
      three-gates-check-registry-drift-membership). Check: a per-diagram list per batch, each next batch's brief sharpened from the last,
      and (n) the drawn title matches the file topic. Check: `Test-Diagrams` clean over the tree, and a re-run haiku review of a 30-png
      sample reports no diagonal between aligned boxes, no mark over a label or tag, and rows that sum to their counter.
