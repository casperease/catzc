---
plan:
  status: active
  reviewed: 2026-10-19
  rule: value first, then needed docs and tests; job size never ranks
---

# Value of each plan

Every live plan, ordered by value. Job size is not a factor. The two things that order a plan are the value it delivers and how much
doctrine (ADRs, glossary, CLAUDE.md) and proof (gates, Pester tests) it needs before it counts as landed.

## Naming and sorting

A file name is a stable semantic locator: `plan-<topic>.md`, never a rank or order prefix. This table is the sorting overlay; each head's
`value` key carries the same signal. The delivered default sort of the folder is the semantic name order. Meta plans live here; feature
plans stay as drafts in `out/`. Done plans are deleted, and done steps are pruned from the plans that stay: git holds the history.

## Intake rule for continuation prompts

Every item, idea or signal in a pasted continuation prompt lands in exactly one meta plan here. An item no plan covers gets a new plan at
the value it earns. What is reported done is checked against the tree, ticked, and then pruned. Nothing open in a paste is discarded; a
stale or superseded item is recorded as such, with the reason.

## Meta plans by value (how the repository describes and governs itself)

| Value   | Plan                                    | Why                                                                                                                                  | Needed docs                                                        | Needed tests                                            | State                                                          |
| ------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------ | ------------------------------------------------------- | -------------------------------------------------------------- |
| highest | plan-master                             | The one executable order over every open step of every plan; task files are its disposable executables.                              | ADR-REPO-PLANS names the task files (the plans ADR)                | Test-Plans over the folder (the plans ADR)              | twelve chunks, seven takeable now                              |
| high    | plan-layers-vocabulary-rename-contracts | Settles six words and names the public API.                                                                                          | ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT; glossary | three terminology gates; guard rule; Test-Contracts     | P6 on the user's go; stray rules open; drift test landed       |
| high    | plan-explanation-drift-gaps             | CD deploys the prod tier with no gate today (Q3), and the ADRs promise deploy-path, run-mode and safeguard behaviour the code lacks. | the articles' drift sections                                       | the user's pipeline runs and the approval sync run      | blocked on the user's three runs                               |
| high    | plan-promotion-ladder                   | The ADRs' ladder (main-uat, release-uat, RC/RBC, pre-prod, DEPLOY) has no code; prod waits only on the new approval check.           | ADR-DSGN-LIFE, ADR-FLOW-CD as the answers decide                   | per pipeline, a run that shows the rung                 | rungs registry landed 2026-10-19; rename and check after proof |
| high    | plan-diagram-engine                     | Every diagram and slide needs a correct, reproducible renderer driven by a yml declaration before its fixes can be judged.           | ADR-REPO-SLIDES rules for the declaration, directions and themes   | pytest on the moved tests; Test-Diagrams; minimap tests | isolated track, its own session; 23 steps open                 |

## Feature plans (a capability of cats), here with class: feature in the head

| Value | Plan | Needed docs | Needed tests | State |
| ----- | ---- | ----------- | ------------ | ----- |

## Pending deletion

`out/delete-done-plans.ps1` holds the `git rm` lines of the done plans, task files and landed prompts; the files stay on disk until it runs.
Added 2026-10-19: `prompt-layers-1-retire-and-rename.md` (its P5 landed, its P6 lives in task-layers-classification-flip, and it waits on a
report that does not exist) and `prompt-master-execute-continue.md` (names task numbers and decision files that are gone; a prompt is never
rewritten). Added 2026-10-19 by the diagram track session: `plan-module-system-per-language.md`, every step landed the same day it was
written; its decisions live in ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE and the three `*-MODULESBYLAYOUT` rules.
