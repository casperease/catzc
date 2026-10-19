---
plan:
  status: active
  reviewed: 2026-10-18
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

| Value   | Plan                                    | Why                                                                                                                                  | Needed docs                                                        | Needed tests                                        | State                                                  |
| ------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------------------ |
| highest | plan-master                             | The one executable order over every open step of every plan; task files are its disposable executables.                              | ADR-REPO-PLANS names the task files (the plans ADR)                | Test-Plans over the folder (the plans ADR)          | every chunk a task file                                |
| high    | plan-layers-vocabulary-rename-contracts | Settles six words and names the public API.                                                                                          | ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT; glossary | three terminology gates; guard rule; Test-Contracts | P6 open, on the user's go                              |
| high    | plan-explanation-drift-gaps             | CD deploys the prod tier with no gate today (Q3), and the ADRs promise deploy-path, run-mode and safeguard behaviour the code lacks. | the articles' drift sections                                       | the user's pipeline runs and the approval sync run  | Q1 to Q3 proofs and the only-pwsh rename (the user's)  |
| high    | plan-promotion-ladder                   | The ADRs' ladder (main-uat, release-uat, RC/RBC, pre-prod, DEPLOY) has no code; prod waits only on the new approval check.           | ADR-DSGN-LIFE, ADR-FLOW-CD as the answers decide                   | per pipeline, a run that shows the rung             | the main-uat rename and the record, after the CD proof |
| high    | plan-diagram-engine                     | Every diagram and slide needs a correct, reproducible, markdown-driven renderer before its fixes can be judged.                      | the minimap and slide ADR rules; module README                     | pytest on the moved tests; minimap data tests       | code move, minimap redefinition and fix list open      |
| high    | plan-generated-file-heads               | Generated tracked files carry provenance and a do-not-edit signal in the head, not the body.                                         | the head vocabulary and policy                                     | a test of the one warning string in every head      | README body noise, four config files, JSON carrier     |
| high    | plan-ado-and-cicd-docs                  | Moves the ado vendor tree into `.ado` and separates it from the CI/CD concept in ADR-FLOW.                                           | ADR-FLOW concept ADR; ado wording                                  | Test-Pipelines; Test-Adr                            | move, caller sweep and the concept ADR open            |
| medium  | plan-adr-automation-split               | Separates general automation ADRs from pwsh and other language ADRs.                                                                 | docs/adr/index.md; adrs.yml                                        | Test-Adr; Test-Links                                | layout decided, moves open                             |
| medium  | plan-iac-and-repo-placement             | Settles where IaC lives and what a repo is, given tracks and exported tooling.                                                       | ADR rules in docs/adr/azure and docs/adr/repository                | Test-Variants                                       | placement and repo ADRs open                           |

## Feature plans (a capability of cats), here with class: feature in the head

| Value | Plan | Needed docs | Needed tests | State |
| ----- | ---- | ----------- | ------------ | ----- |

## Pending deletion

`out/delete-done-plans.ps1` holds the `git rm` lines of the done plans, task files and landed prompts (plan-adr-code-language last); the
files stay on disk until it runs.
