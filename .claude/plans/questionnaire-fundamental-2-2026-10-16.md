---
plan:
  status: active
  kind: questionnaire
  reviewed: 2026-10-16
  funnel: 80 remaining items -> 40 resolved lines (planner) -> 5 for the user -> one undivided statement
---

# Fundamental questions, batch 2, 2026-10-16: the eighty remaining, rounded up

Batch 1 took twenty items to one statement. This batch takes the eighty not selected: the user delegated them to the planner, who answered
the 25 unasked ones from the sealed recommendations (decisions-2026-10-16.md, Batch 2), condensed all eighty into the forty resolved lines
below, and kept five that only the user can answer.

## The forty resolved lines (what the eighty items say once answered)

1. An import's history move is decided at the first import; the tool takes an optional -Ref; the how-to lives in docs/how-to.
2. A plan has a shape rule, not a line roof; it is authored in .claude/plans; done means deleted plus one index line.
3. File names are stable semantic locators repository-wide; the rank lives in the index and the head.
4. The plans gate comes first, the plan-clear agent acts on it; carried drafts stay until their data is in the tree; prompts are files.
5. The twenty finished plans in .unordered are deleted; the folder becomes the landing zone.
6. Variants: have_customers false, tracks required, aspects catch-all, shipped file deleted, defaults published as a contract kind.
7. Source mode reads this repo's own fragments only; a required key is a header comment; the assert ladder is a FAILFAST section.
8. Config-defaults Phase 1 waits for the module model; the fragment folder name waits for ADR-PRIN-CATS.
9. The user names the pwsh quiet window; no diagrams in the layers plan; the pilot contract list is proposed, not assumed.
10. Externally bound pipeline names are re-pointed the same day as P6; the prompts' dead paths are already re-pointed.
11. Languages are modelled generally and forbidden by the track; engines per track with a module override; the resolver is Get-CatzcModule.
12. LoadedModule is one rule of ADR-AUTO-MODULE, in the automation domain, under ADR-DSGN-TRACK; layout under languages.yml; a stray file is
    a finding.
13. Every vendored file lives in the vendor track; the .claude kits stay in the holder track; a track has one primary language by default.
14. Namespace is planned after kinds land; the module-model session owns the three protection-identity failures and the two shipped-type
    flags.
15. Layers P1 and lazy-types Phase 1 run beside the module model; everything that edits shared code waits.
16. The head contract schema stays hand-written; the reachability test gains the intended overlaps; visibility stays; generated heads stay
    minimal.
17. No glossary term for catzc_bundle; note becomes one; the asset kind is re-read against ADR-AUTO-ASSETDEP.
18. Prose may say PowerShell; identifiers use only pwsh or powershell; the formatting ADR decides the compiled folder.
19. In-use, untracked and peer-dirty files are out of plan scope; owners fix their own comment findings.
20. Class selectors go now; the file-head plan stays one plan.
21. The link ledger excludes .unordered; ADR-REPO-HELP-CITATIONINSENTENCE is relaxed; the review is sample-then-stop; Phase 2 thresholds are measured.
22. The TryParse regression test and the five gates on the usage code run now.
23. Per-engine cache stamps; the config-conventions and snapshot tests stay; EnforceTimings waits for the budget; slow files after two runs.
24. Materialization: scoped sha of a deployable-module globset, declared per kind, loud fallback, its own ADR written now.
25. out/: six areas, out/sessions, the safeguard log never pruned, only Clear-Output prunes.
26. The harvest is done (235 probes, 20 reruns, 5 tools); the backups are gone; probes go one approved batch at a time.
27. The comments format step: verify the loop, then add the step; a step may write the page; pages for our dot-folders, vendor excluded.
28. Lazy types: loader guard if no bypass; manifest committed with the DLL; Phase 1 now.
29. Bounded enumeration: the next session reruns the level-2 gate; the plan is deleted on green.
30. Unboxing P4 and P5 not now; no ADR-AUTO-CACHE statics line.
31. Carried links are re-pointed with the link tool; paste entries leave the index once recorded; memory notes are current.
32. Each session fixes the unowned findings it touches; plan files take the catzc head; the round files live until their rules exist.
33. The module-model prepare prompt is pasted first, after its rewrite on the Track-as-root premise.
34. Guards are controls becomes a rule the materialization ADR cites; every sibling-checkout idea is named where it is used.
35. Per-unit freezes, no repository-wide version; the time-safeguard limits stay tight and are tuned from the denial log.
36. The head is the generated marker, folders may mix; comment pages hold prose for C# too.
37. Render nothing unasked is a CLAUDE.md line and ADR-REPO-AI rule 13; every open step names its check, as a rule and a gate check.
38. The decision method is kept and encoded in the plan-decide robot; engine names are settled by layers P1.
39. ADR-REPO-PLANS cites reduce waste, poka-yoke and one living version.
40. Everything above has an ADR home in decisions-2026-10-16.md; a decision without one is reopened.

## The five for the user

### B1 INPUT pipelines

The flow ADR leaves open whether an INPUT pipeline's commit lands through a pull request or directly on trunk. No INPUT pipeline exists.
Options: a) keep open until one exists; b) directly on trunk; c) through a PR.

### B2 Azure leftovers

Two CAF ADRs leave decisions to the user: what the branch tag records on a devbox deploy, and a service connection per environment. Options:
a) leave both open until a deploy touches them; b) decide now (say which values).

### B3 ADR-PRIN-CATS domain

Options: a) principles (a design axiom); b) thesis (what catzc is for).

### B4 Two ADR homes to confirm

The repository-wide naming rule (stable locators, Q05) and the PowerShell naming rule (Q45) need a home each. Options: a) ADR-REPO-FOLDERS
for locators and ADR-REPO-VOCAB for the names; b) one new ADR-REPO-NAMING for both; c) say otherwise.

### B5 The first probe batch

235 probe scripts in out/ have a delete verdict; the first batch would be every probe family older than today's 14:57. Options: a) yes,
delete batch one; b) a smaller first batch (say which families); c) not yet.

## Answers (2026-10-16)

B1 keep open until an INPUT pipeline exists. B2 leave both Azure leftovers open until a deploy touches them. B3 ADR-PRIN-CATS lives in the
principles domain. B4 the stable-locators rule goes to ADR-REPO-FOLDERS, the PowerShell naming rule to ADR-REPO-VOCAB. B5 stays open: a
probe deletion batch needs a yes each time, and none was given.

## The end, undivided

catzc is one repository of typed tracks that own their kinds, named by one gated vocabulary, run as configuration over a contracted surface,
and changed only through rules, tests and configs that a session leaves behind: nothing parked, nothing unkeyed, nothing undecided without a
home.
