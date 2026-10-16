---
plan:
  status: active
  kind: decisions
  reviewed: 2026-10-16
---

# Decisions of the 2026-10-16 questionnaire round

One row per answer, in the order given. The question text is in questionnaire-2026-10-16.md. The planner's recommendation is shown with each
question from Q01 on (first option), so the Rec column records whether the user took it. Outcome is the projected effect of the decision in
two to ten words. Results move into the owning plans after the round.

| Q   | Decision                              | Rec taken | Outcome                                        | Note                                                       |
| --- | ------------------------------------- | --------- | ---------------------------------------------- | ---------------------------------------------------------- |
| Q01 | decide at first import                | yes       | import tool ships without a history-move pin   | the tool's contract does not depend on it                  |
| Q02 | optional -Ref, default branch default | yes       | one more parameter, one resolution order       | explicit wins                                              |
| Q03 | docs/how-to                           | yes       | one new how-to page on sorting                 |                                                            |
| Q04 | shape rule, no line roof              | yes       | Test-Plans checks sections, never a line count | head, value, decided, done, open steps; carried text below |
| Q05 | repository-wide naming rule too       | yes       | no rank prefixes anywhere in the tree          | ADR-REPO-PLANS plus a repository-domain naming rule        |
| Q06 | both, gate first                      | yes       | Test-Plans gate, then plan-cleaner agent       |                                                            |
| Q07 | author directly in .claude/plans      | yes       | Publish-Plan and Get-PlanCandidate dropped     | out/ holds no plan drafts                                  |
| Q08 | delete, index keeps one line          | yes       | index grows one line per finished plan         |                                                            |
| Q09 | delete all 20 .unordered plans now    | yes       | .unordered empty, ready as landing zone        | git keeps them; a deletion the user runs or approves       |
| Q10 | body-sha Phase 0 go now               | yes       | ADR edits stop being drift findings            | unblocks the link cleanup                                  |
| Q11 | keep carried drafts until landed      | yes       | plans stay long until data is in the tree      | cleaner trims per plan                                     |
| Q12 | prompts stay files                    | yes       | nine prompt files beside their plans           | header maps old out/ paths                                 |
| Q13 | have_customers default false          | yes       | shipped and code defaults agree                | repo fragment says all                                     |
| Q14 | tracks required, aspects catch-all    | yes       | a repo without tracks fails at construction    |                                                            |
| Q15 | shipped variants.yml deleted          | yes       | type plus fragment is the whole config         | general rule for a type with no file                       |
| Q16 | defaults as a fifth asset kind        | yes       | contracts/catzc gains generated defaults files | ADR-REPO-CONTRACT#6 amended                                |
| Q17 | source mode reads own fragments only  | yes       | no function shadowing in source mode           |                                                            |
| Q18 | reframed: two names, two audiences    | no        | alias idea dropped; folder question re-asked   | cats: friendly product form, root executor for bash and zsh, name for new and other-sourced modules, usable for pwsh in places; catzc: the inner repository namespace. Also answers part of Q105 |
| Q19 | required key in a header comment      | yes       | generated defaults never show a fake value     |                                                            |
| Q20 | Phase 1 after the module model        | yes       | config defaults waits entirely on module model | shared VariantsConfig.cs                                   |
| Q18b | new ADR-CATS decides it              | no        | a new principle-level ADR; folder names follow | cats and catzc, their distinction and cross-purpose use, are a core high-level product principle controlled by ADR-CATS; the overlay folder question waits for it; a new plan item |
| Q21 | section in ADR-AUTO-FAILFAST          | yes       | FAILFAST gains the five-rung ladder            |                                                            |
| Q22 | the user names the P4 window          | yes       | folder move only on a named time               |                                                            |
| Q23 | no diagrams in the layers plan        | yes       | P8 removed from the plan                       | render nothing unasked                                     |
| Q24 | session proposes the pilot list       | yes       | pilot set approved before the first contract   | cats entry point commands the likely answer                |
| Q25 | ci names re-pointed same day as P6    | yes       | no CI mismatch window                          | user re-points Azure DevOps and GitHub bindings            |
| Q26 | planner re-points prompt paths now    | yes       | prompts read clean in a fresh session          | a planner task after the round                             |
| Q27 | model languages generally             | yes       | language axis in the model, forbidden by track | ADR-AUTO-GO, PY, BASH unchanged                            |
| Q28 | engines per track, module override    | yes       | tracks.<t>.engines plus rare module overrides  |                                                            |
| Q29 | Get-CatzcModule                       | yes       | Get-BaseModule and Get-AutomationModules go    |                                                            |
| Q30 | LoadedModule in ADR-AUTO-MODULE       | yes       | one ADR page for the module model              |                                                            |
| Q31 | domain automation                     | yes       | docs/adr/automation/module-model.md or similar |                                                            |
| Q32 | layout under languages.yml            | yes       | slots beside formatter and checks per language |                                                            |
| Q33 | unplaced file is a finding            | yes       | a gate flags stray files in modules            |                                                            |
| Q34 | all vendored files in the vendor track | no       | no vendored file beside its user                | the session's candidate list is not needed                 |
| Q35 | kits stay; condition on front matter  | partly    | .claude kits stay in the holder track          | the user does not mind modules living in vendor folders as long as their front matter is processed and formatted; and a track has one primary language by default (a rule for ADR-DSGN-TRACK) |
| Q36 | namespace planned after kinds land    | no        | a follow-up item in the module-kinds plan      |                                                            |
| Q37 | module-model session looks first      | yes       | three failures owned by the module model work  |                                                            |
| Q38 | layers P1 beside the module model     | yes       | docs-only layers work starts now               | code phases wait                                           |
| Q39 | schema hand-written, no generator     | yes       | step 6 of the head draft dropped               | key-set test guards the schema                             |
| Q40 | not applicable                        | yes       | no registry shape work                         | follows Q39                                                |
| Q41 | write overlaps, strengthen the test   | yes       | a shadowed kind fails the kinds tests          | intended overlaps written in the test or registry          |
| Q42 | keep the visibility key               | no        | visibility stays in heads beside kinds         |                                                            |
| Q43 | generated heads stay minimal          | yes       | no folder or name on generated heads           |                                                            |
| Q44 | no glossary term for catzc_bundle     | yes       | glossary unchanged                             |                                                            |
| Q45 | prose PowerShell; ids pwsh or powershell | partly | one form per axis, written as a rule           | prose text may say PowerShell; identifiers use only pwsh (engine, folder) or powershell (language id) |
| Q46 | fix the module-types.yml typo now     | no        | one-word edit in a peer's file, user-approved  | planner touches no code; the next session does it with this approval |
| Q47 | read the formatting ADR, follow it    | yes       | .compiled handling decided by the ADR          |                                                            |
| Q48 | owners fix the six comment findings   | yes       | findings stay until owners act                 |                                                            |
| Q49 | out of scope: in-use files            | no        | plans drop every locked or in-use file item    | user: plans never concern themselves with locked or in-use files; that is for much later in the timeline. Saved as memory feedback. Q46 and Q48 are of the same kind and shrink to context lines |
| Q50 | class selectors go now                | yes       | globs spelled once; kinds select by class      |                                                            |
| Q51 | planner fixes the memory note         | yes       | file-head-vocabulary says immutable            | a planner task after the round                             |
| Q52 | one plan for the head                 | yes       | file-head plan stays whole                     |                                                            |
| Q53 | note becomes a glossary term          | no        | glossary gains note                            |                                                            |
| Q54 | re-read ADR-AUTO-ASSETDEP for asset   | yes       | asset kind confirmed or moved after a read     |                                                            |
| Q55 | exclude .unordered rows from ledger   | yes       | ledger shrinks by 274 rows                     | Q09 deletes those plans anyway                             |
| Q56 | relax ADR-REPO-HELP#3                 | yes       | in-sentence citations allowed; bare lines reported | explored: the sentence says which claim a code backs; the head stays the derived complete set; 0 edits |
| Q57 | sample-then-stop review               | yes       | about 400 rows reviewed instead of 4,500       | stop when the sample shows the pattern                     |
| Q58 | TryParse regression test now          | yes       | oversized rule number covered by a test        |                                                            |
| Q59 | five gates on the usage code now      | yes       | Get-AdrUsage and helpers gate-clean            |                                                            |
| Q60 | Phase 2 thresholds measured           | yes       | long is what the data says, no fixed count     |                                                            |
| Q61 | per-engine cache stamps               | yes       | a pin edit reformats one engine, not all       | invalidation test proves each declared input               |
| Q62 | config conventions test left, report-only | yes   | 0.77 s line stays a report                     |                                                            |
| Q63 | snapshot test left                    | yes       | 15 s test unchanged; scheduling is the lever   |                                                            |
| Q64 | slow files after two full runs        | yes       | test-optimization starts on the new balance    |                                                            |
| Q65 | report-only until under budget        | yes       | EnforceTimings on once the run is under 180 s  |                                                            |
| Q66 | scoped sha = deployable-module globs  | partly    | commit key reuses the globset patterns         | user: "scoped shas should basically be our deployable module glob patterns we can make config variants for"; the key's scope is a globset, variants configurable |
| Q67 | declared per resource kind, explicit pins | yes   | one config entry per kind, one default         |                                                            |
| Q68 | loud fallback on a dirty tree         | yes       | one announced line, never silent               |                                                            |
| Q69 | own ADR-AUTO-MATERIAL                 | yes       | a new ADR beside ADR-AUTO-CACHE                |                                                            |
| Q70 | write ADR-AUTO-MATERIAL now           | yes       | ADR, glossary, dora-explains entry, index      |                                                            |
| Q71 | accept the six out/ areas             | yes       | output-formats.yml gains the areas and numbers |                                                            |
| Q72 | out/sessions/<session>/               | yes       | session scratch named by session               |                                                            |
| Q73 | never prune time-safeguard.log        | yes       | the log keeps every denial                     | tuning evidence                                            |
| Q74 | only Clear-Output prunes              | yes       | the importer never deletes                     |                                                            |
| Q75 | Sonnet catzc-worker harvests scripts  | yes       | a verdict per unreferenced out/ script         | launched 2026-10-16 in the background; writes out/harvest-verdicts.md |
| Q76 | delete the 27 .bak files now          | yes       | out/ loses its backups; git has the files      | done 2026-10-16                                            |
| Q77 | a yes per batch for probe deletions   | yes       | each probe deletion batch is approved          |                                                            |
| Q78 | verify the step loop, then add        | yes       | comments step on top of the landed loop        |                                                            |
| Q79 | imprint step with one ADR sentence    | yes       | a step may write the page as a second file     |                                                            |
| Q80 | pages for ours, .vendor excluded      | yes       | .scriptanalyzer and .internal get comment pages |                                                           |
| Q81 | loader guard if no bypass             | yes       | deferred load via Import-ModuleFiles           | bypasses become eagerTypes config entries                  |
| Q82 | manifest committed with the DLL       | yes       | a bundle needs no compile                      |                                                            |
| Q83 | lazy types Phase 1 now                | yes       | metadata-only verification lands first         | independent of the module model                            |
| Q84 | next session reruns the level-2 gate  | yes       | tag fixes confirmed in the background          |                                                            |
| Q85 | delete the bounded plan on green      | yes       | one feature plan gone when its gate is green   |                                                            |

## Folded into the plans

- 2026-10-16: Q01 to Q57 folded (plan-plans-body-sha-landing-zone, plan-config-defaults, plan-layers-vocabulary-rename-contracts, plan-module-kinds-tracks, plan-file-head-immutable-edges-classes, plan-adr-link-cleanup-prose-to-pages, new plan-adr-cats). Q51 checked: the memory note's only "derived" is the English verb, not the old block name; nothing to fix.
