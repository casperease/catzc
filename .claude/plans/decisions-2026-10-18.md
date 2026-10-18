---
plan:
  status: active
  kind: decisions
  reviewed: 2026-10-18
---

# Decisions of the 2026-10-18 questionnaire round

One row per item of `questionnaire-2026-10-18.md`, added as the user answers. Rec says whether the recommendation was taken. Outcome is the
projected effect in the tree. ADR home names the rule that carries the decision, or none for an action.

| Q   | Decision                                                                                       | Rec | Outcome                                                                         | ADR home                        | Note |
| --- | ---------------------------------------------------------------------------------------------- | --- | ------------------------------------------------------------------------------- | ------------------------------- | ---- |
| D01 | the resolver stays identity-only above Languages; needs and order stay in ModuleSystem         | yes | plan-module-kinds-tracks choice (a) confirmed as built; nothing moves           | ADR-AUTO-MODULE                 |      |
| D02 | track key `execution_engines`, table `layout`; "kind" enters the ADR text with the role rename | yes | choice (b) confirmed; T012 brings role wording                                  | ADR-AUTO-MODULE; ADR-DSGN-TRACK |      |
| D03 | rule 6 covers check and test handlers only; LoadedModule dropped with BaseModule               | yes | choice (c) confirmed; T011 builds the handler ids                               | ADR-AUTO-MODULE#6               |      |
| D04 | Copy-Automation selects the full profile by default and does not copy .scriptanalyzer          | yes | plan-module-model-closeout line ticked; Copy-Automation.Tests keeps the default | ADR-AUTO-DEFAULT#6              |      |
