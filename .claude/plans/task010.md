---
task:
  id: "010"
  status: "done except the landing-zone clause of step 9, which follows task009"
  plans: [plan-plans-body-sha-landing-zone, plan-file-head-immutable-edges-classes, plan-master]
  value: highest
  blocked_on: "task009 (the terms) for one CLAUDE.md clause; everything else is in the tree"
  targets:
    [
      docs/adr/repository,
      automation/Catzc.Base.QualityGates,
      automation/Catzc.Base.Languages/configs/languages.yml,
      automation/Catzc.Base.Docs/configs/agents.yml,
      automation/Catzc.Base.Docs/configs/adrs.yml,
      .claude/CLAUDE.md,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task010.md"
    folder: plans
    name: task010
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-PRIN-NOWASTE#1
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-FOLDERS#12
      - ADR-REPO-PLANS#{5,8}
      - ADR-REPO-SLIDES#5
      - ADR-REPO-VOCAB#9
---

# task010: ADR-REPO-PLANS, the Test-Plans gate, the naming rules, CLAUDE.md

Phase 2 of the plans plan. Decided: Q04 a shape rule and no line roof; Q05 stable locators repository-wide (ADR-REPO-FOLDERS) and the
PowerShell naming rule in ADR-REPO-VOCAB (Q45); Q06 gate first, then the cleaner (plan-clear exists); Q07 plans authored in .claude/plans;
Q08 a done plan is deleted and the index keeps one line; Q49 plans never concern in-use files; Q12 continuation prompts stay beside their
plans. The master plan and the task files of this folder are named in the ADR as derived executables so the gate accepts them.

## Done (2026-10-17), with the corrections the tree forced and each check's verdict

- Step 1: `docs/adr/repository/plans.md`, nine rules, Context, Decision, Consequences. Correction: rule 4 does not forbid inline links in
  a plan's body; the plans carry them and Test-Links checks them, so the clause would have written a rule the folder breaks on purpose.
  The file is untracked, so its head has no body sha until it is committed and formatted. Checks: `[Write-QualityGateReport] No
  markdownlint issues found.` (`out/test-markdownlint/20261017-174412`), `No links issues found.` (`out/test-links/20261017-174649`).
- Steps 2 and 3: ADR-REPO-FOLDERS#12 (stable locator) and ADR-REPO-VOCAB#9 (PowerShell, pwsh, powershell), each with a prose section.
  Checks: markdownlint clean on both (`out/test-markdownlint/20261017-174648`); `No terminology issues found.`
  (`out/test-terminology/20261017-174414`); Test-AdrRegistry's one finding is a peer's new `ADR-REPO-SLIDES#5` citing a thesis rule
  (`docs/adr/repository/slides-as-markdown.md:79`), not this task's (`out/test-adr-registry/20261017-174641`).
- Step 4: `plans: { external: ADR-REPO-PLANS }` registered; `Build-AdrIndex` lists it at index line 334.
- Step 5: the "Plans" entry in the repository dora-explains (small batches, work visibility, maintainability); the file is now also a
  peer's, edited after mine, so it was link-checked (clean) and not re-stamped.
- Step 6: `Test-Plans.ps1`, `configs/plans.yml`, `types/PlansConfig.cs` (every default once), registered in configs.yml; L0 tests for the
  type and the gate on TestDrive fixtures with neutral names. Corrections: the gate checks the required sections (Open steps) and does
  not enforce a section order, since the plans order their decided and done sections freely around the open steps; the status set is
  `active`, `blocked`, so five plans that said `open` now say `active` (one, idle-compaction, `blocked`, which it is). Checks:
  `[Invoke-TestFile] Passed (snapshot)` PlansConfig.Tests (`out/test-file/20261017-174648-e34e5f`), `Passed (snapshot)` Test-Plans.Tests
  (`out/test-file/20261017-174648-fd8283`), `No shipped-configs issues found.` (`out/test-shipped-configs/20261017-174412`),
  `No script-analyzer issues found.` (`out/test-script-analyzer/20261017-174652`), `No comments issues found.`
  (`out/test-comments/20261017-174647`). On the real folder, after its fixes: `[Write-QualityGateReport] No plans issues found.`
  (`out/test-plans/20261017-174646`). The first run found ten: six open steps without a check (assert-wait, clear-actions x2,
  lazy-types x2, test-run-budget), two task heads with an unquoted colon in a value (task005, task017), each fixed in its file; five
  plans had a target path that did not exist (two named the future `.catzc/`, one the wrong module for comments.yml, one the wrong module
  for output-formats.yml, one a planned folder), fixed to existing paths; four plans had their steps under `## Steps` or `## Open`, now
  `## Open steps`; the two robot catalogues gained an Open steps section pointing at their T013 deletion; the vocabulary list in
  plan-clear-actions became one step with the files as prose.
- Step 7: `languages.yml` markdown checks gain `Test-Plans`. Check: `[Invoke-TestFile] Passed` LanguagesConfig.Tests
  (`out/test-file/20261017-174412-*`).
- Step 8: plan-clear `supported_by: [ADR-REPO-PLANS#5, ...]`, `checks: [Test-Links, Test-Plans]`. Check: `No agent-definitions issues
  found.` (`out/test-agent-definitions/20261017-174412`).
- Step 9: the CLAUDE.md plans bullet says plans are authored in `.claude/plans/plan-<topic>.md`, the master and task files are derived
  and a done plan is deleted; the landing-zone clause waits for T009. Check: `No links issues found.` (`out/test-links/20261017-174412`).
- Step 10: body-sha plan Phase 2 ticked, file-head plan Q45 step ticked, plan-master cites ADR-REPO-PLANS#8 and ADR-REPO-FOLDERS#12.
  Check: Test-Links clean on the twenty edited plan files (`out/test-links/20261017-174651`).

## Steps, as planned

1. `docs/adr/repository/plans.md`, new, `# ADR-REPO-PLANS: plans that stay true`. Rules, each bolded:
   - 1 one topic per file, `.claude/plans/plan-<topic>.md`; a **plan** is the delta only (what is open), authored directly there.
   - 2 the head carries `plan:` with status, value, reviewed, targets; blocked_on or waits_on when blocked; value is one of the ranks
     `value-of-plan.md` orders by.
   - 3 the shape: head, why its value, decided, done and why, open steps, refs; carried text below a "Carried" heading; no line roof.
   - 4 an **open step** is a checkbox that names the check proving it; present tense; no inline links in the body, targets in refs.
   - 5 a plan with no open step is deleted and `value-of-plan.md` keeps one "deleted, why" line; git keeps the text.
   - 6 a plan never plans or asks about an in-use, untracked or peer-dirty file; one context line at most.
   - 7 a **continuation prompt** is `prompt-<topic>-continue.md` beside its plan, verbatim, with a header mapping dead paths.
   - 8 the **master plan** (`plan-master.md`) and the **task files** (`taskNNN.md`, at most 050) are derived executables rebuilt from the
     plans; a task number is execution order, the one place a name carries one; they are cleared and rebuilt, never the plans.
   - 9 every constraining decision in a plan becomes an ADR rule in the same change; a homeless decision is reopened (F3). Context,
     Decision, Consequences (the cleaner plan-clear and the gate Test-Plans enforce; names only). Check: Test-Markdownlint, Test-Links
     clean; Format-FileMeta writes `defines: ADR-REPO-PLANS#{1-9}`.
2. `docs/adr/repository/conventional-folders.md`: one rule, **stable locator**: a file name never encodes an order, rank or priority;
   sorting is an overlay, an index or a head key; the delivered default sort is the semantic name order; the exception is a file whose name
   is an execution order by its ADR (ADR-REPO-PLANS#8). Check: Test-AdrRegistry; the rule number is the next free one.
3. `docs/adr/repository/controlled-vocabulary.md`: one rule, the PowerShell naming rule: prose says PowerShell; identifiers use only `pwsh`
   (engine, folder) or `powershell` (language id); the one literal Powershell in vendored dotnet-install.ps1 is vendor text. Check:
   Test-AdrRegistry; Test-Terminology on the file.
4. `adrs.yml` repository rulesets: `plans: { external: ADR-REPO-PLANS }`. `Build-AdrIndex`. Check: Test-AdrRegistry clean; the index lists
   it.
5. `docs/adr/repository/dora-explains.md`: one entry for ADR-REPO-PLANS (small batches; a plan that is the delta keeps work small and
   visible). Check: Test-Links.
6. `automation/Catzc.Base.QualityGates/Test-Plans.ps1`, new gate, with `configs/plans.yml` (folder, head keys, required sections, name
   patterns including `plan-master.md` and `task[0-9]{3}.md`, max task number 50; defaults declared once on `PlansConfig.cs`): for every
   `plan-*.md` the head keys exist, the sections exist in order, every open step has "(check:", every target path exists, the name is a
   stable locator; for `taskNNN.md` the `task:` head and numbered steps; one finding per rule with the ADR-REPO-PLANS rule code. Tests on
   fixture folders under TestDrive with neutral names. Check: its Pester file passes; the gate passes on `.claude/plans` (background).
7. `languages.yml` markdown `checks:` gains `Test-Plans`, scoped by the gate itself to `.claude/plans`. Check: LanguagesConfig tests;
   `Test-Change` on a plan file runs it.
8. `agents.yml` plan-clear: `supported_by: [ADR-REPO-PLANS#5, ADR-PRIN-ONELIVE#1, ADR-PRIN-NOWASTE#1]`, `checks: [Test-Links, Test-Plans]`.
   Check: Test-AgentDefinitions clean.
9. `.claude/CLAUDE.md` line 145: "Plans go in out/" becomes "Plans are authored in `.claude/plans/plan-<topic>.md` (ADR-REPO-PLANS); the
   master and task files are derived; a done plan is deleted". The Project structure bullet for `.unordered` or `docs/adr` gains nothing;
   the terminology of T009 (landing zone) is cited where `.unordered` is named. Check: Test-Links, Test-Terminology clean on CLAUDE.md.
10. `plan-plans-body-sha-landing-zone.md`: tick Phase 2 and the CLAUDE.md step. `plan-file-head-immutable-edges-classes.md`: tick the Q45
    naming-rule step. `plan-master.md` Process: cite ADR-REPO-PLANS#8 instead of "to be written". Check: Test-Plans clean on the folder.

## Report

As report-fixed; the Test-Plans verdict on this folder verbatim.
