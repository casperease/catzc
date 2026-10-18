---
plan:
  status: active
  reviewed: 2026-10-17
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

| Value       | Plan                                    | Why                                                                                                                                          | Needed docs                                                                                                                | Needed tests                                                                                      | State                                                                           |
| ----------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| highest     | plan-master                             | The one executable order over every open step of every plan; task files are its disposable executables.                                      | ADR-REPO-PLANS names the task files (the plans ADR)                                                                        | Test-Plans over the folder (the plans ADR)                                                        | every chunk a task file; folder hygiene done                                    |
| highest     | plan-plans-body-sha-landing-zone        | Removes the drift finding on every ADR edit, makes plans survive agent death, unblocks the link cleanup.                                     | ADR-REPO-PLANS new (incl. stable locators rule); FILEMETA#3 #7; DSGN-TRACK#17; 4 glossary terms; CLAUDE.md; sorting how-to | Test-Plans; body_sha on generated heads; import tool on two temp repos; Publish-Plan              | Phase 0 done; Phases 1 and 2 open                                               |
| high        | plan-layers-vocabulary-rename-contracts | Settles six words and names the public API.                                                                                                  | ADR-AUTO-LAYERS, ADR-AUTO-IMPORTER, ADR-REPO-CMDCONTRACT new; glossary; ENGINE#4; four collisions                          | three terminology gates; guard rule; Test-Contracts; frozen P0 baseline                           | Q1-Q11 decided; prompt written; waits on module model                           |
| high        | plan-module-model-closeout              | The model landed with open choices, a rule without code and stale pages; the close-out keeps them from being lost.                           | ADR-AUTO-MODULE rule 6 or its narrowing; Catzc.Base.Modules reference page                                                 | Copy-Automation test; Test-AdrRegistry; Test-Links, Test-Comments                                 | open: user confirms choices                                                     |
| high        | plan-diagram-folders                    | A diagram's nine files sit in five places under two names; one folder per diagram makes it movable and rebuildable as one thing.             | ADR-REPO-FOLDERS `.assets` paragraph; ADR-REPO-SLIDES#7; file-kinds.yml                                                    | Build-Diagrams L0; kit subtitle and lens checks; Test-Links per moved folder                      | decided 2026-10-18; kit step next, pilot configuration/                         |
| medium      | plan-assets-beside-articles             | An article and its diagram description live in two trees today; 641 links reach across.                                                      | conventional-folders ADR; add-a-doc-chapter how-to                                                                         | Test-Links; Test-FileMeta; drawio_forward rebuild of the pilot slide                              | planned; pilot next                                                             |
| high        | plan-adr-ai                             | Bounds what every agent spends its calls on before any brief: tests postponed, no agent git, cheap verification.                             | register ADR-AI in adrs.yml and the index; fold agent-contracts.md into its Context                                        | Test-AdrRegistry, Test-Links on the ADR; Test-AgentDefinitions reads the contract from agents.yml | ADR written, named once (Q140); registration open                               |
| high        | plan-adr-cats                           | cats and catzc, two names, two audiences, cross-purpose on purpose: a core product principle; two plans wait on its folder and term rulings. | ADR-CATS new; glossary cats, catzc; CLAUDE.md terminology re-cited                                                         | Test-Glossary, Test-Terminology, Test-AdrRegistry, Test-Links                                     | opened 2026-10-16 from Q18b; domain open                                        |
| high        | plan-explanation-drift-gaps             | CD deploys the prod tier with no gate today (Q3), and the ADRs promise deploy-path, run-mode and safeguard behaviour the code lacks.         | six ADR amendments (RUNMODE, FAILFAST, TRACK, PATH, AZ-NAMING, AZ-CLI); the articles' drift sections                       | L0 for the fixed functions, the new sync command and Resolve-RepoPath; the hook's L2 deny         | 5 open: Q1/Q2 pipelines, the approval sync run, the Get-Aspect move, slides     |
| high        | plan-promotion-ladder                   | The ADRs' ladder (main-uat, release-uat, RC/RBC, pre-prod, DEPLOY) has no code; prod waits only on the new approval check.                   | ADR-DSGN-LIFE, ADR-FLOW-CD as the answers decide                                                                           | per pipeline, a run that shows the rung                                                           | blocked on Q1-Q4                                                                |
| medium-high | plan-file-head-immutable-edges-classes  | Head shape settled; globs still spelled seven times; registry, formatting and path-split records with leftovers.                             | CODEMETA#2 note; naming rule PowerShell versus pwsh and powershell; note as a term                                         | selector tests; five gates on the registry work; strengthened reachability test                   | immutable and edges done; schema stays hand-written (Q39); classes go now (Q50) |
| medium      | plan-adr-link-cleanup-prose-to-pages    | Hygiene now, readable sources later.                                                                                                         | HELP#3 decision                                                                                                            | TryParse regression; five gates on usage code                                                     | paused on the plans plan                                                        |
| medium      | plan-test-run-budget                    | 266 s against a 180 s roof; cache stamp needs an ADR decision.                                                                               | REPO-FORMAT stamp rule                                                                                                     | warm-cache and invalidation tests; two runs                                                       | two levers landed                                                               |
| medium      | plan-out-artifacts                      | 144 session scripts and 27 backups unregistered.                                                                                             | OUTDIR amendments                                                                                                          | Clear-Output and prune tests                                                                      | landed; two probe batches wait on the user                                      |
| medium      | plan-clear-actions                      | The cleaner's open verdicts: three trims of held plans, superseded prompts, the bounded-enumeration delete.                                  | none                                                                                                                       | Test-Links per file                                                                               | 2026-10-18 cleanup done; held-file trims and prompt deletions open              |
| medium      | plan-fast-push-followups                | Four Build-RootConfig fixture-head tests fail and two unrelated findings have no owner yet.                                                  | none; ADR-DSGN-LIFE#11 and #12 landed                                                                                      | Build-RootConfig.Tests.ps1 green; Test-AdrRegistry; one real Push-Dirty run (the user's)          | landed and tested; four steps open                                              |
| low         | plan-assets-gallery-pdf                 | One review PDF of every asset PNG with its companion text; the split flag is D07.                                                            | the drawio-waves skill line names --assets                                                                                 | a two-PNG fixture run if the kit gains a test home                                                | mode landed and measured; three steps open                                      |

