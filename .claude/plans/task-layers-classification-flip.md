---
task:
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: P6 on the user's explicit go, the same day the user re-points the GitHub bindings
  targets: [pwsh, .github, pipelines, docs/references/pipelines, pwsh/Catzc.Base.Docs/configs/glossary.yml]
---

# Task: layers P6, the pipeline names

`automation/` is `pwsh/`. P6 renames the externally bound pipeline names the same day the user re-points the GitHub bindings, and retires
the `automation` layer form with them.

## Steps

1. P6, one atomic set: `ci-automation` to `ci-pwsh`, `ci-automation-expected-failures` to `ci-pwsh-expected-failures`, the globset and
   `pipeline:` key, workflow and pipeline files, their file-name-keyed contract fragments, `docs/references/pipelines/*`, the README badge,
   `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline` examples. `invoke-automation` and `release-automation` stay (Q2). In the same
   set: the `automation` form leaves the layer family in `glossary.yml`, the one remaining residue hit of the retired layer words
   (`git grep -i -E "automation folder|automation track|automation modules"` outside the plans and the glossary, 1 file on 2026-10-19) is
   reworded, and ADR-DSGN-TRACK-DEPLOYABLEUNIT drops "as `ci-automation` binds the automation track". The user re-points the GitHub required
   checks and bookmarks the same day. Check: the contract check is clean; Test-Glossary reports no hit on the retired phrasings.
2. Delete plan-layers-vocabulary-rename-contracts and this task, since P6 is their last step. Check: Test-Plans clean.

## Report

As report-fixed.
