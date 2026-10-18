---
prompt:
  for: a fresh session, LAST of all, after every other prompt-* session of 2026-10-18 has ended and the user has done the hand steps below
  written: 2026-10-18
  plan: plan-master
---

# Prompt: the final full run and the closing sweep

Before pasting this, the user does by hand, in this order (task-user-runs-and-commits steps 1 to 8): commit the gitattributes template
rename; `git mv` the reachability test to its `Test-` name; run `out/delete-probes-batch1.ps1` and batch two; bind the "Push dirty" key and
run `Push-Dirty` once; fill `approver_group.members` in `environment-approvals.yml` and run `Sync-AdoEnvironmentApprovals -DryRun` then
without; make the CD run on `apex`, the main run and the PR run of the CI pipeline; re-point the Azure DevOps definitions and GitHub
required checks to the renamed pipelines; commit everything the parallel sessions left. Then, in a new `pwsh`: `. ./importer.ps1`, then
`Test-Automation` once over the whole repository. Then paste this prompt.

You work in `C:\projects\catzc`, alone. Read `.claude/CLAUDE.md`, then `docs/adr/index.md` (cite rules by code, never sweep the corpus),
then `docs/adr/repository/ai-agent-contract.md`, then `.claude/plans/plan-master.md`, `.claude/plans/task-closing-sweep.md`,
`.claude/plans/task-user-runs-and-commits.md`, the newest report under `out/test-automation`, and every `out/reports/*.md`. This session may
edit `.claude/plans`. Do not rerun Test-Automation; read its report.

One plan file at a time, `Test-Links -Path <file>` after each: land every report in its owning plan the way `plan-intake` does, a step
ticked only with a verdict line the report or the tree gives, nothing discarded, a step the report left undone kept open with its reason;
read the full run's report for the plans that close on green (plan-bounded-folder-enumeration, plan-file-head-immutable-edges-classes,
plan-module-model-closeout step 9) and tick or keep each on what it says; record the shard table from its manifest in plan-test-run-budget;
record the user's hand steps as they report them; do the plan-folder steps of plan-automation-word-residue that its session skipped (the
`plan-clear` lines over plan-layers-vocabulary-rename-contracts, the P4 decision ADR-AUTO-LAYERS holds and task-layers-classification-flip),
one file at a time. Then the closing sweep: every plan with no open step and no open question is deleted with one "deleted, why" line in
`value-of-plan.md` and its row removed; its prompts and task files go with it; a plan with an open step stays. When no chunk of the master
is open, delete the master and every task file. Finish with `Test-Plans -Path .claude/plans` and `Test-Links` clean on the folder. No git
add, commit or push; the deletions are plain file deletions for the user's commit. Every Bash call runs under the time safeguard (foreground
`timeout: 3000`; longer work in the background behind a GNU `timeout` prefix).

End with a report to `out/reports/closeout.md`: plans deleted and why, plans kept with their open steps, findings of the full run that
belong to no plan, so the user sees in one page what the repository still owes.
