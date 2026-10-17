---
task:
  id: "028"
  status: open
  plans: [plan-out-artifacts]
  value: medium
  blocked_on: nothing; the probe deletions (steps 5 and 6) are the user's runs
  targets:
    [
      automation/Catzc.Base.Reports/configs/output-formats.yml,
      automation/Catzc.Base.Reports,
      docs/adr/repository/dedicated-output-directory.md,
      out,
    ]
---

# task028: output artifacts registered, pruned, and the out/ harvest closed

Decided (Q71 to Q74): the six out/ areas with their numbers are registered in output-formats.yml; sessions live under
`out/sessions/<session>/`; `time-safeguard.log` is never pruned; only `Clear-Output` prunes. The harvest of 2026-10-16 judged 260 scripts:
235 probes (delete in approved batches), 20 reruns (kept, named by their plans), 5 tool candidates (open steps in their owning plans).
The config lives at `automation/Catzc.Base.Reports/configs/output-formats.yml` (the plan head says Writers; correct the head in step 1).

## Steps

1. `plan-out-artifacts.md` head: `targets` names `Catzc.Base.Reports/configs/output-formats.yml`. Check: the path exists.
2. `output-formats.yml`: the six areas (cache, views, session scripts, logs, run folders, review PDFs) each a format with `area`, `keep` (N
   newest for run areas) and `prune: true|false` keys, defaults declared once on `OutputFormatsConfig`; `time-safeguard.log` `prune: false`;
   session artifacts placed under `out/sessions/<session>/`. Config tests updated. Check: the config type tests pass; Test-Links on the file.
3. `Clear-Output`: the prune honours the area defaults, keeps N newest per registered run area, never touches an unregistered path or a
   `prune: false` format; `-DryRun` lists. Tests in its Pester file with a fixture out/ under TestDrive. Check: the file passes;
   `run-out-retention-tests.ps1` in out/ becomes unnecessary and is listed for deletion.
4. `docs/adr/repository/dedicated-output-directory.md`: amendments for the areas, session placement, what prunes and when; `docs/references/out.md`
   regenerated or updated. Check: Test-AdrRegistry, Test-Links clean.
5. Batch one: the user runs `out/delete-probes-batch1.ps1` (222 probes older than 2026-10-16 14:57, listed in `out/harvest-batch1.txt`;
   `audit-file-kinds.ps1` and `count-kinds.ps1` pulled back as reruns). Check: the listed files are gone; nothing in `harvest-keep.txt` is.
6. Batch two: today's 13 probes in `harvest-batch1-kept-young.txt`, once their sessions are done; a yes, then the same. Check: gone.
7. The five tool candidates become open steps in their owning plans (task files): `run-head-batch`, `diff-one`, `probe-corpus`, `gates-module`
   in the file-head and plans tasks (QualityGates); `tests-comments-rollout` in task027 step 9 (done). Add one step line to task021 or task022
   for the QualityGates four, each "becomes a module function with tests or is recorded as not needed". Check: a grep of the task files finds
   each of the five names.
8. Tick the plan's steps; the carried draft goes; the plan is deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
