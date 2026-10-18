---
task:
  status: open
  plans: [plan-explanation-drift-gaps]
  value: high
  blocked_on: steps 2 to 4 are the user's runs (task-user-runs-and-commits); step 1 and step 5 can start now
  targets:
    [
      pwsh/Catzc.Base.Modules,
      pwsh/Catzc.Base.Variants,
      pwsh/Catzc.Base.Maps/Get-WorldMap.ps1,
      docs/explanation,
      pipelines,
      pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml,
    ]
---

# Task: the last gaps between the code and the ADRs

The triage and the small code fixes landed 2026-10-18; Q1 to Q8 are decided and most are in the tree. Left: one code move, three proofs on
real runs, and five slides that still draw retired claims. When a step lands, the claim it closes leaves every article under
`docs/explanation/` that states it, in the same change (search the function name).

## Steps

1. `Get-Aspect.ps1` and `Test-AspectDeclaration.ps1` move from `Catzc.Base.Modules` into `Catzc.Base.Variants` and read through the
   private `Get-Variant`, so `aspects` has one read path (ADR-REPO-VARIANT); their tests, the `.psd1` export lists, `Get-WorldMap`'s call,
   the Modules reference page (`docs/references/pwsh/catzc-base-modules.md`, one responsibility left) and the Variants count in
   `docs/explanation/repository/` and its slide follow. Check: the Variants, Modules and Maps L0 files pass; a grep for
   `Get-Config -Config variants` over `pwsh/**/*.ps1` hits only Catzc.Base.Variants; `Test-Links` on the edited pages; the final full run
   is the tree-wide proof.
2. Q1 proof: the user's CD run (task-user-runs-and-commits step 11). Check: the two run logs show `AFFECTED` true in `cd-apex` and false
   in `cd-shared`; the globset articles lose their "no caller" wording.
3. Q2 proof: the user's main and PR runs of `ci-automation.yaml` (the same step). Check: `BuildArtifact` ran on main, skipped on the PR.
4. Q3 apply: the user's `Sync-AdoEnvironmentApprovals` run (task-user-runs-and-commits step 10). Check: a second apply reports Unchanged;
   the lifecycle articles under `docs/explanation/design/` and `docs/explanation/flow/` drop the "prod with no gate" claims.
5. Q4 slides, a brief for the user to approve before any cell changes (cell removal is diagram work, not `write-drawio-files`): for each of
   `rule-and-gate-per-load-stage` (markers 7, 8), `what-gates-each-bundle-stage` (marker 6), `which-run-mode-rules-have-a-gate` (marker
   8), `drift-is-gated-generation-is-adr-only` (marker 8 and its title) and `tests-pin-the-throw-and-fail-open-no-caller` (marker 7 and
   its title), the elements to remove or relabel and the new title where one is due, written to `out/drift-slides-brief.md`. Check: the
   brief names five slides with their article, `.drawio.md` and minimap pages.
6. On the user's go: the five slides changed as the brief says (`write-drawio-files` for labels and titles; a new cell set is a
   `drawio-png` run per slide), the article text blocks and `.drawio.md` pages following, minimaps restamped. Check: each article's text
   blocks match its slide; `Test-Links` passes on the touched pages.
7. Tick the plan's steps; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero in plan-explanation-drift-gaps.

## Report

As report-fixed.
