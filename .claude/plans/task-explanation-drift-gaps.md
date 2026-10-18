---
task:
  status: open
  plans: [plan-explanation-drift-gaps]
  value: high
  blocked_on: steps 1 to 3 are the user's runs (task-user-runs-and-commits)
  targets: [docs/explanation, pipelines, pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml]
---

# Task: the last gaps between the code and the ADRs

Three proofs on real runs are left. When a step lands, the claim it closes leaves every article under `docs/explanation/` that states it, in
the same change (search the function name).

## Steps

1. Q1 proof: the user's CD run (task-user-runs-and-commits step 2). Check: the two run logs show `AFFECTED` true in `cd-apex` and false in
   `cd-shared`; the globset articles lose their "no caller" wording.
2. Q2 proof: the user's main and PR runs of `ci-automation.yaml` (the same step). Check: `BuildArtifact` ran on main, skipped on the PR.
3. Q3 apply: the user's `Sync-AdoEnvironmentApprovals` run (task-user-runs-and-commits step 1). Check: a second apply reports Unchanged; the
   lifecycle articles under `docs/explanation/design/` and `docs/explanation/flow/` drop the "prod with no gate" claims.
4. Tick the plan's steps; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero in plan-explanation-drift-gaps.

## Report

As report-fixed.
