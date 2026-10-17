---
task:
  id: "019"
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: P3 after task018; P4 and P6 on the user's explicit go (D10), in a quiet window with no peer-dirty files
  targets: [docs/explanation/automation, docs/how-to/automation, docs/references/automation, automation, .catzc, out, .github, pipelines]
catzc:
  immutable:
    with_body_sha: cd878f8ffc2b
    repo_status: clean
    path: ".claude/plans/task019.md"
    folder: plans
    name: task019
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task019: layers P3 classification, then the flip P4 and the pipeline names P6

P3 changes no path: it classifies pages and drafts ADR wording against the placeholder TRACK. P4 is the one phase that cannot be
interleaved: `git mv automation pwsh` in the user's window, run by the user (a mutating git command). P6 renames the externally bound
pipeline names the same day the user re-points Azure DevOps and GitHub. P8 diagrams are dropped (Q23).

## Steps

1. P3 classification table in the plan: every hand page in `docs/explanation/automation`, `docs/how-to/automation`,
   `docs/how-to/getting-started/automation` and the 56 hand pages inside `docs/references/automation`: page, topic, move (a pwsh topic) or
   stay (an abstract topic). `docs/adr/automation` stays (Q4). Check: every page has a row; report and stop.
2. ADR rules that state the folder as a fact (worklist section 7): list each with its new wording against TRACK; no edit until P4. Check:
   the list in the plan.
3. P4 preconditions recorded: P1 to P3 green on touched files; `git status` shows no peer-dirty file; a hook-recovery path exists out of
   band; the user has named the window (D10). Check: four lines in the plan, each true.
4. P4, the user runs: `git mv automation pwsh`; `.catzc/<track>` becomes `.catzc/pwsh`; build outputs `out/pwsh/built` and
   `out/pwsh/packages` (Q6); the tracks registry row and the one bootstrap constant change to pwsh; `Build-RootConfig` regenerates
   importer.ps1; the docs mirror `docs/references/automation` follows the folder for the moved pages of step 1. One source edit per step,
   generators after. Check: the P0 baseline gates green again (Test-GeneratedFiles, Test-Links, Test-Contracts, Test-WorldMap).
5. The ADR rules of step 2 edited to the present tree. Check: Test-AdrRegistry, Test-Links, Test-AdrEngineNeutrality clean.
6. P5 guards: avoid-phrasings for the retired uses ("automation folder", "automation track", "automation modules", "automation layer",
   "PowerShell automation") in `glossary.yml`; the P2 analyzer rule stays. Check: Test-Glossary clean; G4 reports none in tracked prose.
7. P6, one atomic set: `ci-automation` to `ci-pwsh`, `ci-automation-expected-failures` to `ci-pwsh-expected-failures`, the globset and
   `pipeline:` key, workflow and pipeline files, their file-name-keyed contract fragments, `docs/references/pipelines/*`, the README badge,
   `Test-GitHubWorkflowTriggerGlob` and `Register-AdoPipeline` examples. `invoke-automation` and `release-automation` stay (Q2). The user
   re-points the Azure DevOps definitions, GitHub required checks and bookmarks the same day. Check: triggers fire on the next push; the
   contract check is clean.
8. Tick P3, P4, P5 and P6 in the plan as each lands. Check: grep `- [ ]` counts P7 (task020) only.

## Report

As report-fixed; P4 is reported only after the user has run it.
