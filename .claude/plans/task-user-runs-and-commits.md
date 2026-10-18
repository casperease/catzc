---
task:
  status: open
  plans:
    [
      plan-plans-body-sha-landing-zone,
      plan-unboxing,
      plan-bounded-folder-enumeration,
      plan-file-head-immutable-edges-classes,
      plan-module-model-closeout,
      plan-test-run-budget,
      plan-root-config-fixtures,
      plan-out-artifacts,
      plan-fast-push-followups,
      plan-assert-wait,
      plan-explanation-drift-gaps,
    ]
  value: highest
  blocked_on: nothing; every step is the user's own run, commit or git operation
  targets: [.claude/plans, pwsh/.compiled, out, pipelines]
---

# Task: the user's runs, commits and git operations that close plans

Every step here is one the user does by hand, because agents never run mutating git, never run all tests, and never touch a remote
(ADR-AI; `.claude/CLAUDE.md`, No mutating git operations). Eleven plans wait on these steps and nothing else. An agent's part is to list
them in one place, keep the list true, and tick each plan when the user reports the verdict. Order: the commits first, since the full
test run reads the committed tree; then the run; then the remote runs.

## Steps

1. Commit the gitattributes template rename (`pwsh/.internal/assets/root/.gitattributes-template`). Check: `Test-GeneratedFiles` reports
   `Unstamped 0`; then plan-plans-body-sha-landing-zone's Phase 0 step is ticked and the plan is a closing-sweep candidate.
2. Run `Clear-ModuleTypeCache`, then commit the one surviving DLL pair in `pwsh/.compiled` with the unboxing types, tests and docs. Check:
   `ls pwsh/.compiled` shows one `Catzc.Types.*.dll`; `git status` clean for them; task-unboxing-closeout step 1 ticked.
3. `git mv pwsh/Catzc.Base.Globs/tests/FileKindReachability.Tests.ps1 pwsh/Catzc.Base.Globs/tests/Test-FileKindReachability.Tests.ps1`.
   Check: the source-conventions check in `Test-Automation.Tests.ps1` passes; task-assert-wait's suite step ticked.
4. `git rm` the done task files the master lists as "the task file goes with the user's git rm" (task-import-landing-zone,
   task-file-head-leftovers, task-lazy-types-load, task-kind-becomes-role, task-config-defaults-fragment, task-config-defaults-postures,
   task-config-defaults-variants, task-adr-auto-material, task-adr-link-cleanup), where still present. Check: `ls .claude/plans/task-*`
   lists only open tasks; `Test-Plans -Path .claude/plans` clean.
5. Run all tests (`Test-Automation`) once, and read the two real-repo failures reported earlier: the drawio.yml live-yaml test and RootConfig
   New-GitAttributes. Check: the report in `out/test-automation` lists no finding from the head shape, class selectors, path split
   (plan-file-head-immutable-edges-classes), the folder walker (plan-bounded-folder-enumeration) or the module model
   (plan-module-model-closeout step 9); each of those plans is then a closing-sweep candidate.
6. A second full run, for plan-test-run-budget step 3. Check: two shard manifests in `out/test-automation` exist for task-test-run-budget's
   shard re-check (an agent step, task-test-run-budget step 3).
7. Run `out/delete-probes-batch1.ps1`, then give a yes for batch two (`out/harvest-batch1-kept-young.txt`, 13 probes). Check: the listed
   files are gone, nothing in `out/harvest-keep.txt` is; task-out-artifacts steps 5 and 6 ticked.
8. Bind a key to the "Push dirty" task (`workbench.action.tasks.runTask`, args `Push dirty`) and run `Push-Dirty` once against the real
   remote. Check: one real run reported; plan-fast-push-followups' last step ticked, the plan a closing-sweep candidate;
   task-root-config-fixtures step 5 ticked.
9. The first measured watchpoint run: `Test-Automation -DiagnoseBlocking` once, and `importer.ps1 -DiagnoseBlocking` once, verdict lines
   kept in `out/`. Check: each watchpoint's worst tick is in the report; task-assert-wait steps 6 and 7 unblock.
10. `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`: list the approvers under `approver_group.members`, run
    `Sync-AdoEnvironmentApprovals -DryRun`, then without. Check: a second apply reports Unchanged for the group and all three checks, and a
    CD run to `shared-psub` waits for approval; task-explanation-drift-gaps step 4 ticked.
11. One CD run on main touching only `apex`, one main run and one PR run of `pipelines/ci-automation.yaml`. Check: `AFFECTED=True` in
    `cd-apex`, `AFFECTED=False` in `cd-shared` with its deploy stages skipped; `BuildArtifact` runs on main and is skipped on the PR;
    task-explanation-drift-gaps steps 2 and 3 ticked.
12. After task-layers-classification-flip step 7 (P6) lands: re-point the Azure DevOps pipeline definitions, the GitHub required checks and
    any bookmarks from `ci-automation` to `ci-pwsh` the same day. Check: the triggers fire on the next push.

## Report

As report-fixed: which steps the user reported done, with each verdict line, and which plans became closing-sweep candidates.
