---
task:
  status: open
  plans: [plan-explanation-drift-gaps]
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

1. `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`: list the approvers under `approver_group.members` (it holds the placeholder
   `prod-approver@example.com` until a real approver is listed), run `Sync-AdoEnvironmentApprovals -DryRun`, then without. The config lists
   11 environments (release-uat with RC and pre-prod with RBC for shared, apex, nova and flux, plus the three prod-tier ones), and the apply
   creates a missing environment (Kind=Environment, Created). Check: a second apply reports Unchanged for the group, all three checks and
   all 11 environments, and a CD run to `shared-psub` waits for approval; task-explanation-drift-gaps step 3 ticked.
2. One CD run on main touching only `apex`, one main run and one PR run of `pipelines/ci-automation.yaml`. Check: `AFFECTED=True` in
   `cd-apex`, `AFFECTED=False` in `cd-shared` with its deploy stages skipped; `BuildArtifact` runs on main and is skipped on the PR;
   task-explanation-drift-gaps steps 1 and 2 ticked.
3. After task-layers-classification-flip step 1 (P6) lands: re-point the Azure DevOps pipeline definitions, the GitHub required checks and
   any bookmarks from `ci-automation` to `ci-pwsh` the same day. Check: the triggers fire on the next push.
4. `git add .claude/plans/plan-importer-mix.md`, the one untracked plan, with the next plans commit. Check:
   `git status --short .claude/plans` shows no `??` line.
5. The moves of tracked files, each a `git mv` set the agent prepares in `out/run-user-git.ps1` when its chunk is ready, run by you before
   the agent's edits around the move: `pipelines/` to `.ado/pipelines/` and `docs/explanation/pipelines/` to `docs/explanation/ado/`
   (plan-ado-and-cicd-docs); `docs/adr/pwsh/*` to `docs/adr/automation/pwsh/` (plan-adr-automation-split); the `docs/adr/pipelines/*` files
   to `docs/adr/ado/` and `docs/adr/flow/` (plan-ado-and-cicd-docs); `.claude/drawio/*` to `python/Catzc.Diagrams/` and `.claude/slides/*`
   to its assets (plan-diagram-engine); `docs/adr/design/commit-lifecycle.md` with its `.assets/commit-lifecycle-states/` to
   `docs/adr/flow/` (plan-diagram-engine). Check: after each set, `git status --short` shows renames (`R`), not deletes and adds, and the
   plan's next step is taken.
6. The final full run: done 2026-10-18 (`out/test-automation/20261018-213325`, 0 failed); the run budget proven by the run of 21:47 (155.8
   s). It runs again, in a fresh session, when the chunks above have landed, as the one full-repo proof.

## Report

As report-fixed: which steps the user reported done, with each verdict line, and which plans became closing-sweep candidates.
