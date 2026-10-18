---
task:
  status: open
  plans:
    [
      plan-plans-body-sha-landing-zone,
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
  blocked_on: nothing; every step is the user's own commit, git operation or remote run, and the last is the final session's full run
  targets: [.claude/plans, out, pipelines]
---

# Task: the user's commits, git operations, remote runs, and the one final full run

Every step here is one the user does by hand, because agents never run mutating git, never run all tests, and never touch a remote
(ADR-REPO-AI; `.claude/CLAUDE.md`, No mutating git operations). No task packs an expensive run into a step: a check is one test file under
`Invoke-TestFile`, one gate on named paths, a grep or a file read. The one full-repo proof is the last step here, a final new session that
dot-sources `importer.ps1` and runs `Test-Automation` once over the whole repository; every plan that "closes on green" closes on that run
and on nothing earlier. The typed DLL under `pwsh/.compiled` changes as many agents work in the repository and is ignored by every step.
Order: the commits and git operations first, the remote runs next, the final full run last.

## Steps

1. Commit the gitattributes template rename (`pwsh/.internal/assets/root/.gitattributes-template`). Check: `Test-GeneratedFiles` reports
   `Unstamped 0`, so `importer.ps1` and `importer.sh` no longer appear; then plan-plans-body-sha-landing-zone's Phase 0 step is ticked and
   the plan is a closing-sweep candidate.
2. `git mv pwsh/Catzc.Base.Globs/tests/FileKindReachability.Tests.ps1 pwsh/Catzc.Base.Globs/tests/Test-FileKindReachability.Tests.ps1`.
   Check: `Invoke-TestFile` on `Test-Automation.Tests.ps1` passes its source-conventions case; task-assert-wait step 4 ticked.
3. Run `out/delete-probes-batch1.ps1`, then give a yes for batch two (`out/harvest-batch1-kept-young.txt`, 13 probes). Check: the listed
   files are gone, nothing in `out/harvest-keep.txt` is; task-out-artifacts steps 5 and 6 ticked.
4. Bind a key to the "Push dirty" task (`workbench.action.tasks.runTask`, args `Push dirty`) and run `Push-Dirty` once against the real
   remote. Check: one real run reported; plan-fast-push-followups' last step ticked, the plan a closing-sweep candidate;
   task-root-config-fixtures step 5 ticked.
5. Done 2026-10-18 by session catzc-93 on the user's leave, verdict: "importer.ps1 -DiagnoseBlocking, one background run,
   out/diagnose-blocking.txt (52 lines). Worst ticks: Importer.psm1:136 late 12 ms (1.004 s measured), :141 12 ms (1.014 s), :166 13 ms
   (1.002 s), :183 14 ms (1.008 s); every watchpoint found no block" (12-14 ms is the Windows timer resolution). Original step: The first
   measured watchpoint run, cheap and direct: `importer.ps1 -DiagnoseBlocking` once, its four watchpoint lines kept in `out/`. The
   Test-Automation watchpoints are read only if the final session (step 9) adds `-DiagnoseBlocking`; nothing waits on that. Check: each
   importer watchpoint's worst tick is in the report; task-assert-wait steps 7 and 8 unblock.
6. `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`: list the approvers under `approver_group.members`, run
   `Sync-AdoEnvironmentApprovals -DryRun`, then without. Check: a second apply reports Unchanged for the group and all three checks, and a
   CD run to `shared-psub` waits for approval; task-explanation-drift-gaps step 4 ticked. Since 2026-10-18 the config lists 11 environments
   (release-uat with RC and pre-prod with RBC for shared, apex, nova and flux, plus the three prod-tier ones), and the apply creates a
   missing environment (Kind=Environment, Created); the second apply reports Unchanged for all 11. 6b. Done 2026-10-18 (the check lists
   nothing). Delete the 35 `out/test-links/20261016-2012*` report folders (the user said yes 2026-10-18; a session's permission check
   refused the `rm -rf`, so it is the user's): `rm -rf out/test-links/20261016-2012*`. Check: `ls -d out/test-links/20261016-2012*` lists
   nothing; plan-clear-actions' step ticked.
7. One CD run on main touching only `apex`, one main run and one PR run of `pipelines/ci-automation.yaml`. Check: `AFFECTED=True` in
   `cd-apex`, `AFFECTED=False` in `cd-shared` with its deploy stages skipped; `BuildArtifact` runs on main and is skipped on the PR;
   task-explanation-drift-gaps steps 2 and 3 ticked.
8. After task-layers-classification-flip step 7 (P6) lands: re-point the Azure DevOps pipeline definitions, the GitHub required checks and
   any bookmarks from `ci-automation` to `ci-pwsh` the same day. Check: the triggers fire on the next push. 8a.
   `git mv docs/references/.assets/automation docs/references/.assets/pwsh` (plan-automation-word-residue; its four follow-up steps,
   STYLE.md, conventional-folders.md, the link re-point and the eleven verify notes, wait on it). Check:
   `git ls-files    docs/references/.assets/automation` lists nothing. 8b. Record the plain moves of 2026-10-18 as renames with `git add` on
   both paths: Catzc.Base.Modules/Test-AspectDeclaration.ps1 and its test into Catzc.Base.Variants (catzc-fb), and Catzc.Base.Timeouts'
   Assert-Wait.ps1, its test and their two pages into Watch-Blocking (catzc-93). Check: `git status` shows them as renames.
9. The final full run, last of all, after every other task has landed: a new `pwsh` session, `. ./importer.ps1`, then `Test-Automation` once
   over the whole repository, by hand. Read its report in `out/test-automation` for the two real-repo failures reported earlier (the
   drawio.yml live-yaml test, RootConfig New-GitAttributes) and for any finding in the head shape, the class selectors, the path split
   (plan-file-head-immutable-edges-classes), the folder walker (plan-bounded-folder-enumeration) and the module model
   (plan-module-model-closeout step 9). Its shard manifest is the one task-test-run-budget step 3 reads. Check: the report lists no finding
   from those plans; each is then a closing-sweep candidate, and the last closing sweep follows.

## Report

As report-fixed: which steps the user reported done, with each verdict line, and which plans became closing-sweep candidates.