## Feature plans (a capability of cats), here with class: feature in the head

| Value      | Plan                            | Needed docs                               | Needed tests                                                       | State                               |
| ---------- | ------------------------------- | ----------------------------------------- | ------------------------------------------------------------------ | ----------------------------------- |
| medium     | plan-assert-wait                | FAILFAST#8, ASSERT#7 after a measured run | Assert-Wait.Tests; TimeoutsConfig wait keys; Test-Automation.Tests | points landed; config, ADRs open    |
| medium     | plan-bounded-folder-enumeration | none left; ADR-PWSH-ENUM exists           | the user's level-2 gate run                                        | built and migrated; delete on green |
| low-medium | plan-unboxing                   | optional ADR-AUTO-CACHE line              | one DLL in .compiled; Test-ShippedTypes re-run                     | P1-P3 shipped; P4, P5 on a go       |

## Where the data lives now (absorbed 2026-10-16)

Every draft plan, ADR draft, analysis and continuation prompt that was in out/ is now in this folder: a draft is carried verbatim under a
"Carried" heading of its meta plan, a continuation prompt is a `prompt-<topic>-continue.md` or `prompt-<topic>-<n>-<step>.md` file beside
its plan, and reference-unboxing.md sits at docs/explanation/automation/. out/ holds README.md, session scripts, logs, backups and run
folders only; plan-out-artifacts carries the harvest inventory (what a plan names and keeps, what is unsorted). Two things the cleaner fixes
next:

