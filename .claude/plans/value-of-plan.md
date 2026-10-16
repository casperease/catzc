---
plan:
  status: active
  reviewed: 2026-10-16
  rule: value first, then needed docs and tests; job size never ranks
---

# Value of each plan

Every live plan, ordered by value. Job size is not a factor. The two things that order a plan are the value it delivers and how much
doctrine (ADRs, glossary, CLAUDE.md) and proof (gates, Pester tests) it needs before it counts as landed.

## Naming and sorting

A file name is a stable semantic locator: `plan-<topic>.md`, never a rank or order prefix. This table is the sorting overlay; each head's
`value` key carries the same signal. The delivered default sort of the folder is the semantic name order. The rule is to be written into
ADR-REPO-PLANS and the repository naming rules (see plan-plans-body-sha-landing-zone, Needed docs). Meta plans live here; feature plans stay
as drafts in `out/`. Done plans are deleted (the plans plan's rule).

## Intake rule for continuation prompts

Every item, idea or signal in a pasted continuation prompt lands in exactly one meta plan here. An item no plan covers gets a new plan at
the value it earns. What is reported done lands in that plan's "Done, and why" section with its reason, and stays until the whole plan is
done. Nothing in a paste is discarded; a stale or superseded item is recorded as such, with the reason.

## Meta plans by value (how the repository describes and governs itself)

| Value       | Plan                                    | Why                                                                                                                                          | Needed docs                                                                                                                | Needed tests                                                                                              | State                                                                           |
| ----------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| highest     | plan-plans-body-sha-landing-zone        | Removes the drift finding on every ADR edit, makes plans survive agent death, unblocks the link cleanup.                                     | ADR-REPO-PLANS new (incl. stable locators rule); FILEMETA#3 #7; DSGN-TRACK#17; 4 glossary terms; CLAUDE.md; sorting how-to | Test-Plans; body_sha on generated heads; import tool on two temp repos; Publish-Plan                      | nothing started                                                                 |
| high        | plan-minimal-robots                     | Every spawn re-reads 78 to 126 lines cold on an unnamed model; 20-line robots on haiku loading 10-line capabilities.                         | ADR-REPO-AGENTS rules 6-12; CLAUDE.md sentence; 3 glossary terms; capabilities.yml page                                    | Test-AgentDefinitions extensions on fixtures; CapabilitiesConfig; one real run per rewritten robot        | planned 2026-10-16; Q1-Q6 open; 2 paste-ins due                                 |
| high        | plan-minimal-robots-agents              | Catalogue: 2 proposed, 4 recommended, 7 rewritten robots with model and capabilities.                                                        | registry entries; CLAUDE.md lines                                                                                          | the gate; one real brief per robot                                                                        | planned; plan-clear text awaited                                                |
| high        | plan-minimal-robots-capabilities        | Catalogue: 2 proposed, 8 recommended, 4 reserved capabilities with floors.                                                                   | capabilities.yml; the ADR capabilities section                                                                             | the gate's capability checks                                                                              | planned; capability 2 text awaited                                              |
| high        | plan-config-defaults                    | An existing rule (AUTO-DEFAULT#6) is broken and two defaults disagree today.                                                                 | amend AUTO-DEFAULT#6, OVERLAY#1 #8, CONTRACT#6, CONF-LOADING; assert ladder                                                | VariantsConfig and five getters; overlay source-mode; defaults contract gate; audit of every typed config | decided; prompt written; Phase 2 waits on module model                          |
| high        | plan-layers-vocabulary-rename-contracts | Settles six words and names the public API.                                                                                                  | ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT new; glossary; ENGINE#4; four collisions                          | three terminology gates; guard rule; Test-Contracts; frozen P0 baseline                                   | Q1-Q11 decided; prompt written; waits on module model                           |
| high        | plan-module-kinds-tracks                | One Module replaces seven views; kind and role split; tracks typed.                                                                          | ADR-AUTO-MODULE new; DSGN-TRACK extended (one primary language per track); glossary                                        | resolver tests; file-kinds by track; processor counts; track-type L0                                      | Q-A to Q-G decided; prepare prompt next                                         |
| high        | plan-adr-cats                           | cats and catzc, two names, two audiences, cross-purpose on purpose: a core product principle; two plans wait on its folder and term rulings. | ADR-CATS new; glossary cats, catzc; CLAUDE.md terminology re-cited                                                         | Test-Glossary, Test-Terminology, Test-AdrRegistry, Test-Links                                             | opened 2026-10-16 from Q18b; domain open                                        |
| medium-high | plan-file-head-immutable-edges-classes  | Head shape settled; globs still spelled seven times; registry, formatting and path-split records with leftovers.                             | CODEMETA#2 note; naming rule PowerShell versus pwsh and powershell; note as a term                                         | selector tests; five gates on the registry work; strengthened reachability test                           | immutable and edges done; schema stays hand-written (Q39); classes go now (Q50) |
| medium      | plan-adr-link-cleanup-prose-to-pages    | Hygiene now, readable sources later.                                                                                                         | HELP#3 decision                                                                                                            | TryParse regression; five gates on usage code                                                             | paused on the plans plan                                                        |
| medium      | plan-test-run-budget                    | 266 s against a 180 s roof; cache stamp needs an ADR decision.                                                                               | REPO-FORMAT stamp rule                                                                                                     | warm-cache and invalidation tests; two runs                                                               | two levers landed                                                               |
| medium      | plan-materialization-of-knowledge       | One word and one default for cache versus commit, which several plans lean on.                                                               | ADR-AUTO-MATERIAL new; glossary; sha-marker plan                                                                           | registry, glossary, link gates; resolver tests later                                                      | draft; 3 choices to confirm                                                     |
| medium      | plan-out-artifacts                      | 144 session scripts and 27 backups unregistered.                                                                                             | OUTDIR amendments                                                                                                          | Clear-Output and prune tests                                                                              | 4 decisions open                                                                |
| low-medium  | plan-format-step-moves-comments         | One long header survives a format run; verify the step loop first.                                                                           | one ADR sentence; comments.yml entries                                                                                     | Format-Code step test                                                                                     | unverified since 2026-10-15                                                     |

## Feature plans (a capability of cats), here with class: feature in the head

| Value       | Plan                            | Needed docs                                 | Needed tests                                                         | State                               |
| ----------- | ------------------------------- | ------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------- |
| medium-high | plan-lazy-types-load            | native-csharp-types ADR rule; comment pages | types-load.yml policy L0; Test-TypesAssemblyContent on a fixture DLL | Phase 0 done                        |
| medium      | plan-bounded-folder-enumeration | none left; ADR-PWSH-ENUM exists             | the user's level-2 gate run                                          | built and migrated; delete on green |
| low-medium  | plan-unboxing                   | optional ADR-AUTO-CACHE line                | one DLL in .compiled; Test-ShippedTypes re-run                       | P1-P3 shipped; P4, P5 on a go       |

## Where the data lives now (absorbed 2026-10-16)

Every draft plan, ADR draft, analysis and continuation prompt that was in out/ is now in this folder: a draft is carried verbatim under a
"Carried" heading of its meta plan, a continuation prompt is a `prompt-<topic>-continue.md` or `prompt-<topic>-<n>-<step>.md` file beside
its plan, and reference-unboxing.md sits beside plan-unboxing. out/ holds README.md, session scripts, logs, backups and run folders only;
plan-out-artifacts carries the harvest inventory (what a plan names and keeps, what is unsorted). Two things the cleaner fixes next:

- Carried text still says `out/plan-x.md` where it means a sibling here, and its relative links (`../docs/...`) were written from out/, so
  from this folder they resolve one level wrong. Re-point them with the link tool, one file at a time, never by sweep.
- The carried files are far over the 150-line roof the plans plan proposes. The roof is a setting; the cleaner shortens a plan only after
  its data is in the tree (an ADR, a test, a config), never by dropping a signal.

## Deleted 2026-10-16 (user's yes), and why

- 14 done plan drafts: head-path-split, adrs-in-code-head, file-kinds-registry, file-kinds-and-formatting (records of landed work);
  help-to-frontmatter, adrs-in-front-matter, help-registry-options (725 function heads carry synopsis keys, 2 .PARAMETER left);
  markdown-meta, code-file-meta, title-migration, meta-probes, meta-impl-prompt (Format-FileMeta replaced Format-MarkdownMeta, heads carry
  path); unboxing, unboxing-findings (steps done, commit left to the user).
- 4 handoffs and 2 continuation prompts from 2026-10-15 (landed heads and markerless work), analysis-boxing (unboxing evidence), 6 survey
  files (the layers worklist carries what they held, as the layers plan states).
- Later the same day, after absorption into this folder: the 16 remaining draft plans, 3 ADR drafts and analyses (h.md among them), and
  every prompt moved here rather than deleted. Correction found while absorbing: unboxing is not done (P4 and P5 wait for a go), so it has
  plan-unboxing; bounded enumeration is further along than its memory note said (everything built, only the gate run left).

## Decision round 2026-10-16

- questionnaire-2026-10-16.md (126 items) and decisions-2026-10-16.md (the record, with Outcome and ADR home per row). Q01 to Q101 answered
  and folded. Then the funnel in questionnaire-fundamental-2026-10-16.md: twenty items of highest interest distilled into ten "what changes
  for the repository" questions (F1 to F10), then five (S1 to S5), then two (T1 what it is, T2 how it changes), then one end statement of
  what the repository becomes, destined for the thesis domain. The about eighty items not selected (Q102 to Q126 unasked among them) are the
  next batch, run through the same funnel. New from the round: plan-adr-cats (Q18b); the rule that a track has one primary language (Q35);
  in-use files are out of scope for plans (Q49, saved as memory feedback). The planner's method is now the plan-intake and plan-decide
  robots with the plan-intake, plan-decide and plan-value capabilities (plan-minimal-robots-agents).

## Pastes processed

- 2026-10-16 15:35, materialization: the draft's parts, why it was not promoted (adrs.yml, glossary, dora-explains entry, regenerated index;
  no unconfirmed rule recorded), the three choices as the session's own recommendations, no gates run, memory saved. Landed in
  plan-materialization-of-knowledge; the three choices stay open.

- 2026-10-16 15:35, config defaults: Q1 to Q7 are recommendations taken as decisions (the user did not restate them; confirm or change is
  asked), the draft's rewrite, the amended .unordered contracts plan row, cross-plan notes, the dirty Get-Track files, Phase 1 can start.
  Landed in plan-config-defaults.

- 2026-10-16 15:33, bounded folder enumeration: three bad ADR test tags fixed, the level-2 gate not rerun so unconfirmed, the lesson that a
  test citation names a real rule in ADR-<CODE>#<n> form, the prompt's rules, and the old draft wording left as is. Landed in
  plan-bounded-folder-enumeration (its prompt and the gate section were already here).

- 2026-10-16 15:03, immutable and edges: the move done and re-imprinted (verified: 0 derived heads, 1,722 immutable), glossary terms place
  facts and edge, rule 13 reworded, nine findings gone by another session's hand, one "full suite" finding left in the unboxing article, and
  the contract schema generator not built with its two reasons and the $comment decision for the user. Landed in
  plan-file-head-immutable-edges-classes and plan-unboxing.

- 2026-10-16 15:14, tracks, track types and vendors: ADR-DSGN-TRACKTYPE and the code landed (verified: seven rules, VariantTrack with
  places, type, vendor), the WorldMapBuilder link fix, four peer gate findings, the stale head.schema.json, two user choices. Landed in
  plan-module-kinds-tracks (track model done, choices open), plan-unboxing (findings in its article and TypeShape.cs) and
  plan-file-head-immutable-edges-classes (file-meta.md lint, stale contract). Its carried track-type draft is now marked superseded.

- 2026-10-16 15:22, unboxing: P1 to P3 done, the commit step (Clear-ModuleTypeCache, one DLL), the five-file test scope, the
  Test-ShippedTypes flag, the optional ADR line, P4 and P5 unplanned until a go. Landed in plan-unboxing, together with findings F1 to F7
  recovered from the deleted findings file (F8 and F9 were not read before deletion and are lost from this folder; the shipped article and
  reference-unboxing.md beside the plan are where to look).

- 2026-10-16 15:22 (arrived after the deletion round), head path split: three changes done and tested (module-type ids, catzc_bundle key,
  path split into folder, name, filetype), four optional leftovers (spelling gate and coined word, the user's gate runs, whether generated
  heads carry folder and name, a glossary entry) and a prompt. Landed in plan-file-head-immutable-edges-classes and
  prompt-head-path-split-continue.md. Its out/ plan had been deleted on the approved list; its leftovers are restored here.

- 2026-10-16 15:22 (arrived after the deletion round), file kinds and formatting follow-up: formatter crash fix and its analyzer rule,
  help-text outputs, cleared peer findings, five kind changes and the reachability test as done; five leftovers (Test-Formatting and the
  .compiled question, six Test-Comments findings in peers' files, the untracked page, the reachability gap decision, the visibility key) and
  a prompt cut mid-sentence. Landed in plan-file-head-immutable-edges-classes and prompt-file-kinds-and-formatting-continue.md. Its out/
  plan had been deleted on the approved list as a record of landed work; its open items are restored here.

- 2026-10-16 15:23 (arrived after absorption), ADR links and plans: done list, not-done list, the untrimmed-plans note, the continuation
  prompt and three open decisions. Everything but five details was already carried; the details (GroupBy, ledger columns, the narrow fixes
  at lines 62 and 63, the Test-Formatting failure's origin, the paste-after-clear line) landed in plan-adr-link-cleanup-prose-to-pages; the
  prompt file got a header re-pointing its out/ plan names. The three decisions stay open.

- 2026-10-16 15:22 (arrived after the deletion round), file-kinds registry: the done list, four leftovers (five gates to run, the
  PowerShell/Powershell question for the user, the module-types.yml typo in a peer's file, one derived mention in a memory note) and a
  continuation prompt. Landed in plan-file-head-immutable-edges-classes and prompt-file-kinds-registry-continue.md. The out/ plan it names
  had been deleted on the approved list as "record of landed work"; its open items were under-read then and are restored here.

- 2026-10-16 15:31, layers series: decisions Q1-Q11 recorded, continuation prompt out/prompt-automation-layers-continue.md, sequencing notes
  in the module-model and k8s plans. Landed in plan-layers-vocabulary-rename-contracts, plan-module-kinds-tracks and plan-config-defaults.
  Also picked up from disk the same minute: out/prompt-config-defaults-continue.md and out/adr-draft-materialization.md (new
  plan-materialization-of-knowledge).

## Refs

- Every plan and prompt named above is a sibling file in this folder.
- out/ scripts kept as scripts: build-adr-link-ledger.ps1, prepass-adr-link-ledger.ps1, refresh-ledger.ps1, apply-verdicts.ps1,
  adr-link-ledger.csv, analysis-adr-link-ledger.txt (link cleanup); bench-unboxing.ps1, bench-unboxing.cs, bench-unboxing.log,
  run-unboxing-tests.ps1 (unboxing). They are regenerable or measured output, not plan data.
