---
task:
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: P6 on the user's explicit go, the same day the user re-points Azure DevOps and GitHub
  targets: [pwsh, .github, pipelines, docs/references/pipelines, pwsh/Catzc.Base.Docs/configs/glossary.yml]
---

# Task: layers P6, the pipeline names

`automation/` is `pwsh/`. P6 renames the externally bound pipeline names the same day the user re-points Azure DevOps and GitHub, and
retires the `automation` layer form with them.

## Steps

1. P6, one atomic set: `ci-automation` to `ci-pwsh`, `ci-automation-expected-failures` to `ci-pwsh-expected-failures`, the globset and
   `pipeline:` key, workflow and pipeline files, their file-name-keyed contract fragments, `docs/references/pipelines/*`, the README badge,
   `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline` examples. `invoke-automation` and `release-automation` stay (Q2). In the same
   set: the `automation` form leaves the layer family in `glossary.yml`, the one remaining residue hit of the retired layer words
   (`git grep -i -E "automation folder|automation track|automation modules"` outside the plans and the glossary, 1 file on 2026-10-19) is
   reworded, and ADR-DSGN-TRACK-DEPLOYABLEUNIT drops "as `ci-automation` binds the automation track". The user re-points the Azure DevOps
   definitions, GitHub required checks and bookmarks the same day. Check: triggers fire on the next push; the contract check is clean;
   Test-Glossary reports no hit on the retired phrasings.
2. Tick P6 in the plan. Check: grep `- [ ]` in plan-layers-vocabulary-rename-contracts counts the stray-rules and drift-test steps only.

## Report

As report-fixed.
