---
plan:
  status: active
  kind: questionnaire
  reviewed: 2026-10-16
  funnel: 20 items -> 10 fundamental questions -> 5 -> 2 -> end
---

# Fundamental questions, 2026-10-16: what changes for the repository

Batch 1 of the funnel. From the 126 items of questionnaire-2026-10-16.md, the twenty of highest interest were selected by what they
change in the repository, not by their order, and distilled into ten questions of one form: what changes for the repository. After
their answers the ten become five, the five two, and the two end in one statement of what the repository becomes. The items not
selected (about eighty, answered and unanswered alike) are the next batch, run the same way.

## The twenty selected

Q18b ADR-CATS; Q98 Track as root; Q96 plans as deltas; Q97 decisions become rules; Q07 plans authored in .claude/plans; Q05 stable
locators repository-wide; Q10 body-sha removal; Q09 .unordered emptied for the landing zone; Q66 scoped sha as deployable-module globs;
Q70 ADR-AUTO-MATERIAL now; Q101 analyzer rule for literal defaults; Q16 defaults as a contract kind; Q56 ADR-REPO-HELP#3 relaxed;
Q35 one primary language per track; Q22 the pwsh folder move; Q24 the contract pilot set; Q107 contracts as the only public API; Q108
contracts generated from ADRs; Q109 the ADR reading rule; Q118 the next structural change.

## The ten fundamental questions

### F1 Names
What changes for the repository when ADR-CATS rules cats and catzc: which folders, namespaces, executors, glossary terms and
CLAUDE.md lines change their name, and does pwsh versus powershell versus automation fall under the same rule?

### F2 The root entity
What changes for the repository when Track is the root and Module one of its kinds: the module model ADR, the resolver, variants.yml,
every head's track and module keys, and the two module-model prompts written on the old premise?

### F3 Plans as deltas, decisions as rules
What changes for the repository when a plan is only the delta and every constraining decision becomes an ADR rule in the same
change: which ADRs must be written from this round's decisions before any of them counts as decided?

### F4 The top-level tree
What changes for the repository's top-level folders: automation becomes pwsh, .unordered becomes an empty import landing zone, out/
gets six areas and sessions, .claude/plans is tracked and gated, body hashes leave authored pages?

### F5 Defaults and configuration
What changes for every typed config and every function when defaults live once on the type, this repo's choices live in a fragment
folder, a generated defaults contract publishes them, and an analyzer rule flags a literal default in a function?

### F6 The public API
What changes for the 439 public functions when a command is public exactly when a contract names it, the pilot set is proposed and
approved, and a contract may be generated from the ADR that defines it?

### F7 Materialization
What changes for caches, generated files and heads when a knowledge resource is either on-demand or committed under a key that is
the scoped sha of a deployable-module globset, with a loud fallback on a dirty tree?

### F8 Citations and vocabulary
What changes in how docs and code cite rules when a citation may sit inside a help sentence, the link review is a sample, every rule
line is bold, and the glossary gate reaches plans and prompts?

### F9 Sessions and robots
What changes in how a session works when robots are minimal with a model floor per capability, the ADR reading rule is cited rules
rather than whole ADRs, memory doctrine moves into rules or CLAUDE.md, and the user stays the only git actor?

### F10 The next structural change
What is the next structural change after the module model and the pwsh rename, and what does it change: the first import into the
landing zone, contracts beyond the pilot, a services track, or nothing until the pastes decide?

## Answers

Recorded in decisions-2026-10-16.md as F1 to F10, then condensed here into five, then two, then the end statement.
