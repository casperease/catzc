---
plan:
  status: active
  value: medium
  reviewed: 2026-10-23
  class: feature
  targets:
    [
      .claude/agents/diagram-review.md,
      .claude/skills/drawio-review/SKILL.md,
      python/catzc_diagrams/declaration.py,
      python/catzc_diagrams/configs/drawio.yml,
    ]
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

`diagram-review` (`.claude/agents/diagram-review.md`, capability `drawio-review`, which reuses `drawio-look`). It greets with the sentence
above, reads the named slide's PNG itself, asks one question in context ending with "I spotted: ..." for each logical or visual "this should
be different", takes the user's written text as the source of one open step, lands it, redraws and greets again. The user's text is the
source of every step; the agent's own taste is never one.

## What is reviewed

182 tracked `.drawio.png` renders. Most are declared in a `yml drawio` block directly above the image in a markdown article (168 blocks in
166 articles, the default carrier); 12 are `<name>.drawio.yml` files named under `carriers:` in `python/catzc_diagrams/configs/drawio.yml`;
one is the glyph legend. A comment's target is therefore usually an article's block, then `drawio.yml` (the language), then
`python/catzc_diagrams/` (the engine).

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

- [ ] The cycle: the agent greets the user, the user names a slide and nothing else, the agent reads it, decides every fix, lands it,
      redraws and reports "I spotted: ..." with what changed; the next pasted name is the acceptance, a sentence from the user overrides the
      decision it names. Check: each landed fix leaves its slide re-rendered and looked at, the kit suite green, and `Test-Diagrams` clean
      over every diagram redrawn.
- [ ] Edge labels too long for a pill stay unboxed and collide with a node: in `state-changes.drawio.png` `L3-vertical-AT` and `release-uat`
      are plain while `PR`, `BVT`, `main-UAT` and `release` are boxed, and `L3-vertical-AT` touches its yellow commit node (seen comparing
      2d6e24d30 with its parent, catzc-ed, 2026-10-26; the label pills and the side panel's blue palette were accepted as the intended
      change). Check: every edge label of the diagram boxed or placed clear of its nodes, and `Test-Diagrams` clean on it.
- [ ] Haiku review rounds of every rendered png, batches of 10 in repository order, skipping the glyph legend: one haiku per png reports (a)
      straight vs diagonal arrows and which box to move, (b) the "Where does it live?" rows verbatim, drawn boxes with no row, rows that
      match nothing drawn, and order; the dotted row form is fixed, so reviewers never propose full paths. Batch 1 (10) ran before the six
      minimap/router fixes; restart from batch 1 on the fresh renders. Check: a per-diagram list per batch, and each next batch's brief
      sharpened from the last.
- [ ] Edge-audit sweep wave 3: the 43 ambiguous and 4 reverse edges left in `out/edge-audit.md` (run
      `python/catzc_diagrams/edge_audit.py`) have no truthful word in `edge-labels` (calls, reads, writes, feeds, failed). Decide the
      words first, then sweep: promotion chains between environments (`four-domains-promote-one-artifact`, the azure subscription→group
      pairs), the zoom ladder's `zooms in`, else-chains (`callers-value-else-config-else-default`), glob-set remainder and composition
      (`each-track-picks-its-catch-all`, `get-aspect-names-the-remainder`, `units-not-tracks-own-the-pipelines`,
      `names-are-pure-and-never-truncated`), result→result sequences (`one-program-two-vendor-dialects`,
      `drift-is-gated-generation-is-drs-only`, `the-step-is-named-after-its-command`), descriptor hand-offs (`bicep-template-is-a-folder`,
      `bcl-language`'s `compiles`, `plain values`, `default pair`), and the vendor exits (`every-vendor-call-leaves-through-az`). The 4
      reverse edges are result→env on the two climb diagrams (`one-artifact-climbs-unchanged`, `pipeline-kinds-keyed-by-one-artifact`), whose
      `relation` opt-out the rule keeps; either the audit excuses an opted-out diagram's edges, or the climb is redrawn. Check: the
      audit's ambiguous and reverse counts fall to what the decision leaves, each swept diagram puts clean, and `Test-Diagrams` is 0.
- [ ] Move the article-carried diagrams off a diagram-level `relation`, to labelled arrows in the default reading (`feeds`, `calls`,
      `reads`, `writes`, `else` where a word is needed) or reworked as true state diagrams, since DDR-VISUAL-ARROWSPOINTATWHATTHEYDEPENDON
      keeps the opt-out for state and commit diagrams only. About 150 remain, declared in "yml drawio" blocks of the markdown under
      `docs/explanation`, `docs/how-to`, `docs/references` and `docs/drs`; the six standalone `*.drawio.yml` ones are done. The two state
      diagrams the rule names are the two in `docs/drs/flow/commit-lifecycle.md` ("advances one rung", "points at"), which keep theirs, and
      the climb and lifecycle diagrams under `docs/explanation/design` and `docs/explanation/flow` are state diagrams that keep theirs too.
      One page per change, render, read, respond, as a burst under the run lock. Check: a grep for `relation:` over the markdown and the
      `*.drawio.yml` files finds only state and commit diagrams, and `Test-Diagrams` is clean.
- [ ] `ConvertTo-NormalName` round-trip test fails on `*VSCode` names (`Assert-IsRunningInVSCode` against `…VsCode`), found by the Languages
      test run. Check: the Languages module passes `Test-Automation -Modules Catzc.Base.Languages` with 0 failed.