- Carried text still says `out/plan-x.md` where it means a sibling here, and its relative links (`../docs/...`) were written from out/, so
  from this folder they resolve one level wrong. Re-point them with the link tool, one file at a time, never by sweep.
- The carried files are far over the 150-line roof the plans plan proposes. The roof is a setting; the cleaner shortens a plan only after
  its data is in the tree (an ADR, a test, a config), never by dropping a signal.

## Deleted 2026-10-18, and why

- plan-config-defaults: every phase landed (defaults on the types and shown in the shipped files, held together by the defaults check in
  Test-ShippedConfigs; every config type in a posture; the NoLiteralDefault rule; ADR-AUTO-DEFAULT#6, ADR-AUTO-OVERLAY#1 and #8, the assert
  ladder, the glossary terms posture and config fragment). No open step. Its task files go with it: task-config-defaults-variants,
  task-config-defaults-fragment and task-config-defaults-postures.
- task-kind-becomes-role: every step landed (the head key role, D29 the namespace); its plan, plan-module-kinds-tracks, keeps its one open
  design step, the infrastructure track.
- plan-module-kinds-tracks: every step landed (the module model and ADR-AUTO-MODULE, the infrastructure track read in step 10, kind to role,
  one primary language per track, the namespace by D29). Its two left-open choices were decided by Q34 and Q35 (every vendored file in the
  vendor track; the .claude kits stay in their holder track), and the stale head.schema.json contract is owned by
  plan-file-head-immutable-edges-classes. No open step.

- plan-csproj-xml-head: both steps landed (the XML property head is described on its page and in the two help pages; the four
  Build-RootConfig fixture tests pass on the tree). No open step.
- plan-lazy-types-load and its task: Phases 0 to 5 landed and ADR-AUTO-TYPES#16 holds the lazy load and its default-declaration exception.
  Two facts it carried stay unproven and are not steps: `shadowCopy: false` on Unix is built but its janitor and drift-guard assumptions are
  unconfirmed on Unix, and the manifest beside the DLL could feed `Test-TypesAssemblyContent` instead of the DLL. No open step.
- plan-file-meta-head-policy: landed in one tree-wide pass (12:29–12:33, `out/one-pass.log`); ADR-REPO-FILEMETA#1 (the head policy) and #14
  (no read-back), ADR-REPO-HELP (help on the comment page) and ADR-REPO-COMMENTS#6 (an authored page) hold every decision, and
  `Sync-FileMeta` is the single-file tool. The explanation is docs/explanation/file-meta.md. A `Get-Help` provider that reads the page is an
  idea, not a step. No open step.
- plan-materialization-of-knowledge and its task: ADR-AUTO-MATERIAL holds the decided axis in seven rules, registered, with its
  dora-explains entry and the glossary term `materialization`; no sha-marker companion exists to align with. No open step.
- The decision round task: D01 to D20 answered, every recommendation taken; the record is decisions-2026-10-18.md and the questionnaire,
  folded into the owning plans the same day.
- plan-idle-compaction and its task: D06 keeps `idleCompaction: false` in the gitignored local settings, a per-person preference; nothing is
  left to do.
- plan-skip-unchanged-generators and its task: every janitor is wired with its inputs proven, bounded or recorded as not skippable (D12);
  the ten janitors measure 1.2 s on their first call and 0.4 s warm against the 2.6 s the plan started from.
- The assets leftovers task: landed 2026-10-17 and D07 settled the last step (no `--parts` flag); plan-assets-gallery-pdf keeps its one
  fixture line, which waits on a test home.

## Deleted 2026-10-17, and why

