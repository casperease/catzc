---
plan:
  status: active
  kind: decisions
  reviewed: 2026-10-18
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/decisions-2026-10-18.md"
    folder: plans
    name: decisions-2026-10-18
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
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-MODULE#6
      - ADR-AUTO-TYPES#16
      - ADR-DSGN-TRACK#17
      - ADR-PWSH-VERBS#2
      - ADR-REPO-FILEMETA#11
---

# Decisions of the 2026-10-18 questionnaire round

One row per item of `questionnaire-2026-10-18.md`, added as the user answers. Rec says whether the recommendation was taken. Outcome is the
projected effect in the tree. ADR home names the rule that carries the decision, or none for an action.

| Q   | Decision                                                                                                   | Rec | Outcome                                                                                                                             | ADR home                                | Note                                             |
| --- | ---------------------------------------------------------------------------------------------------------- | --- | ----------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------- | ------------------------------------------------ |
| D01 | the resolver stays identity-only above Languages; needs and order stay in ModuleSystem                     | yes | plan-module-kinds-tracks choice (a) confirmed as built; nothing moves                                                               | ADR-AUTO-MODULE                         |                                                  |
| D02 | track key `execution_engines`, table `layout`; "kind" enters the ADR text with the role rename             | yes | choice (b) confirmed; T012 brings role wording                                                                                      | ADR-AUTO-MODULE; ADR-DSGN-TRACK         |                                                  |
| D03 | rule 6 covers check and test handlers only; LoadedModule dropped with BaseModule                           | yes | choice (c) confirmed; T011 builds the handler ids                                                                                   | ADR-AUTO-MODULE#6                       |                                                  |
| D04 | Copy-Automation selects the full profile by default and does not copy .scriptanalyzer                      | yes | plan-module-model-closeout line ticked; Copy-Automation.Tests keeps the default                                                     | ADR-AUTO-DEFAULT#6                      |                                                  |
| D05 | keep the rebuilt minimaps of the run-mode slides                                                           | yes | plan-module-model-closeout line ticked; the rebuilt files stand (the user's commit)                                                 | none (action)                           |                                                  |
| D06 | idleCompaction stays in the local settings                                                                 | yes | plan-idle-compaction closes and is deleted                                                                                          | none (per-person setting)               |                                                  |
| D07 | no --parts flag in gallery_pdf.py; a side script splits when a review needs it                             | yes | plan-assets-gallery-pdf line ticked; task023 step 5 closes                                                                          | none (review artifact)                  |                                                  |
| D08 | an engine's format cache stamp holds its own tool pin and its own settings files, nothing else             | yes | T029 steps 1 and 2 unblocked: the ADR-REPO-FORMAT sentence and two tests                                                            | ADR-REPO-FORMAT                         | the test proves every declared input invalidates |
| D09 | the source-console janitors run after the first prompt                                                     | yes | T025 step 1 unblocked: the console prompt hook with its test; the import stays types-free                                           | ADR-AUTO-TYPES#16; ADR-AUTO-IMPORTER    |                                                  |
| D10 | layers P4 (automation/ to pwsh) holds until T011 and T018 are green; the user names the window then        | yes | plan-layers P4 line unchanged; T019 P4 and P6 stay on the user's go                                                                 | ADR-AUTO-LAYERS                         |                                                  |
| D11 | unboxing P4 and P5 stay closed                                                                             | yes | plan-unboxing closes after the user's commit of the types; no P4/P5 plan                                                            | none (action)                           |                                                  |
| D12 | Build-Readme recorded as not skippable                                                                     | yes | task031 step 1 and the plan's Build-Readme line close; T031 done                                                                    | none (action)                           | 200 of 315 ms is first-call JIT                  |
| D13 | Format-Code and Test-Formatting skip automation/.compiled as generated output                              | yes | T022 step 3 unblocked: the skip and the ADR sentence naming the reading                                                             | ADR-REPO-FORMAT                         |                                                  |
| D15 | the plan-text vocabulary findings are fixed per plan when it is next edited                                | yes | no exemption; plan-clear-actions line stands as the standing rule                                                                   | ADR-REPO-VOCAB (F1)                     |                                                  |
| D16 | materialization choices 1 to 3 stand; nothing reopens                                                      | yes | T026 unblocked: ADR-AUTO-MATERIAL as drafted                                                                                        | ADR-AUTO-MATERIAL                       |                                                  |
| D17 | Assert-Wait becomes Watch-Blocking; the assert subkind is untouched                                        | yes | plan-assert-wait Q6 closes; the rename lands in the same change as the Q5 ADR pair                                                  | ADR-PWSH-VERBS#2 and #3                 |                                                  |
| D18 | no ADR-AUTO-CACHE sentence on type-level statics                                                           | yes | task033 step 2's open question closes; the ADR stays as it is                                                                       | none                                    |                                                  |
| D19 | the C3 pilot contracts are the draft's set: the 8 Catzc.Base.Languages and 5 Catzc.Base.Contracts commands | yes | task020 C3 unblocked: 13 provided .command.yml files and the L1 enumeration                                                         | ADR-REPO-CMDCONTRACT                    |                                                  |
| D20 | the `note` file kind goes; its meaning gets a page first                                                   | yes | file-kinds.yml loses the kind, the reachability test is green, ADR-DSGN-TRACK#17 stops bolding note; the glossary term goes with it | ADR-REPO-FILEMETA#11; ADR-DSGN-TRACK#17 | never drop a key silently                        |
