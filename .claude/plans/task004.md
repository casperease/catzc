---
task:
  id: "004"
  status: open
  plans:
    [
      plan-module-model-closeout,
      plan-module-kinds-tracks,
      plan-idle-compaction,
      plan-assets-gallery-pdf,
      plan-test-run-budget,
      plan-lazy-types-load,
      plan-layers-vocabulary-rename-contracts,
      plan-unboxing,
      plan-skip-unchanged-generators,
      plan-file-head-immutable-edges-classes,
      plan-adr-ai,
      plan-clear-actions,
      plan-materialization-of-knowledge,
    ]
  value: high
  blocked_on: the user answers; nothing is decided by the agent
  targets: [.claude/plans]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task004.md"
    folder: plans
    name: task004
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task004: the decision round that unblocks the most

Run as the plan-decide robot runs: one questionnaire item per open question, four per ask, the recommendation first and labelled, every
answer recorded in a decisions file with Q, Decision, Rec taken, Outcome, ADR home, Note, then folded into the owning plan one file at a
time. An unanswered item stays open. Items are numbered D01 upward and never renumbered.

## Items (with the recommendation first)

- D01 Module model choice (a): the resolver lives in a new small module above Languages and returns identity only; needs and order stay in
  ModuleSystem. Rec: confirm as built. Owner: plan-module-kinds-tracks Decided.
- D02 Choice (b): the track key is execution_engines; the table is called layout; "kind" stays out of the ADR text until the role rename.
  Rec: confirm. Owner: same.
- D03 Choice (c): rule 6 covers check and test handlers only; LoadedModule dropped with BaseModule. Rec: confirm; then T011 builds the
  handler ids. Owner: same.
- D04 Copy-Automation selects the full profile by default and no longer copies .scriptanalyzer. Rec: confirm. Owner:
  plan-module-model-closeout.
- D05 Minimaps of the run-mode slides: keep the rebuild that redrew every slide's minimaps, or revert to the committed ones. Rec: keep
  (Test-Links and Test-GeneratedFiles clean there). Owner: plan-module-model-closeout.
- D06 Idle compaction scope: keep idleCompaction false in the local settings (per-person preference) or check it in. Rec: keep local. Owner:
  plan-idle-compaction.
- D07 gallery_pdf.py --parts: a split flag in the builder, or no flag and a side script when a file exceeds 30 MiB. Rec: no flag; the PDF is
  a review artifact and the cap is the chat's, not the tree's. Owner: plan-assets-gallery-pdf.
- D08 Format cache stamp rule: an engine's stamp contains its own tool pin and its own settings files, nothing else. Rec: yes, with the test
  that every declared input invalidates. Owner: plan-test-run-budget.
- D09 Lazy types and the source-console janitors: run janitors after the first prompt, or keep them as catzc commands that trip the lookup
  hook (lazy pays off for bundle, -SkipJanitors and idle sessions only). Rec: run janitors after the first prompt. Owner:
  plan-lazy-types-load.
- D10 Layers P4, the folder move automation to pwsh: name the quiet window, or hold. Rec: hold until T011, T017 and T018 are green; the user
  names the window. Owner: plan-layers-vocabulary-rename-contracts.
- D11 Unboxing P4 and P5: go (measure first, 15 percent bar) or stay closed. Rec: stay closed; the measured wins are in. Owner:
  plan-unboxing.
- D12 Build-Readme: stamp with_inputs_sha into the README meta block of about 55 committed copies, or record not skippable. Rec: not
  skippable (about 200 ms of 315 is first-call JIT). Owner: plan-skip-unchanged-generators.
- D13 Format-Code and automation/.compiled: skip the folder, or amend the formatting ADR to cover it. Rec: skip; .compiled is generated
  output (Q47 asks to follow the ADR; this names the reading). Owner: plan-file-head-immutable-edges-classes.
- D14 ADR-AI code form: keep ADR-AI with no domain segment (AdrCodeForm must parse it) or give it a domain. Rec: keep, since ADR-CATS takes
  the same form (B3 put ADR-CATS in principles; its code has no domain segment either). Owner: plan-adr-ai. Answered 2026-10-17 (the user,
  asked by task005 when the registry rejected the form): keep; `AdrsConfig` now accepts one or more uppercase segments.
- D15 Test-Glossary's about 195 bare-term findings in plan text ("full suite", "gate", "phase", "layer", "source", "slot"): fix per plan
  when next edited (task002 step 10), or exempt plan files from the vocabulary gate. Rec: fix per plan; the F1 decision says the gate covers
  plans. Owner: plan-clear-actions.
- D16 Materialization choices 1 to 3 were taken in Q66 to Q70; confirm nothing reopens before T026 writes the ADR. Rec: confirm. Owner:
  plan-materialization-of-knowledge.

## Steps

1. Write `questionnaire-2026-10-17.md` with D01 to D16: one to five lines of context each, the options, no links. Check: 16 items.
2. Write `decisions-2026-10-17.md` with the table head Q, Decision, Rec taken, Outcome, ADR home, Note. Check: the head exists.
3. Ask four items per AskUserQuestion call, first option the recommendation and labelled so; after each call add one row per answer. Check:
   16 rows, or an "open" row per unanswered item.
4. Fold each decision into its owning plan's Decided section and open steps, one file at a time; mark the questionnaire items answered.
   Check: grep "user not yet confirmed" in plan-module-kinds-tracks finds nothing when D01 to D03 are confirmed.
5. Update `plan-master.md`: a chunk whose block was a D-item loses it. Check: grep blocked_on shows only the user's gos (D10, D11).

## Report

As report-fixed: items asked and answered, recommendations taken and not, plans updated, questions left open.
