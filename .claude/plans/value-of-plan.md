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

| Value   | Plan                         | Why                                                                                                                                       | Needed docs                                         | Needed tests                                                                                 | State                                          |
| ------- | ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| highest | plan-master                  | The one executable order over every open step of every plan; task files are its disposable executables.                                   | ADR-REPO-PLANS names the task files (the plans ADR) | Test-Plans over the folder (the plans ADR)                                                   | nineteen chunks; the user's and the sweep last |
| high    | plan-xdr-codes               | A code's first segment names its record kind, so about 3,800 framing citations each lose a segment and say what kind of record they cite. | ADR-REPO-ADRCODE, adr-code-language.md              | AdrsConfig and AdrCodeForm Pester, Update-AdrCitation dry runs, Test-AdrRegistry, Test-Links | decided; registry and parsers first            |
| high    | plan-listen-internal-readers | The editor's note 0001: the glossary, track registry, how-to and CLAUDE.md say nothing internal reads the unordered part.                 | ADR-THES-NORMALFORM, ADR-DSGN-TRACK-UNORDEREDTRACK  | Test-Glossary, the Variants track-type tests, Test-Links                                     | one step left, the user's CLAUDE.md edit       |
| medium  | plan-claude-diet             | Every session stops reading 2400 bytes of agent purposes that agents.yml and each description already hold.                               | none (the agents registry holds the text)           | Test-AgentDefinitions, Test-Links on CLAUDE.md                                               | the user's CLAUDE.md edit only                 |

## Feature plans (a capability of cats), here with class: feature in the head

| Value  | Plan                      | Needed docs                                                                                     | Needed tests                                                                                 | State                                                    |
| ------ | ------------------------- | ----------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| medium | plan-session-learnings    | the session-finalize skill (the learning definition)                                            | Pester for Add-SessionLearning and LearningsConfig                                           | decided; six steps                                       |
| high   | plan-agent-shortcuts      | the plans ADR names New-Plan                                                                    | Pester for the gate runner and New-Plan, Test-AgentDefinitions                               | one step left, the user's CLAUDE.md line                 |
| high   | plan-idiomatic-names      | ADR-AUTO-IDIOM (written), the command-contracts and api-contracts rules (written)               | Test-IdiomaticNames, Pester for the naming types, Test-Contracts                             | folders renamed; wiring and the normal form open         |
| high   | plan-agent-friction       | ADR-REPO-PLANS gains the three-part plan rule; a how-to for a head fact                         | Pester for Test-Plans and Test-Formatting, the hook test, Test-ParameterConsistency          | the head how-to and drawing, the user's trim             |
| medium | plan-bcl-language         | the BCL reference-set rule in ADR-AUTO-TYPES, the narrowed ADR-PWSH-TYPES rules, the bcl domain | Test-Links on the moved pages, Pester for the host-binding gate and config, Test-AdrRegistry | one step left, the user's CLAUDE.md line                 |
| medium | plan-minimap-reasons-gate | a reasons-section rule in the diagram ADR, one how-to line                                      | Pester for Write-DiagramMinimapData, Test-Links on the new pages                             | decided; the section shape, 176 .md files, then the gate |

## Pending deletion

A done plan, task file or landed prompt is deleted from disk directly (the user, 2026-10-19: "just delete done plans"); the user commits the
deletion. A plan holds only planned work that is not yet implemented (the user, 2026-10-20): no Done section, no proof of built work, no
explanation of how the tool behaves when a team uses it; that belongs in the docs.
