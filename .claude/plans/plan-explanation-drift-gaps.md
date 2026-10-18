---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets: [pipelines, pwsh/Catzc.Azure.DevOps, docs/explanation]
---

# Explanation drift: the gaps between the code and the ADRs

The explanation articles under `docs/explanation/` close with a "Where the code and the ADR differ" section. Every claim in them was
checked against the tree and every decided fix landed; what is left is the proof on real pipeline runs, the user's approver list, and one
article rename.

## Why its value is high

Until the approval apply runs, the CD runs deploy the prod tier with no gate (ADR-FLOW-CD-PRODAPPROVALGATE), the safety core of
ADR-FLOW-CD. The pipeline wiring of the affected check and the post-merge BVT is proven only once a real run shows it.

## Decided

- `TimeoutExemptionsConfig` keeps its shell axis: it is the engine list (`ExecutionEngines.Names`) for budgeted code, one mechanism per
  kind; cutting `bash` from it would special-case one engine, and no agent call can match an exemption anyway.

## Open steps

When a step lands, remove its claim from every article that states it (search `docs/explanation` for the function name) in the same change.

- [ ] `pipelines/cd-shared.yaml` and `pipelines/extends/cd-customer.yaml` on a real run: a run on main touching only `apex` shows the
      `Changes` step writing `AFFECTED=True` in `cd-apex` and `AFFECTED=False` in `cd-shared`, whose deploy stages then skip (check: those
      two run logs).
- [ ] `pipelines/ci-automation.yaml` on a real run: the `BuildArtifact` job runs `Test-BuildArtifact` on main and passes, and is skipped on
      a PR (check: one main run and one PR run).
- [ ] `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`: the user lists the approvers under `approver_group.members` and runs the
      apply (`Sync-AdoEnvironmentApprovals -DryRun`, then without); then the lifecycle articles drop the "prod with no gate" claims. The
      group's description is written at creation only, since a Graph group patch needs a JSON-patch content type the REST caller does not
      send (check: a second apply reports Unchanged for the group and all three checks, and a CD run to `shared-psub` waits for approval).
- [x] Rename `docs/explanation/design/only-automation-compiles-its-aspects.md` to `only-pwsh-compiles-its-aspects.md` with its diagram
      folder, through `Move-Diagram`; the user runs the two `Move-Diagram` calls by hand (task-user-runs-and-commits step 5), and a session
      then re-points the links left over (check: `Build-Diagrams -Path` on the new folder clean; Test-Links over docs/explanation clean; a
      grep for the old name over the tree finds only the plans' history). Done 2026-10-18 (the user's moves, `out/run-user-git.ps1`):
      "BUILD docs/explanation/design/.assets/only-pwsh-compiles-its-aspects prepare=clean highlight=clean join=clean", which regenerated
      the three pages that still named the old slug; Test-Links over docs/ issues=0 (`out/test-links/20261018-200355`); `git grep
      only-automation-compiles-its-aspects` finds this plan only.

## Refs

- The articles' "Where the code and the ADR differ" sections under `docs/explanation/` hold each gap in the reader's words.
- `pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1` and `docs/how-to/automation/apply-environment-approvals.md` (the Q3 apply).
