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

| Value       | Plan                                    | Why                                                                                                                                  | Needed docs                                                                | Needed tests                                                                    | State                                                  |
| ----------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ------------------------------------------------------ |
| highest     | plan-master                             | The one executable order over every open step of every plan; task files are its disposable executables.                              | ADR-REPO-PLANS names the task files (the plans ADR)                        | Test-Plans over the folder (the plans ADR)                                      | every chunk a task file                                |
| high        | plan-layers-vocabulary-rename-contracts | Settles six words and names the public API.                                                                                          | ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT; glossary         | three terminology gates; guard rule; Test-Contracts                             | P6 open, on the user's go                              |
| high        | plan-module-model-closeout              | The model landed with open choices, a rule without code and stale pages; the close-out keeps them from being lost.                   | ADR-AUTO-MODULE rule 6 or its narrowing; Catzc.Base.Modules reference page | Copy-CatzcModule test; Test-AdrRegistry; Test-Links                             | closes on the final full run                           |
| high        | plan-explanation-drift-gaps             | CD deploys the prod tier with no gate today (Q3), and the ADRs promise deploy-path, run-mode and safeguard behaviour the code lacks. | the articles' drift sections                                               | the user's pipeline runs and the approval sync run                              | Q1 to Q3 proofs and the only-pwsh rename (the user's)  |
| high        | plan-promotion-ladder                   | The ADRs' ladder (main-uat, release-uat, RC/RBC, pre-prod, DEPLOY) has no code; prod waits only on the new approval check.           | ADR-DSGN-LIFE, ADR-FLOW-CD as the answers decide                           | per pipeline, a run that shows the rung                                         | the main-uat rename and the record, after the CD proof |
| medium-high | plan-file-head-immutable-edges-classes  | Head shape settled; globs still spelled seven times; registry, formatting and path-split records with leftovers.                     | CODEMETA note; naming rule PowerShell versus pwsh and powershell           | selector tests; five gates on the registry work; strengthened reachability test | closes on the final full run                           |
| medium      | plan-test-run-budget                    | 266 s against a 180 s roof.                                                                                                          | REPO-FORMAT stamp rule                                                     | the final run's shard manifest                                                  | the shard re-check reads the final run                 |
| medium      | plan-clear-actions                      | The cleaner's open verdicts.                                                                                                         | none                                                                       | Test-Links per file                                                             | the bounded-enumeration delete after the final run     |
| medium      | plan-fast-push-followups                | The real Push-Dirty run is unproven.                                                                                                 | none                                                                       | one real Push-Dirty run (the user's)                                            | the user's Push-Dirty run open                         |

## Feature plans (a capability of cats), here with class: feature in the head

| Value  | Plan                            | Needed docs                     | Needed tests       | State                               |
| ------ | ------------------------------- | ------------------------------- | ------------------ | ----------------------------------- |
| medium | plan-bounded-folder-enumeration | none left; ADR-PWSH-ENUM exists | the final full run | built and migrated; delete on green |

## Pending deletion

`out/delete-done-plans.ps1` holds the `git rm` lines of the done plans, task files and landed prompts (plan-adr-code-language last); the
files stay on disk until it runs.
