---
task:
  status: open
  plans: [plan-out-artifacts]
  value: medium
  blocked_on: nothing; the probe deletions (steps 5 and 6) are the user's runs
  targets:
    [
      pwsh/Catzc.Base.Reports/configs/output-formats.yml,
      pwsh/Catzc.Base.Reports,
      docs/adr/repository/dedicated-output-directory.md,
      out,
    ]
---

# Task: output artifacts registered, pruned, and the out/ harvest closed

Decided (Q71 to Q74): the six out/ areas with their numbers are registered in output-formats.yml; sessions live under
`out/sessions/<session>/`; `time-safeguard.log` is never pruned; only `Clear-Output` prunes. The harvest of 2026-10-16 judged 260 scripts:
235 probes (delete in approved batches), 20 reruns (kept, named by their plans), 5 tool candidates (open steps in their owning plans). The
config lives at `pwsh/Catzc.Base.Reports/configs/output-formats.yml` (the plan head says Writers; correct the head in step 1).

## Steps

1. [x] `plan-out-artifacts.md` head: `targets` names `Catzc.Base.Reports/configs/output-formats.yml`. Check: the path exists. In the tree
       before this task; the head's `blocked_on` ("four decisions in the draft", all decided Q71 to Q74) is removed 2026-10-17 and the plan
       is active.
2. [x] `output-formats.yml`: the six areas (cache, views, session scripts, logs, run folders, review PDFs) each a format with `area`, `keep`
       (N newest for run areas) and `prune: true|false` keys, defaults declared once on `OutputFormatsConfig`; `time-safeguard.log`
       `prune: false`; session artifacts placed under `out/sessions/<session>/`. Config tests updated. Check: the config type tests pass;
       Test-Links on the file. In the tree before this task (correction: the keys are `area`, `keep` and `max_age`, with `all` and `none`
       for "never", the area defaults on `OutputFormat`; the comment view is the review area; `session-folder` covers `sessions/**`). One
       gap closed 2026-10-17: `session-log` carried the log area's seven days, so the time safeguard log would have aged out; it now says
       `max_age: none` with its reason (Q73). `[Invoke-TestFile] Passed` OutputFormatsConfig.Tests (`out/test-file/20261017-204544-00807d`),
       `LINKS issues=0`.
3. [x] `Clear-Output`: the prune honours the area defaults, keeps N newest per registered run area, never touches an unregistered path or a
       `prune: false` format; `-DryRun` lists. Tests in its Pester file with a fixture out/ under TestDrive. Check: the file passes;
       `run-out-retention-tests.ps1` in out/ becomes unnecessary and is listed for deletion. The command and `OutputRetention` were in the
       tree; the command had no Pester file, so `Clear-Output.Tests.ps1` is new 2026-10-17 (a fixture root, the ten newest stamps, the
       seven-day session age, the log and the cache never pruned, an uncovered file reported, -DryRun, -All, an absent root):
       `[Invoke-TestFile] Passed` (`out/test-file/20261017-204554-c84f1e`), OutputRetention.Tests passed too (`20261017-204549-c02d2e`).
       `run-out-retention-tests.ps1` no longer exists in out/.
4. [x] `docs/adr/repository/dedicated-output-directory.md`: amendments for the areas, session placement, what prunes and when;
       `docs/references/out.md` regenerated or updated. Check: Test-AdrRegistry, Test-Links clean. The ADR already holds it as
       ADR-REPO-OUTDIR#12 with its Retention section; `docs/references/out.md` updated 2026-10-17: the clean-all is `Clear-Output -All`, and
       a paragraph names the formats, the areas, the never-pruned log and the session folder. Verdicts in the report.
5. Batch one: the user runs `out/delete-probes-batch1.ps1` (222 probes older than 2026-10-16 14:57, listed in `out/harvest-batch1.txt`;
   `audit-file-kinds.ps1` and `count-kinds.ps1` pulled back as reruns). Check: the listed files are gone; nothing in `harvest-keep.txt` is.
   2026-10-17: the script and the three harvest lists are no longer in out/, so either the user ran it or out/ was cleared; the user
   confirms.
6. Batch two: today's 13 probes in `harvest-batch1-kept-young.txt`, once their sessions are done; a yes, then the same. Check: gone. The
   list is gone with batch one; the user confirms.
7. [x] The five tool candidates become open steps in their owning plans (task files): `run-head-batch`, `diff-one`, `probe-corpus`,
       `gates-module` in the file-head and plans tasks (QualityGates); `tests-comments-rollout` in task-adr-link-cleanup step 9 (done). Add
       one step line to task-file-head-leftovers for the QualityGates four, each "becomes a module function with tests or is recorded as not
       needed". Check: a grep of the task files finds each of the five names. Done 2026-10-17: task-file-head-leftovers step 9 names the
       four; task-adr-link-cleanup step 9 names the fifth.
8. Tick the plan's steps; the carried draft goes; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.
