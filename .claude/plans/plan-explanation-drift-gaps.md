---
plan:
  status: blocked
  value: high
  reviewed: 2026-10-19
  waits_on: the user's pipeline runs and the approval apply (task-user-runs-and-commits steps 1 and 2)
  targets: [.ado/pipelines, pwsh/Catzc.Azure.DevOps, docs/explanation]
---

# Explanation drift: the gaps between the code and the ADRs

The explanation articles under `docs/explanation/` close with a "Where the code and the ADR differ" section. Every claim in them was checked
against the tree and every decided fix landed; what is left is the proof on real pipeline runs and the user's approver list.

## Why its value is high

Until the approval apply runs, the CD runs deploy the prod tier with no gate (ADR-FLOW-CD-PRODAPPROVALGATE), the safety core of ADR-FLOW-CD.
The pipeline wiring of the affected check and the post-merge BVT is proven only once a real run shows it.

## Decided

- `TimeoutExemptionsConfig` keeps its shell axis: it is the engine list (`ExecutionEngines.Names`) for budgeted code, one mechanism per
  kind; cutting `bash` from it would special-case one engine, and no agent call can match an exemption anyway.

## Done

- `docs/explanation/design/only-pwsh-compiles-its-aspects.md` and its diagram folder, renamed through `Move-Diagram` on 2026-10-18:
  Build-Diagrams clean on the new folder, Test-Links over docs/ issues=0 (`out/test-links/20261018-200355`), `git grep` of the old name
  finds only the plans.

## Open steps

When a step lands, remove its claim from every article that states it (search `docs/explanation` for the function name) in the same change.

- [ ] `.ado/pipelines/cd-shared.yaml` and `.ado/pipelines/extends/cd-customer.yaml` on a real run: a run on main touching only `apex` shows
      the `Changes` step writing `AFFECTED=True` in `cd-apex` and `AFFECTED=False` in `cd-shared`, whose deploy stages then skip (check:
      those two run logs).
- [ ] `.ado/pipelines/ci-automation.yaml` on a real run: the `BuildArtifact` job runs `Test-BuildArtifact` on main and passes, and is
      skipped on a PR (check: one main run and one PR run).
- [ ] `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`: the user lists the approvers under `approver_group.members` and runs the
      apply (`Sync-AdoEnvironmentApprovals -DryRun`, then without); then the lifecycle articles drop the "prod with no gate" claims. The
      group's description is written at creation only, since a Graph group patch needs a JSON-patch content type the REST caller does not
      send (check: a second apply reports Unchanged for the group and all three checks, and a CD run to `shared-psub` waits for approval).

## Refs

- The articles' "Where the code and the ADR differ" sections under `docs/explanation/` hold each gap in the reader's words.
- `pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1` and `docs/how-to/automation/apply-environment-approvals.md` (the Q3 apply).
