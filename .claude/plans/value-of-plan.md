---
plan:
  status: active
  reviewed: 2026-10-21
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

| Value   | Plan                         | Why                                                                                                                            | Needed docs                                               | Needed tests                                                                              | State                                                         |
| ------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| highest | plan-master                  | The one executable order over every open step of every plan; task files are its disposable executables.                        | ADR-REPO-PLANS names the task files (the plans ADR)       | Test-Plans over the folder (the plans ADR)                                                | nineteen chunks; the user's and the sweep last                |
| high    | plan-listen-internal-readers | The editor's note 0001: the glossary, track registry, how-to and CLAUDE.md say nothing internal reads the unordered part.      | ADR-THES-NORMALFORM, ADR-DSGN-TRACK-UNORDEREDTRACK        | Test-Glossary, the Variants track-type tests, Test-Links                                  | one step left, the user's CLAUDE.md edit                      |
| medium  | plan-diagram-build-learnings | A session's learnings folded back: a correct Build-Diagrams help, a fuller run skill, a quiet legend, a cheaper minimap stage. | the Build-Diagrams comment page, the catzc-run capability | Test-AgentDefinitions, the renderer's tests, Pester for the minimap writer                | decided; docs, instructions, renderer, speed, one sample      |
| medium  | plan-claude-diet             | Every session stops reading 2400 bytes of agent purposes that agents.yml and each description already hold.                    | none (the agents registry holds the text)                 | Test-AgentDefinitions, Test-Links on CLAUDE.md                                            | decided; two steps in one user edit, three capability clauses |
| medium  | plan-test-signal-proposals   | One failing lint names itself in the run, and the spelled-types list lives once.                                               | none                                                      | the Language bridge's L1 case, the spelling and terminology tests, Test-SourceConventions | blocked on three questions for the user                       |

## Feature plans (a capability of cats), here with class: feature in the head

| Value       | Plan                    | Needed docs                                                                                         | Needed tests                                                                                           | State                                                                 |
| ----------- | ----------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------- |
| highest     | plan-minimal-heads      | ADR-REPO-FILEMETA, ADR-REPO-CODEMETA, ADR-REPO-VARIANT-FILEHEADS (new), the dropped-keys page       | Pester for FileHeadPolicy, VariantsConfig and the file-meta engine, Test-FileMeta, Test-GeneratedFiles | decided; three steps left                                             |
| medium      | plan-session-learnings  | the session-finalize skill (the learning definition)                                                | Pester for Add-SessionLearning and LearningsConfig                                                     | decided; six steps                                                    |
| high        | plan-truth-stores       | ADR-THES-STORES (written), its FACTSOURCEREADONLY rule reworded for the ADO split                   | Test-Glossary, L0 Pester for the truth-store config, Test-Contracts                                    | decided; the image slide pattern, then the deck slide                 |
| high        | plan-agent-shortcuts    | the plans ADR names New-Plan                                                                        | Pester for the gate runner and New-Plan, Test-AgentDefinitions                                         | one step left, the user's CLAUDE.md line                              |
| high        | plan-idiomatic-names    | ADR-AUTO-IDIOM (written), the command-contracts and api-contracts rules (written)                   | Test-IdiomaticNames, Pester for the naming types, Test-Contracts                                       | folders renamed; wiring and the normal form open                      |
| high        | plan-agent-friction     | ADR-REPO-PLANS gains the three-part plan rule; a how-to for a head fact                             | Pester for Test-Plans and Test-Formatting, the hook test, Test-ParameterConsistency                    | one check, the head how-to and drawing, the user's trim               |
| medium-high | plan-git-topic-commands | ADR-FLOW-GIT (the commands named), the four commands' comment pages                                 | L0 and L1 Pester for the Git module (the flow over a scratch server), the Assert-BashTimeout hook test | built; one formatting check after the whole-tree re-format            |
| medium      | plan-eac-normal-form    | ADR-THES-NORMALFORM (written), the technical migration ADR (open)                                   | Test-AdrRegistry, Test-Glossary, Pester for the uncontested check                                      | one step left, the explanation page                                   |
| medium      | plan-adr-authoring      | ADR-REPO-VOCAB (contrast as one declaration), ADR-REPO-LINK (pending finding), an add-an-adr how-to | Pester for Build-Glossary and the glossary violations, the Test-Links tests, the hook test             | three steps free, one follows agent-friction's hook                   |
| medium      | plan-accosted-language  | ADR-AUTO-ACCOSTED (new), the glossary term, the reserved terminology category                       | Pester for Test-Terminology, Get-FileLanguage, the accosted types, reader and runner, Test-Contracts   | decided; the ADR and reserved word first                              |
| medium      | plan-bcl-language       | the BCL reference-set rule in ADR-AUTO-TYPES, the narrowed ADR-PWSH-TYPES rules, the bcl domain     | Test-Links on the moved pages, Pester for the host-binding gate and config, Test-AdrRegistry           | the re-cite, the sample move, then the row rename after minimal-heads |
| medium      | plan-debt-signals       | none (page lines only)                                                                              | Pester for Format-Code, Write-TestRunFailures and Get-CodeCaller, Test-Links, Test-Contracts           | planned; twenty steps                                                 |
| low         | plan-file-meta-cache    | ADR-AUTO-CACHE names a per-file input beside the file                                               | Format-Code's tests, the analyzer on one file                                                          | decided; four steps                                                   |
| low         | plan-session-finalize   | ADR-REPO-AGENTS-CAPABILITYFILE states the roof count                                                | Test-AgentDefinitions' tests                                                                           | decided; three steps                                                  |

## Pending deletion

A done plan, task file or landed prompt is deleted from disk directly (the user, 2026-10-19: "just delete done plans"); the user commits the
deletion. A plan holds only planned work that is not yet implemented (the user, 2026-10-20): no Done section, no proof of built work, no
explanation of how the tool behaves when a team uses it; that belongs in the docs.
