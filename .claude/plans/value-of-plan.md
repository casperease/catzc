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

| Value   | Plan                         | Why                                                                                                                            | Needed docs                                               | Needed tests                                                               | State                                            |
| ------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- | -------------------------------------------------------------------------- | ------------------------------------------------ |
| highest | plan-master                  | The one executable order over every open step of every plan; task files are its disposable executables.                        | ADR-REPO-PLANS names the task files (the plans ADR)       | Test-Plans over the folder (the plans ADR)                                 | two chunks, both the user's or the sweep         |
| medium  | plan-diagram-build-learnings | A session's learnings folded back: a correct Build-Diagrams help, a fuller run skill, a quiet legend, a cheaper minimap stage. | the Build-Diagrams comment page, the catzc-run capability | Test-AgentDefinitions, the renderer's tests, Pester for the minimap writer | planned; one question on where the drawing lives |

## Feature plans (a capability of cats), here with class: feature in the head

| Value  | Plan                 | Needed docs                                                                                                 | Needed tests                                                                               | State                                                                                             |
| ------ | -------------------- | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| high   | plan-listen-agent    | ADR-REPO-AI-EDITORISFACT (the AI agent contract)                                                            | Pester for Catzc.Tooling.Listen, Test-AgentDefinitions                                     | built, registered and run live; three editor notes to process                                     |
| high   | plan-truth-stores    | ADR-THES-STORES (written), its FACTSOURCEREADONLY rule reworded after Q1                                    | Test-Glossary, L0 Pester for the truth-store config, Test-Contracts                        | ADR and glossary committed; Q1-Q3 open, then config, contracts and one diagram                    |
| high   | plan-agent-shortcuts | the plans ADR names New-Plan                                                                                | Pester for the gate runner and New-Plan, Test-AgentDefinitions                             | planned; waits on two questions                                                                   |
| high   | plan-idiomatic-names | ADR-AUTO-IDIOM (written), the command-contracts and api-contracts rules (written)                           | Test-IdiomaticNames, Pester for the naming types, Test-Contracts                           | gate and assert built; wiring, renames and the normal form open                                   |
| high   | plan-agent-friction  | ADR-REPO-PLANS gains the three-part plan rule; a how-to for a head fact                                     | Pester for Test-Plans and Test-Formatting, the hook test, Test-ParameterConsistency        | planned; gates free, the hook and the drawing wait on two questions                               |
| medium | plan-eac-normal-form | ADR-THES-NORMALFORM (written), the technical migration ADR (open)                                           | Test-AdrRegistry, Test-Glossary, Pester for the uncontested check                          | thesis written; migration ADR, uncontested check, term renames and drawing wait on four questions |
| medium | plan-adr-authoring   | ADR-REPO-VOCAB (contrast as one declaration), ADR-REPO-LINK (pending finding), an add-an-adr how-to         | Pester for Build-Glossary and the glossary violations, the Test-Links tests, the hook test | planned; two steps free, the rest waits on two questions and two neighbouring plans               |
| medium | plan-bcl-language    | the BCL reference-set rule in ADR-AUTO-TYPES, the narrowed ADR-PWSH-TYPES rules, a bcl domain if Q2 says so | Test-Links on the moved pages, Pester for the host-binding gate and config, Test-AdrIndex  | planned; doc moves free, the rest waits on four questions                                         |

## Pending deletion

A done plan, task file or landed prompt is deleted from disk directly (the user, 2026-10-19: "just delete done plans"); the user commits the
deletion. A plan holds only planned work that is not yet implemented (the user, 2026-10-20): no Done section, no proof of built work, no
explanation of how the tool behaves when a team uses it; that belongs in the docs.