- plan-format-step-moves-comments and its task (closed by session catzc-6c): the step loop and the page entries for `.scriptanalyzer` and
  `.internal` were already in the tree, `.vendor` sits outside every pages source, both ADR sentences exist; two stale sections of the
  `.internal` pages deleted, `Test-Comments` 0 on both folders (`out/test-comments/20261017-202304`), `Export-Comments -DryRun` nothing to
  move in 70 files, CommentsConfig and New-Importer tests pass. No open step.
- plan-assets-beside-articles: the move landed, the gallery reads the sidecar carrier for its descriptions, the carrier test passes as it
  stands, and the old `docs/.assets/explanation` folder is gone. No open step (the assets leftovers task).
- plan-adr-ai: ADR-AI is written, registered and named once (agents.yml `contracts`, the CLAUDE.md line); the agent-contracts page is folded
  into its Context; D14 kept the one-segment code. No open step.
- plan-adr-cats: ADR-CATS with five rules in principles, the glossary terms cats and catzc, the decisions told to the two plans that waited.
  No open step.
- prompt-file-kinds-and-formatting-continue, prompt-file-kinds-registry-continue, prompt-head-path-split-continue: continuation prompts of
  plans deleted on 2026-10-16; every item they named is a step of plan-file-head-immutable-edges-classes or done.
- The done task files of folder hygiene, ADR-AI, ADR-CATS, body-sha Phase 0, the .unordered audit, the plans ADR, minimal robots, layers
  doctrine and class selectors: disposable executables (ADR-REPO-PLANS#8); their verdict lines live in the plans they ticked and in git.
- plan-minimal-robots, plan-minimal-robots-agents, plan-minimal-robots-capabilities: the program landed (15 robots, 18 capabilities,
  ADR-REPO-AGENTS rules 6 to 10, the gate), and Phase 5 is measured in the program plan's own table (static context per robot from its
  files; no robot over 4,000 tokens). The three files are listed for the user's `git rm`; until then they hold no open step of their own.

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
- The next funnel batch is Q102 to Q126 plus the D-items D01 to D16 of the decision round of plan-master.

## Pastes processed

- 2026-10-16 15:35, materialization: the draft's parts, why it was not promoted (adrs.yml, glossary, dora-explains entry, regenerated index;
  no unconfirmed rule recorded), the three choices as the session's own recommendations, no gates run, memory saved. Landed in
  plan-materialization-of-knowledge; the three choices stay open.

- 2026-10-16 15:35, config defaults: Q1 to Q7 are recommendations taken as decisions (the user did not restate them; confirm or change is
  asked), the draft's rewrite, the amended .unordered contracts plan row, cross-plan notes, the dirty Get-Track files, Phase 1 can start.
  Landed in plan-config-defaults.

- 2026-10-16 15:33, bounded folder enumeration: three bad ADR test tags fixed, the level-2 gate not rerun so unconfirmed, the lesson that a
  test citation names a real rule in `ADR-<CODE>#<n>` form, the prompt's rules, and the old draft wording left as is. Landed in
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
  docs/explanation/automation/reference-unboxing.md are where to look).

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

- 2026-10-16 15:31, layers series: decisions Q1-Q11 recorded, continuation prompt prompt-automation-layers-continue.md, sequencing notes in
  the module-model and k8s plans. Landed in plan-layers-vocabulary-rename-contracts, plan-module-kinds-tracks and plan-config-defaults. Also
  picked up from disk the same minute: prompt-config-defaults-continue.md and adr-draft-materialization.md (now carried in
  plan-materialization-of-knowledge; new plan-materialization-of-knowledge).

## Refs

- Every plan and prompt named above is a sibling file in this folder.
- out/ scripts kept as scripts: build-adr-link-ledger.ps1, prepass-adr-link-ledger.ps1, refresh-ledger.ps1, apply-verdicts.ps1,
  adr-link-ledger.csv, analysis-adr-link-ledger.txt (link cleanup); bench-unboxing.ps1, bench-unboxing.cs, bench-unboxing.log,
  run-unboxing-tests.ps1 (unboxing). They are regenerable or measured output, not plan data.
